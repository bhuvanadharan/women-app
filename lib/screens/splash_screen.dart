import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_repository.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/aster_mark.dart';
import 'auth/profile_setup_screen.dart';
import 'home/home_screen.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final _scale = Tween(
    begin: 0.92,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  Timer? _routeTimer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    // A Timer (not a bare Future.delayed) so it can actually be cancelled
    // in dispose() if the widget goes away before the splash delay elapses
    // — e.g. hot restart, or a widget test tearing down the tree early.
    _routeTimer = Timer(const Duration(milliseconds: 2000), _routeNext);
  }

  Future<void> _routeNext() async {
    if (!mounted) return;

    final user = AuthService.currentUser;
    // Module 2 signs every device into an anonymous session at app startup
    // (see ContactsService.init in main.dart) so contacts work before the
    // user finishes auth — that's a real `currentUser`, but not a signed-in
    // one, so it must not skip onboarding/phone-verification for a
    // brand-new install.
    if (user == null || user.isAnonymous) {
      Navigator.of(
        context,
      ).pushReplacement(slideRoute(const OnboardingScreen()));
      return;
    }

    // Already signed in from a previous session — skip onboarding/auth entirely.
    final profile = await UserRepository.getProfile(user.uid);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      slideRoute(
        profile?.profileComplete == true
            ? const HomeScreen()
            : const ProfileSetupScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _routeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AsterMark(size: 78),
                const SizedBox(height: 17),
                Text(
                  'ASTER',
                  style: AppTextStyles.h5.copyWith(
                    fontSize: 28,
                    letterSpacing: 5,
                    color: AppColors.primaryGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SAFETY, IN YOUR CORNER.',
                  style: AppTextStyles.b4.copyWith(
                    color: AppColors.neutral900,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
