import '../models/smart_post_content.dart';
import '../models/share_target.dart';

/// Hardcoded mock data. Replace with API calls in production.
/// All three posts use Oriflame product copy matching the Figma screenshots.
class MockData {
  MockData._();

  static const String _userAvatar = 'https://i.pravatar.cc/150?img=47';

  static final List<SmartPostContent> posts = [
    SmartPostContent(
      id: 'post_1',
      productName: 'Giordani Gold Lipstick',
      productPrice: 14.99,
      discountPercent: 30,
      productTag: 'Trending right now and on sale',
      caption:
          '💄 Elevate your beauty with the Giordani Gold - Eternal Glow Lipstick SPF 25! This luxurious creamy lipstick doesn\'t just promise rich pigments but brings you the benefits of hyaluronic acid and collagen-boosting peptides too. Pamper your lips with care while enjoying a long-lasting, luminous matte colour.',
      hashtags: '💄✨ #Oriflame #GiordaniGold #LipCareGoals',
      referralCode: 'UK-AMANDA3012',
      referralLink: 'www.oriflame.com/giordani/amanda3012',
      recommendedSong: 'Bad Habits',
      recommendedArtist: 'Ed Sheeran',
      productImageUrl: 'assets/post/post1_lipstick.png',
      productThumbnailUrl: 'assets/post/post1_lipstick.png',
      userAvatarUrl: _userAvatar,
    ),
    SmartPostContent(
      id: 'post_2',
      productName: 'Éclat Amour Fragrance',
      productPrice: 29.99,
      discountPercent: 20,
      productTag: 'New arrival – top seller this week',
      caption:
          '✨ Experience the elegance of Éclat Amour—a fragrance that captures the essence of romance and sophistication. Let every spritz wrap you in timeless charm and effortless allure. 💕',
      hashtags: '#EclatAmour #TimelessElegance',
      referralCode: 'UK-AMANDA3012',
      referralLink: 'www.oriflame.com/giordani/amanda3012',
      recommendedSong: 'Unstoppable',
      recommendedArtist: 'Sia',
      productImageUrl: 'assets/post/post2_perfume.png',
      productThumbnailUrl: 'assets/post/post2_perfume.png',
      userAvatarUrl: _userAvatar,
    ),
    SmartPostContent(
      id: 'post_3',
      productName: 'WonderLash Mascara',
      productPrice: 18.50,
      discountPercent: 25,
      productTag: 'Customer favourite – restocked!',
      caption:
          'Unlock the power of bold, beautiful lashes! With WonderLash Mascara, get ultimate length, volume, and definition for a stunning, eye-catching look. One swipe is all it takes! 💕',
      hashtags: '#WonderLash #LashesForDays',
      referralCode: 'UK-AMANDA3012',
      referralLink: 'www.oriflame.com/giordani/amanda3012',
      recommendedSong: 'Vogue',
      recommendedArtist: 'Madonna',
      productImageUrl: 'assets/post/post3_mascara.png',
      productThumbnailUrl: 'assets/post/post3_mascara.png',
      userAvatarUrl: _userAvatar,
    ),
  ];

  /// Share targets displayed in the Quick Share row.
  /// Instagram and Facebook each appear twice (Feed and Story), as per Figma.
  static final List<ShareTarget> shareTargets = [
    ShareTarget(
      id: 'ig_feed',
      platformName: 'Instagram\nFeed',
      platform: SharePlatform.instagram,
      variant: ShareVariant.feed,
      iconPath: 'assets/icons/insta_post.png',
    ),
    ShareTarget(
      id: 'ig_story',
      platformName: 'Instagram\nStory',
      platform: SharePlatform.instagram,
      variant: ShareVariant.story,
      iconPath: 'assets/icons/insta_story.png',
    ),
    ShareTarget(
      id: 'fb_feed',
      platformName: 'Facebook\nFeed',
      platform: SharePlatform.facebook,
      variant: ShareVariant.feed,
      iconPath: 'assets/icons/fb_post.png',
    ),
    ShareTarget(
      id: 'fb_story',
      platformName: 'Facebook\nStory',
      platform: SharePlatform.facebook,
      variant: ShareVariant.story,
      iconPath: 'assets/icons/fb_story.png',
    ),
    ShareTarget(
      id: 'messenger',
      platformName: 'Messenger',
      platform: SharePlatform.messenger,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/fb_messanger.png',
    ),
    ShareTarget(
      id: 'tiktok',
      platformName: 'TikTok',
      platform: SharePlatform.tiktok,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/tiktok.png',
    ),
    ShareTarget(
      id: 'whatsapp',
      platformName: 'WhatsApp',
      platform: SharePlatform.whatsapp,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/whatsapp.png',
    ),
    ShareTarget(
      id: 'telegram',
      platformName: 'Telegram',
      platform: SharePlatform.telegram,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/telegram.png',
    ),
    ShareTarget(
      id: 'mail',
      platformName: 'Mail',
      platform: SharePlatform.mail,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/mail.png',
    ),
    ShareTarget(
      id: 'snapchat',
      platformName: 'Snapchat',
      platform: SharePlatform.snapchat,
      variant: ShareVariant.default_,
      iconPath: 'assets/icons/chat.png',
    ),
  ];

  /// The 4 loading checklist steps shown on GeneratingPostsScreen.
  static const List<String> loadingSteps = [
    'Preparing popular content for you',
    'Crafting a caption to boost engagement',
    'Adding your personal referral link and code',
    'Finding trending songs on other social media',
  ];
}

