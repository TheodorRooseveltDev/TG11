import 'package:bingo_clash/core/services/storage_service.dart';
import 'package:bingo_clash/presentation/screens/home_screen.dart';
import 'package:bingo_clash/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String crashEsofAppOneSignalString = "6f9751fe-bc83-4f98-b6b6-72c6d4a30813";
String crashEsofAppDevKeypndAppId = "6755148932";

String crashEsofAppAfDevKey1 = "k44fs4P3rm";
String crashEsofAppAfDevKey2 = "naTrgHaKaj8K";

String crashEsofAppUrl = 'https://bingoclashduo.com/crashesofapp/';
String crashEsofAppStandartWord = "crashesofapp";

void crashEsofAppOpenStandartAppLogic(BuildContext context) async {
  final storage = context.read<StorageService>();
  final hasCompletedOnboarding = storage.hasCompletedOnboarding();

  // Navigate based on onboarding status
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => hasCompletedOnboarding
          ? const HomeScreen()
          : const OnboardingScreen(),
    ),
  );
}
