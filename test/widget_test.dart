import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safe_her/screens/onboarding/onboarding_screen.dart';
import 'package:safe_her/screens/splash_screen.dart';
import 'package:safe_her/theme/app_theme.dart';

void main() {
  testWidgets('Splash screen shows Aster branding', (
    WidgetTester tester,
  ) async {
    // Pumps SplashScreen directly rather than the full app — the
    // app-level widget initializes Firebase Messaging in initState, which
    // needs a real Firebase.initializeApp() call (done in main(), not
    // here) and isn't what this test is actually checking.
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('ASTER'), findsOneWidget);
    expect(find.text('SAFETY, IN YOUR CORNER.'), findsOneWidget);
  });

  testWidgets('Onboarding advances through Aster safety features', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const OnboardingScreen()),
    );

    expect(find.text('ASTER'), findsOneWidget);
    expect(find.text('Support, right when you need it.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Let your people know you’re okay.'), findsOneWidget);
  });
}
