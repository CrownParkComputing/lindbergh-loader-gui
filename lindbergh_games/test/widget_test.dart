import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lindbergh_games/main.dart';

void main() {
  testWidgets('App starts and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lindbergh Games'), findsOneWidget);
  });
}
