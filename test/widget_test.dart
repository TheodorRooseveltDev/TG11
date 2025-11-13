// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:bingo_clash/main.dart';
import 'package:bingo_clash/core/services/storage_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize storage
    final storage = StorageService();
    await storage.initialize();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(BingoClashApp(storage: storage));

    // Verify that our app starts
    expect(find.text('🎯 BINGO CLASH'), findsOneWidget);
  });
}
