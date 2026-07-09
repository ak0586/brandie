import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brandie_smart_post/widgets/smart_post_tab_row.dart';

void main() {
  testWidgets('SmartPostTabRow renders tabs and responds to tap', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SmartPostTabRow(
                activeIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() => selectedIndex = index);
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify all tabs exist
    expect(find.text('Smart Post'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Communities'), findsOneWidget);
    expect(find.text('Share&Win'), findsOneWidget);

    // Tap on 'Library' (index 1)
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });
}
