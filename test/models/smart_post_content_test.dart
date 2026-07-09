import 'package:flutter_test/flutter_test.dart';
import 'package:brandie_smart_post/models/smart_post_content.dart';

void main() {
  group('SmartPostContent', () {
    test('copyWith updates specified fields and retains others', () {
      final original = SmartPostContent(
        id: '1',
        productName: 'Original Product',
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

      final updated = original.copyWith(caption: 'New Caption');

      expect(updated.id, original.id);
      expect(updated.productName, original.productName);
      expect(updated.caption, 'New Caption');
    });
  });
}
