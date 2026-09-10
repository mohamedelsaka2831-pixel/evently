import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final authService = AuthService();
    final user = authService.currentUser;
    final displayName = (user?.displayName?.isNotEmpty ?? false)
        ? user!.displayName!
        : 'John Safwat';
    final email = user?.email ?? 'johnsafwat.route@gmail.com';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 44,
                backgroundColor: theme.primaryColor,
                backgroundImage: const AssetImage(AppImages.profileLogo),
              ),
              const SizedBox(height: 12),
              Text(
                displayName,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                email,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 28),
              _ProfileTile(
                leading: Icons.dark_mode_outlined,
                title: AppStrings.of(ar, 'dark_mode'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: themeProvider.toggleTheme,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileTile(
                leading: Icons.language_outlined,
                title: AppStrings.of(ar, 'language'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.read<LocaleProvider>().toggle(),
              ),
              const SizedBox(height: 12),
              _ProfileTile(
                leading: Icons.logout,
                iconColor: AppColors.logoutRed,
                title: AppStrings.of(ar, 'logout'),
                titleColor: AppColors.logoutRed,
                trailing: const Icon(Icons.chevron_right, color: AppColors.logoutRed),
                onTap: () async {
                  await authService.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData leading;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final Widget trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.leading,
    required this.title,
    required this.trailing,
    this.iconColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(leading, color: iconColor ?? theme.iconTheme.color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
