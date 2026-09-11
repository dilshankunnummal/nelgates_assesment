import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/cloudinary_service.dart';
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'employee';
  
  XFile? _selectedImageFile;
  Uint8List? _webImageBytes;
  bool _isUploadingImage = false;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _fillEmployeeDemo() {
    _nameController.text = 'Alex Mercer';
    _emailController.text = AppConstants.employeeEmail;
    _phoneController.text = '+91 9876543210';
    _passwordController.text = AppConstants.employeePassword;
    _confirmPasswordController.text = AppConstants.employeePassword;
    setState(() {
      _selectedRole = 'employee';
    });
  }

  void _fillHrDemo() {
    _nameController.text = 'Sarah Jenkins';
    _emailController.text = AppConstants.hrEmail;
    _phoneController.text = '+91 9876501234';
    _passwordController.text = AppConstants.hrPassword;
    _confirmPasswordController.text = AppConstants.hrPassword;
    setState(() {
      _selectedRole = 'hr';
    });
  }

  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await _cloudinaryService.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedImageFile = pickedFile;
            _webImageBytes = bytes;
          });
        } else {
          setState(() {
            _selectedImageFile = pickedFile;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showGlassSnackBar(
          context,
          message: 'Failed to pick image: $e',
          type: GlassSnackBarType.error,
        );
      }
    }
  }

  Future<void> _submitRegistration() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      showGlassSnackBar(
        context,
        message: 'Passwords do not match.',
        type: GlassSnackBarType.error,
      );
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    String? uploadedImageUrl;
    if (_selectedImageFile != null) {
      try {
        uploadedImageUrl = await _cloudinaryService.uploadImage(
          imageFile: _selectedImageFile,
          folder: 'users/profile',
          userId: _emailController.text.trim().replaceAll('@', '_').replaceAll('.', '_'),
        );
      } catch (e) {
        uploadedImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
      }
    }

    setState(() {
      _isUploadingImage = false;
    });

    if (mounted) {
      context.read<AuthCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            profileImageUrl: uploadedImageUrl,
            role: _selectedRole,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          showGlassSnackBar(
            context,
            message: 'Welcome, ${state.session.user.name}!',
            type: GlassSnackBarType.success,
          );
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
        final isAuthLoading = state is AuthLoading || _isUploadingImage;

        return Scaffold(
          body: LiquidGlassBackground(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand Icon & Title
                        Container(
                          padding: const EdgeInsets.all(14),
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
                            Icons.person_add_alt_1_rounded,
                            size: 34,
                            color: primary,
                          ),
                        ),
                        AppSpacing.gapH12,
                        Text(
                          'Create Account',
                          style: AppTypography.displayMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          'Join ${AppConstants.appName} to unlock exclusive stays',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        AppSpacing.gapH20,

                        // Liquid Glass Registration Form Card
                        AppGlassCard(
                          padding: const EdgeInsets.all(22),
                          borderRadius: AppRadius.brXl,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Image Picker
                                Center(
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: isAuthLoading ? null : _pickProfileImage,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: primary.withValues(alpha: 0.4),
                                              width: 2,
                                            ),
                                            image: _selectedImageFile != null
                                                ? DecorationImage(
                                                    image: kIsWeb && _webImageBytes != null
                                                        ? MemoryImage(_webImageBytes!)
                                                        : FileImage(File(_selectedImageFile!.path)) as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            color: isDark
                                                ? Colors.white.withValues(alpha: 0.05)
                                                : Colors.black.withValues(alpha: 0.04),
                                          ),
                                          child: _selectedImageFile == null
                                              ? Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 30,
                                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                                )
                                              : null,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark ? AppColors.darkBackground : Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit_rounded,
                                            size: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppSpacing.gapH4,
                                Center(
                                  child: Text(
                                    'Upload Avatar (Cloudinary CDN)',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 10,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ),
                                AppSpacing.gapH16,

                                // Full Name Field
                                GlassTextField(
                                  controller: _nameController,
                                  labelText: 'Full Name',
                                  hintText: 'John Doe',
                                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty) ? 'Name is required' : null,
                                ),
                                AppSpacing.gapH12,

                                // Email Field
                                GlassTextField(
                                  controller: _emailController,
                                  labelText: 'Email Address',
                                  hintText: 'john@hotel.com',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                                  validator: Validators.validateEmail,
                                ),
                                AppSpacing.gapH12,

                                // Phone Field
                                GlassTextField(
                                  controller: _phoneController,
                                  labelText: 'Phone Number (Optional)',
                                  hintText: '+91 9876543210',
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                                ),
                                AppSpacing.gapH12,

                                // Role Selector
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Role:',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    AppSpacing.gapH8,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ChoiceChip(
                                            label: const Center(child: Text('Employee')),
                                            selected: _selectedRole == 'employee',
                                            selectedColor: primary.withValues(alpha: 0.25),
                                            onSelected: (selected) {
                                              if (selected) setState(() => _selectedRole = 'employee');
                                            },
                                          ),
                                        ),
                                        AppSpacing.gapW10,
                                        Expanded(
                                          child: ChoiceChip(
                                            label: const Center(child: Text('HR / Admin')),
                                            selected: _selectedRole == 'hr',
                                            selectedColor: primary.withValues(alpha: 0.25),
                                            onSelected: (selected) {
                                              if (selected) setState(() => _selectedRole = 'hr');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                AppSpacing.gapH12,

                                // Password Field
                                GlassTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Min 6 characters',
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
                                AppSpacing.gapH12,

                                // Confirm Password Field
                                GlassTextField(
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  hintText: 'Re-enter password',
                                  obscureText: _obscureConfirmPassword,
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (val != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                AppSpacing.gapH20,

                                // Register Glass Button
                                GlassButton(
                                  onPressed: isAuthLoading ? null : _submitRegistration,
                                  label: _isUploadingImage ? 'Uploading Avatar...' : 'Create Account',
                                  isPrimary: true,
                                  isLoading: isAuthLoading,
                                  width: double.infinity,
                                  height: 50,
                                ),
                                AppSpacing.gapH20,

                                // Quick Demo Accounts (Same as Login Page)
                                Center(
                                  child: Text(
                                    'Quick Demo Autofill:',
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
                                        onPressed: _fillEmployeeDemo,
                                        label: 'Employee Demo',
                                        height: 42,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                    ),
                                    AppSpacing.gapW12,
                                    Expanded(
                                      child: GlassButton(
                                        onPressed: _fillHrDemo,
                                        label: 'HR / Admin Demo',
                                        height: 42,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSpacing.gapH16,

                                // Back to Sign In Link
                                Center(
                                  child: TextButton(
                                    onPressed: () => context.pop(),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Already have an account? ',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Sign In',
                                            style: AppTypography.bodySmall.copyWith(
                                              color: primary,
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
