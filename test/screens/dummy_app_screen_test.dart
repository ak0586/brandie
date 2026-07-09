import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brandie_smart_post/screens/dummy_app_screen.dart';
import 'package:brandie_smart_post/models/share_target.dart';

void main() {
  testWidgets('DummyAppScreen renders correct UI based on ShareTarget', (WidgetTester tester) async {
    const target = ShareTarget(
      id: 'test_ig',
      platformName: 'Instagram Feed',
      iconPath: 'assets/icons/insta_post.png',
      platform: SharePlatform.instagram,
      variant: ShareVariant.feed,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: DummyAppScreen(target: target),
      ),
    );

    // Verify correct texts are displayed
    expect(find.text('Launched Instagram Feed'), findsOneWidget);
  });
}
