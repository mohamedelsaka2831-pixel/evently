import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _totalPages = 4;

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _page = i),
          children: [
            _PersonalizePage(onStart: () => _goTo(1)),
            _InfoPage(
              illustration: AppImages.onboarding1,
              titleKey: 'onboarding1_title',
              descKey: 'onboarding1_desc',
              pageIndex: 1,
              totalPages: _totalPages,
              showSkip: true,
              showBack: false,
              buttonLabelKey: 'next',
              onSkip: _finish,
              onNext: () => _goTo(2),
            ),
            _InfoPage(
              illustration: AppImages.onboarding2,
              titleKey: 'onboarding2_title',
              descKey: 'onboarding2_desc',
              pageIndex: 2,
              totalPages: _totalPages,
              showSkip: true,
              showBack: true,
              buttonLabelKey: 'next',
              onBack: () => _goTo(1),
              onSkip: _finish,
              onNext: () => _goTo(3),
            ),
            _InfoPage(
              illustration: AppImages.onboarding3,
              titleKey: 'onboarding3_title',
              descKey: 'onboarding3_desc',
              pageIndex: 3,
              totalPages: _totalPages,
              showSkip: false,
              showBack: true,
              buttonLabelKey: 'get_started',
              onBack: () => _goTo(2),
              onNext: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return ThemedIllustration(AppImages.logoSmall, height: 28);
  }
}

class _PersonalizePage extends StatelessWidget {
  final VoidCallback onStart;
  const _PersonalizePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final ar = locale.isArabic;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Center(child: _Logo()),
          const SizedBox(height: 32),
          Center(
            child: ThemedIllustration(AppImages.onboarding0, height: 200),
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.of(ar, 'personalize_title'),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.of(ar, 'personalize_desc'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.of(ar, 'language'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _PillOption(
                label: 'English',
                selected: !ar,
                onTap: () => locale.setArabic(false),
              ),
              const SizedBox(width: 10),
              _PillOption(
                label: 'Arabic',
                selected: ar,
                filled: false,
                onTap: () => locale.setArabic(true),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.of(ar, 'theme'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _IconPill(
                icon: Icons.wb_sunny_outlined,
                selected: !themeProvider.isDarkMode,
                onTap: () => themeProvider.toggleTheme(false),
              ),
              const SizedBox(width: 10),
              _IconPill(
                icon: Icons.nightlight_outlined,
                selected: themeProvider.isDarkMode,
                onTap: () => themeProvider.toggleTheme(true),
              ),
            ],
          ),
          const Spacer(),
          CustomButton(label: AppStrings.of(ar, 'lets_start'), onPressed: onStart),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  const _PillOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? theme.primaryColor : AppColors.textSecondaryLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _IconPill({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? theme.primaryColor : AppColors.textSecondaryLight,
          ),
        ),
        child: Icon(icon, color: selected ? Colors.white : theme.iconTheme.color, size: 20),
      ),
    );
  }
}

class _InfoPage extends StatelessWidget {
  final String illustration;
  final String titleKey;
  final String descKey;
  final int pageIndex;
  final int totalPages;
  final bool showSkip;
  final bool showBack;
  final String buttonLabelKey;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;

  const _InfoPage({
    required this.illustration,
    required this.titleKey,
    required this.descKey,
    required this.pageIndex,
    required this.totalPages,
    required this.showSkip,
    required this.showBack,
    required this.buttonLabelKey,
    required this.onNext,
    this.onSkip,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleProvider>().isArabic;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showBack
                  ? IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    )
                  : const SizedBox(width: 40),
              const _Logo(),
              showSkip
                  ? TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      ),
                      child: Text(
                        AppStrings.of(ar, 'skip'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: ThemedIllustration(illustration, height: 220),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages - 1, (i) {
                final active = i == pageIndex - 1;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? theme.primaryColor : AppColors.textSecondaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.of(ar, titleKey),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.of(ar, descKey),
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondaryLight, height: 1.5),
          ),
          const SizedBox(height: 24),
          CustomButton(label: AppStrings.of(ar, buttonLabelKey), onPressed: onNext),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
