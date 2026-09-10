import 'package:flutter/material.dart';


class AppImages {
  AppImages._();

  static const String logoSplash = 'assets/images/evently_logo_splash.png';
  static const String logoSmall = 'assets/images/evently_logo2.png';
  static const String routeLogo = 'assets/images/route_logo.png';
  static const String profileLogo = 'assets/images/profile_logo.png';
  static const String forgetPassword = 'assets/images/forget_password.png';


  static const String onboarding0 = 'assets/images/splash_1.png';
  static const String onboarding1 = 'assets/images/splash_2.png';
  static const String onboarding2 = 'assets/images/splash3.png';
  static const String onboarding3 = 'assets/images/splash4.png';


  static const String birthday = 'assets/images/birthday.png';
  static const String bookClub = 'assets/images/book_club.png';
  static const String sport = 'assets/images/sport.png';
  static const String exhibition = 'assets/images/exhibition.png';
  static const String meeting = 'assets/images/meeting.png';


  static String themed(String lightPath, bool isDark) {
    if (!isDark) return lightPath;
    final dotIndex = lightPath.lastIndexOf('.');
    return '${lightPath.substring(0, dotIndex)}_dark${lightPath.substring(dotIndex)}';
  }
}

class ThemedIllustration extends StatelessWidget {
  final String lightPath;
  final double? height;
  final double? width;
  final BoxFit fit;

  const ThemedIllustration(
    this.lightPath, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final path = AppImages.themed(lightPath, isDark);
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.image_outlined,
        size: (height ?? 120) * 0.6,
        color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
      ),
    );
  }
}
