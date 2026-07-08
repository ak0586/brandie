/// Represents a single AI-generated Smart Post.
class SmartPostContent {
  final String id;
  final String productName;
  final double productPrice;
  final int discountPercent;
  final String productTag;
  final String caption;
  final String hashtags;
  final String referralCode;
  final String referralLink;
  final String recommendedSong;
  final String recommendedArtist;
  final String productImageUrl; // network image URL (beauty product)
  final String productThumbnailUrl; // smaller thumbnail
  final String userAvatarUrl;

  const SmartPostContent({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.discountPercent,
    required this.productTag,
    required this.caption,
    required this.hashtags,
    required this.referralCode,
    required this.referralLink,
    required this.recommendedSong,
    required this.recommendedArtist,
    required this.productImageUrl,
    required this.productThumbnailUrl,
    required this.userAvatarUrl,
  });

  /// Returns the full display caption including hashtags and referral info.
  String get fullCaption =>
      '$caption\n\n$hashtags\n\nUse my referral code: $referralCode\nUse my referral link: $referralLink';

  /// Returns a copy of this post with an updated caption.
  SmartPostContent copyWith({String? caption}) {
    return SmartPostContent(
      id: id,
      productName: productName,
      productPrice: productPrice,
      discountPercent: discountPercent,
      productTag: productTag,
      caption: caption ?? this.caption,
      hashtags: hashtags,
      referralCode: referralCode,
      referralLink: referralLink,
      recommendedSong: recommendedSong,
      recommendedArtist: recommendedArtist,
      productImageUrl: productImageUrl,
      productThumbnailUrl: productThumbnailUrl,
      userAvatarUrl: userAvatarUrl,
    );
  }
}

