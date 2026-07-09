import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_post_content.dart';
import '../theme/app_theme.dart';

/// Product info row that fades in from the bottom after 3s.
/// Displayed directly over the full-bleed image (no separate background needed —
/// the card already has a dark gradient layer beneath this).
///
/// The entire row is tappable — leads to a stub product detail page.
class ProductInfoOverlay extends StatelessWidget {
  final SmartPostContent post;

  const ProductInfoOverlay({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProductDetail(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.productIfoBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Product thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                post.productThumbnailUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey.shade800,
                  child:
                      const Icon(Icons.image, size: 24, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Name, price, tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.productName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '\$${post.productPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _DiscountBadge(percent: post.discountPercent),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: AppColors.accent,
                        size: 11,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          post.productTag,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow hint (tappable)
            //
          ],
        ),
      ),
    );
  }

  void _openProductDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProductDetailStub(productName: post.productName),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final int percent;
  const _DiscountBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.saleBadge,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$percent% off',
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Stub product detail page — shown on overlay tap.
class _ProductDetailStub extends StatelessWidget {
  final String productName;
  const _ProductDetailStub({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: AppColors.navBackground,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.store, size: 64, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              productName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Full product detail page\n(Coming soon)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
