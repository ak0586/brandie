import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brandie_smart_post/widgets/edit_caption_sheet.dart';
import 'package:brandie_smart_post/models/smart_post_content.dart';

void main() {
  testWidgets('EditCaptionSheet toggles Save button when text changes', (WidgetTester tester) async {
    const post = SmartPostContent(
      id: '1',
      productName: 'P',
      productPrice: 10,
      discountPercent: 0,
      productTag: 'T',
      caption: 'Original Caption',
      hashtags: '#H',
      referralCode: 'R',
      referralLink: 'L',
      recommendedSong: 'S',
      recommendedArtist: 'A',
      productImageUrl: 'url1',
      productThumbnailUrl: 'url2',
      userAvatarUrl: 'url3',
    );
    SmartPostContent? savedPost;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditCaptionSheet(
            post: post,
            onSave: (newPost) {
              savedPost = newPost;
            },
          ),
        ),
      ),
    );

    // Initial state: Save button is disabled (has no onTap)
    final Finder saveButtonFinder = find.ancestor(of: find.text('Save'), matching: find.byType(GestureDetector));
    GestureDetector saveButton = tester.widget(saveButtonFinder);
    expect(saveButton.onTap, isNull);

    // Enter new text
    await tester.enterText(find.byType(TextField), 'Updated Caption');
    await tester.pump();

    // After typing, Save button is enabled (has onTap)
    saveButton = tester.widget(saveButtonFinder);
    expect(saveButton.onTap, isNotNull);

    // Tap Save
    await tester.tap(saveButtonFinder);
    expect(savedPost?.caption, 'Updated Caption');
  });
}
