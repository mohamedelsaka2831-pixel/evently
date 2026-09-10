import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_images.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../services/auth_service.dart';
import '../main/main_nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (password != confirm) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);
    final error = await _authService.signUp(
      name: name,
      email: email,
      password: password,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      _showError(error);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
      (route) => false,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: ThemedIllustration(AppImages.logoSmall, height: 32)),
              const SizedBox(height: 32),
              Text(
                AppStrings.of(ar, 'create_account'),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                hint: AppStrings.of(ar, 'name_hint'),
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: AppStrings.of(ar, 'email_hint'),
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: AppStrings.of(ar, 'password_hint'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: AppStrings.of(ar, 'confirm_password_hint'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmController,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: AppStrings.of(ar, 'sign_up'),
                onPressed: _signUp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  children: [
                    Text(AppStrings.of(ar, 'have_account')),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        AppStrings.of(ar, 'login'),
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(AppStrings.of(ar, 'or')),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              SocialButton(
                label: AppStrings.of(ar, 'signup_google'),
                icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                onPressed: () {
                  // TODO: wire up GoogleSignIn + FirebaseAuth credential.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
