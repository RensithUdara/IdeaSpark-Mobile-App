// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:idea_spark/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IdeaSparkApp());

    // Verify that our app shows the splash screen with app name
    expect(find.text('IdeaSpark'), findsOneWidget);
    expect(find.text('Spark Your Next Big Idea'), findsOneWidget);
  });
}
