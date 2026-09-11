import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractivePressEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final double minScale;
  final Duration scaleDuration;
  final Color? rippleColor;
  final bool enableHaptics;
  final bool enablePointExpand;
  final bool isDisabled;

  const InteractivePressEffect({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.minScale = 0.955,
    this.scaleDuration = const Duration(milliseconds: 140),
    this.rippleColor,
    this.enableHaptics = true,
    this.enablePointExpand = true,
    this.isDisabled = false,
  });

  @override
  State<InteractivePressEffect> createState() => _InteractivePressEffectState();
}

class _InteractivePressEffectState extends State<InteractivePressEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleRadiusAnimation;
  late Animation<double> _rippleOpacityAnimation;

  Offset _tapPosition = Offset.zero;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _rippleRadiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOutQuart),
    );

    _rippleOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.28).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.28, end: 0.0).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 70,
      ),
    ]).animate(_rippleController);
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled || (widget.onTap == null && widget.onLongPress == null)) return;

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _isPressed = true;
      _tapPosition = details.localPosition;
    });

    if (widget.enablePointExpand) {
      _rippleController.forward(from: 0.0);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (widget.isDisabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = !widget.isDisabled && (widget.onTap != null || widget.onLongPress != null);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(16);

    final defaultBloomColor = widget.rippleColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.35)
            : const Color(0xFF0F172A).withValues(alpha: 0.18));

    Widget content = widget.child;

    if (widget.enablePointExpand) {
      content = Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          content,
          Positioned.fill(
            child: ClipRRect(
              borderRadius: effectiveRadius,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _rippleController,
                  builder: (context, _) {
                    if (!_rippleController.isAnimating && _rippleController.value == 0.0) {
                      return const SizedBox.shrink();
                    }
                    return CustomPaint(
                      painter: _PointExpandPainter(
                        center: _tapPosition,
                        progress: _rippleRadiusAnimation.value,
                        opacity: _rippleOpacityAnimation.value,
                        color: defaultBloomColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTapDown: isInteractive ? _handleTapDown : null,
      onTapUp: isInteractive ? _handleTapUp : null,
      onTapCancel: isInteractive ? _handleTapCancel : null,
      onTap: isInteractive ? widget.onTap : null,
      onLongPress: isInteractive ? widget.onLongPress : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed && isInteractive ? widget.minScale : 1.0,
        duration: widget.scaleDuration,
        curve: _isPressed ? Curves.easeOutQuad : Curves.elasticOut,
        child: content,
      ),
    );
  }
}

class _PointExpandPainter extends CustomPainter {
  final Offset center;
  final double progress;
  final double opacity;
  final Color color;

  _PointExpandPainter({
    required this.center,
    required this.progress,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.001) return;

    final maxRadius = (size.width + size.height) * 0.95;
    final currentRadius = maxRadius * progress;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.45),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _PointExpandPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.opacity != opacity ||
        oldDelegate.center != center ||
        oldDelegate.color != color;
  }
}
