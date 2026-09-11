import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_snackbar.dart';
import '../../../../core/widgets/glass/glass_text_field.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillEmployee() {
    _emailController.text = AppConstants.employeeEmail;
    _passwordController.text = AppConstants.employeePassword;
  }

  void _fillHr() {
    _emailController.text = AppConstants.hrEmail;
    _passwordController.text = AppConstants.hrPassword;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(RouteNames.home);
        } else if (state is AuthError) {
          showGlassSnackBar(
            context,
            message: state.message,
            type: GlassSnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: LiquidGlassBackground(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand icon & title
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primaryLight.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.1),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.primaryLight.withValues(alpha: 0.3)
                                  : AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.hotel_class_rounded,
                            size: 40,
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                          ),
                        ),
                        AppSpacing.gapH16,
                        Text(
                          AppConstants.appName,
                          style: AppTypography.displayLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          AppConstants.appTagline,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        AppSpacing.gapH24,

                        // True Liquid Glass Login Card (No gradients inside)
                        AppGlassCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: AppRadius.brXl,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                AppSpacing.gapH4,
                                Text(
                                  'Sign in to explore boutique resorts & villas',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                                AppSpacing.gapH20,

                                // Email Field
                                GlassTextField(
                                  controller: _emailController,
                                  labelText: 'Email or Phone',
                                  hintText: 'name@hotel.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                                  validator: Validators.validateEmail,
                                ),
                                AppSpacing.gapH16,

                                // Password Field
                                GlassTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  obscureText: _obscurePassword,
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  validator: Validators.validatePassword,
                                ),
                                AppSpacing.gapH24,

                                // Submit Glass Button
                                GlassButton(
                                  onPressed: isLoading ? null : _submit,
                                  label: 'Sign In',
                                  isPrimary: true,
                                  isLoading: isLoading,
                                  width: double.infinity,
                                  height: 50,
                                ),
                                AppSpacing.gapH20,

                                // Demo accounts banner
                                Center(
                                  child: Text(
                                    'Quick Demo Accounts:',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ),
                                AppSpacing.gapH8,
                                Row(
                                  children: [
                                    Expanded(
                                      child: GlassButton(
                                        onPressed: _fillEmployee,
                                        label: 'Employee Login',
                                        height: 42,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                    ),
                                    AppSpacing.gapW12,
                                    Expanded(
                                      child: GlassButton(
                                        onPressed: _fillHr,
                                        label: 'HR Login',
                                        height: 42,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSpacing.gapH16,

                                // Register link
                                Center(
                                  child: TextButton(
                                    onPressed: () => context.push('/register'),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Don't have an account? ",
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Sign Up',
                                            style: AppTypography.bodySmall.copyWith(
                                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
