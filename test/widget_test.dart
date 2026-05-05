import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lab_panic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the Lab Panic menu after the splash screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'lab_panic_best_score': 240});

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1600));

    expect(find.text('LAB PANIC'), findsOneWidget);
    expect(find.text('Jogar'), findsOneWidget);
    expect(find.text('Melhor pontuação'), findsOneWidget);
    await tester.pump();

    expect(find.text('240'), findsWidgets);
  });
}
