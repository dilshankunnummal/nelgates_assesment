import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // 1. Kick off checkAuthSession to load saved session from Hive / Firebase
    await context.read<AuthCubit>().checkAuthSession();

    // 2. Allow splash animation to finish smoothly
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_animController.isCompleted) {
          if (state is Authenticated) {
            context.go(RouteNames.home);
          } else if (state is Unauthenticated || state is AuthError) {
            context.go(RouteNames.login);
          }
        }
      },
      child: Scaffold(
        body: LiquidGlassBackground(
          child: Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Glass Icon Container
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primaryLight.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.primaryLight.withValues(alpha: 0.35)
                                  : AppColors.primary.withValues(alpha: 0.25),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: isDark ? 0.3 : 0.2),
                                blurRadius: 36,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.hotel_class_rounded,
                            size: 56,
                            color: primary,
                          ),
                        ),
                        AppSpacing.gapH24,

                        // App Title
                        Text(
                          AppConstants.appName,
                          style: AppTypography.displayLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        AppSpacing.gapH8,

                        // Tagline
                        Text(
                          AppConstants.appTagline,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            letterSpacing: 0.2,
                          ),
                        ),
                        AppSpacing.gapH32,

                        // Subtle Liquid Loading indicator
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
