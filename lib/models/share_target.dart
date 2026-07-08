/// Represents a social media platform share target.
/// Instagram and Facebook each appear twice (Feed vs Story variants).
class ShareTarget {
  final String id;
  final String platformName; // e.g. "Instagram Feed", "Instagram Story"
  final SharePlatform platform;
  final ShareVariant variant;
  final String iconPath;

  const ShareTarget({
    required this.id,
    required this.platformName,
    required this.platform,
    required this.variant,
    required this.iconPath,
  });
}

enum SharePlatform {
  instagram,
  facebook,
  tiktok,
  whatsapp,
  telegram,
  mail,
  messenger,
  snapchat,
}

enum ShareVariant {
  feed,
  story,
  default_,
}

