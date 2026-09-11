import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/common/user_avatar.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_alert_dialog.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _confirmLogout(BuildContext context) async {
    final confirmed = await showGlassAlertDialog(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out of Booking.com?',
      cancelLabel: 'Cancel',
      confirmLabel: 'Sign Out',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().logout();
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: LiquidGlassBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                String userName = 'Guest User';
                String userEmail = 'employee@hotel.com';
                String userRole = 'employee';
                String? avatarUrl;

                if (authState is Authenticated) {
                  userName = authState.session.user.name;
                  userEmail = authState.session.user.email;
                  userRole = authState.session.user.role;
                  avatarUrl = authState.session.user.avatar;
                }

                return AppGlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: AppRadius.brXl,
                  child: Row(
                    children: [
                      UserAvatar(
                        imageUrl: avatarUrl,
                        name: userName,
                        size: 58,
                      ),
                      AppSpacing.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            AppSpacing.gapH2,
                            Text(
                              userEmail,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            AppSpacing.gapH6,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.15),
                                borderRadius: AppRadius.brSm,
                                border: Border.all(color: primary.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                userRole.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 9,
                                  color: primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            AppSpacing.gapH24,

            // Preferences Section
            Text(
              'Preferences',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            AppSpacing.gapH10,
            AppGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: AppRadius.brLg,
              child: Column(
                children: [
                  // Dark mode toggle
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final isDarkActive = themeMode == ThemeMode.dark;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isDarkActive ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: primary,
                        ),
                        title: Text(
                          'Dark Theme',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        subtitle: Text(
                          isDarkActive ? 'Dark luxury aesthetic' : 'Bright clean aesthetic',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        trailing: Switch(
                          value: isDarkActive,
                          activeThumbColor: primary,
                          onChanged: (val) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.currency_rupee_rounded, color: primary),
                    title: Text(
                      'Preferred Currency',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    trailing: Text(
                      'INR (₹)',
                      style: AppTypography.labelMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH24,

            // App Information Section
            Text(
              'About Application',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            AppSpacing.gapH10,
            AppGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: AppRadius.brLg,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.info_outline_rounded, color: primary),
                    title: Text(
                      'App Version',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    trailing: Text(
                      AppConstants.appVersion,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH32,

            // Logout Action
            GlassButton(
              onPressed: () => _confirmLogout(context),
              label: 'Sign Out',
              icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
              textColor: AppColors.error,
              isPrimary: false,
              borderColor: AppColors.error.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
