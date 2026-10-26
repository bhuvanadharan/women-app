import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/aster_mark.dart';
import '../../widgets/onboarding_dots.dart';
import '../../widgets/primary_button.dart';
import '../auth/signup_screen.dart';

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.accent,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
  });

  final IconData icon;
  final Color accent;
  final String label;
  final String title;
  final String subtitle;
  final String buttonLabel;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.sos_rounded,
      accent: Color(0xFFF7DAD4),
      label: 'HELP, ONE TAP AWAY',
      title: 'Support, right when you need it.',
      subtitle: 'Press SOS or shake twice. Your trusted people can be alerted.',
      buttonLabel: 'Next',
    ),
    _OnboardingPageData(
      icon: Icons.location_on_outlined,
      accent: Color(0xFFDDEBE1),
      label: 'ALWAYS IN THE LOOP',
      title: 'Let your people know you’re okay.',
      subtitle: 'Share your live location with the people you trust.',
      buttonLabel: 'Next',
    ),
    _OnboardingPageData(
      icon: Icons.route_outlined,
      accent: Color(0xFFE8E5D6),
      label: 'THOUGHTFUL SAFETY TOOLS',
      title: 'Take the safer next step.',
      subtitle:
          'Find safer routes, nearby help, and secure evidence in one place.',
      buttonLabel: 'Get started',
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).pushReplacement(slideRoute(const SignupScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Row(
                children: [
                  const AsterMark(size: 36),
                  const SizedBox(width: 9),
                  Text(
                    'ASTER',
                    style: AppTextStyles.calloutBold.copyWith(
                      color: AppColors.primaryGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Center(child: _OnboardingArtwork(page: _pages[i])),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      key: ValueKey(_index),
                      children: [
                        Text(
                          _pages[_index].label,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.b5.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          _pages[_index].title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h5.copyWith(
                            fontSize: 27,
                            color: AppColors.primaryGrey,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          _pages[_index].subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.b3.copyWith(
                            color: AppColors.neutral900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  OnboardingDots(count: _pages.length, index: _index),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _pages[_index].buttonLabel,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingArtwork extends StatelessWidget {
  const _OnboardingArtwork({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.98,
      child: Container(
        decoration: BoxDecoration(
          color: page.accent,
          borderRadius: BorderRadius.circular(36),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: -42, right: -35, child: _OutlineCircle(size: 190)),
            Positioned(
              bottom: -84,
              left: -40,
              child: _OutlineCircle(size: 210),
            ),
            Container(
              width: 164,
              height: 164,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.82),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGrey,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Icon(page.icon, color: AppColors.accent, size: 52),
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 25,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'You’re not alone',
                      style: AppTextStyles.b4.copyWith(
                        color: AppColors.primaryGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineCircle extends StatelessWidget {
  const _OutlineCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGrey.withValues(alpha: 0.08),
          width: 26,
        ),
      ),
    );
  }
}
