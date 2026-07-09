import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brandie_smart_post/widgets/smart_post_app_bar.dart';

void main() {
  testWidgets('SmartPostAppBar renders components correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SmartPostAppBar(),
        ),
      ),
    );

    // Verify Oriflame Logo Text exists
    expect(find.text('ORIFLAME'), findsOneWidget);
    expect(find.text('SWEDEN'), findsOneWidget);

    // Verify the buttons exist
    expect(find.text('Your Assistant'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
  });
}
