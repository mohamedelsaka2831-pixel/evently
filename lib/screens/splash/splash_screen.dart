import 'package:flutter/material.dart';
import '../../core/theme/app_images.dart';
import '../../services/auth_service.dart';
import '../main/main_nav_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // Already-signed-in users skip onboarding/login and land straight on Home.
      final isSignedIn = AuthService().currentUser != null;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isSignedIn ? const MainNavScreen() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Center(
              child: ThemedIllustration(AppImages.logoSplash, width: 220, fit: BoxFit.contain),
            ),
            const Spacer(flex: 4),
            Column(
              children: [
                ThemedIllustration(AppImages.routeLogo, height: 32),
                const SizedBox(height: 4),
                Text(
                  'Supervised by Mohamed Nabil',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
