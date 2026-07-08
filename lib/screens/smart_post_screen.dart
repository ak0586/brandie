import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../models/smart_post_content.dart';
import '../theme/app_theme.dart';
import '../widgets/smart_post_app_bar.dart';
import '../widgets/smart_post_tab_row.dart';
import '../widgets/smart_post_bottom_nav.dart';
import '../widgets/share_loading_overlay.dart';
import '../widgets/product_info_overlay.dart';
import '../widgets/edit_caption_sheet.dart';
import '../widgets/quick_share_row.dart';

/// Main Smart Post screen.
///
/// Architecture (Reels-style):
/// ┌────────────────────────────┐
/// │  AppBar  (fixed)           │
/// │  TabRow  (fixed)           │
/// │ ┌────────────────────────┐ │
/// │ │  Stack                 │ │
/// │ │  ├─ PageView ← images  │ │  ← only images scroll
/// │ │  ├─ Header overlay     │ │  ← fixed, updates per page
/// │ │  ├─ Dot indicators     │ │  ← fixed
/// │ │  └─ Bottom panel ──────┘ │  ← fixed, content updates per page
/// │ └────────────────────────┘ │
/// │  BottomNav (fixed)         │
/// └────────────────────────────┘
///
/// The PageView contains ONLY images. Everything else is outside the
/// PageView and updates reactively when _currentPage changes.
class SmartPostScreen extends StatefulWidget {
  const SmartPostScreen({super.key});

  @override
  State<SmartPostScreen> createState() => _SmartPostScreenState();
}

class _SmartPostScreenState extends State<SmartPostScreen>
    with SingleTickerProviderStateMixin {
  late List<SmartPostContent> _posts;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _activeTab = 0;
  int _activeNavIndex = 0;

  bool _isCaptionExpanded = false;
  String? _shareTargetName;

  // Product overlay animation — resets on each page change
  late AnimationController _overlayController;
  late Animation<double> _overlayOpacity;
  late Animation<Offset> _overlaySlide;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    _posts = List.from(MockData.posts);
    _initOverlayAnimation();
    _startOverlayTimer();
  }

  void _initOverlayAnimation() {
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _overlayOpacity = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeIn,
    );
    _overlaySlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOut,
    ));
  }

  /// Starts a 3-second countdown before revealing the product overlay.
  /// Called on init and on every page change.
  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayController.reset();
    _overlayTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) _overlayController.forward();
    });
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _overlayController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isCaptionExpanded = false; // reset expand state per page
    });
    // Reset product overlay for new page
    _startOverlayTimer();
  }

  void _onCaptionUpdated(SmartPostContent updated) {
    setState(() {
      final idx = _posts.indexWhere((p) => p.id == updated.id);
      if (idx != -1) _posts[idx] = updated;
    });
  }

  void _onShareTap(String platformName) {
    setState(() => _shareTargetName = platformName);
  }

  void _onShareComplete() {
    final name = _shareTargetName ?? '';
    setState(() => _shareTargetName = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $name...'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
      ),
    );
  }

  void _openEditCaption() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditCaptionSheet(
        post: _posts[_currentPage],
        onSave: _onCaptionUpdated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Fixed AppBar ──────────────────────────────────────────
                const SmartPostAppBar(),
                // ── Fixed TabRow ──────────────────────────────────────────
                SmartPostTabRow(
                  activeIndex: _activeTab,
                  onTabSelected: (i) => setState(() => _activeTab = i),
                ),
                // ── Main content area ─────────────────────────────────────
                Expanded(child: _buildMainContent()),
                // ── Fixed BottomNav ───────────────────────────────────────
                SmartPostBottomNav(
                  activeIndex: _activeNavIndex,
                  onItemTap: (i) => setState(() => _activeNavIndex = i),
                ),
              ],
            ),
            // ── Share loading overlay ─────────────────────────────────────
            if (_shareTargetName != null)
              Positioned.fill(
                child: ShareLoadingOverlay(
                  platformName: _shareTargetName!,
                  onComplete: _onShareComplete,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the main scrollable area:
  /// Stack with PageView (images only) + fixed overlays.
  Widget _buildMainContent() {
    final post = _posts[_currentPage];

    return Stack(
      children: [
        // ── PageView — IMAGES ONLY ────────────────────────────────────────
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _posts.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (_, i) {
            return Image.asset(
              _posts[i].productImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceGrey,
                child: const Icon(Icons.broken_image, size: 64),
              ),
            );
          },
        ),

        // ── Dark gradient at bottom (for legibility) ──────────────────────
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 450,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xDD000000)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
        ),

        // ── Fixed header (top overlay, updates per page) ──────────────────
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: _buildHeader(post),
        ),

        // ── Fixed dot indicators (right edge, vertical centre) ────────────
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(child: _buildDotIndicators()),
        ),

        // ── Fixed bottom content panel — DOES NOT SCROLL ──────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(post),
        ),
      ],
    );
  }

  // ── Header overlay ─────────────────────────────────────────────────────────

  Widget _buildHeader(SmartPostContent post) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(post.userAvatarUrl),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.readyBadge,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 10),
                    const SizedBox(width: 3),
                    Text(
                      'Ready to share',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'High-converting in Oriflame Community',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white,
                  shadows: [
                    const Shadow(blurRadius: 4, color: Colors.black54)
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_currentPage + 1} of ${_posts.length}',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ── Dot indicators ─────────────────────────────────────────────────────────

  Widget _buildDotIndicators() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_posts.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 3),
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.dotActive : AppColors.dotInactive,
          ),
        );
      }),
    );
  }

  // ── Bottom panel (fixed, updates content per page) ─────────────────────────

  Widget _buildBottomPanel(SmartPostContent post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product info overlay — fades in after 3s, resets on page change
          SlideTransition(
            position: _overlaySlide,
            child: FadeTransition(
              opacity: _overlayOpacity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ProductInfoOverlay(post: post),
              ),
            ),
          ),

          // Recommended song
          _buildSongRow(post),
          const SizedBox(height: 8),

          // CAPTION SUGGESTION | Edit Caption
          Row(
            children: [
              const Icon(
                Icons.article_outlined,
                size: 13,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                'CAPTION SUGGESTION',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _openEditCaption,
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 12, color: AppColors.accent),
                    const SizedBox(width: 3),
                    Text(
                      'Edit Caption',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Caption text — tappable opens editor
          GestureDetector(
            onTap: _openEditCaption,
            child: _buildCaptionText(post),
          ),
          const SizedBox(height: 6),

          // Referral info
          _buildReferralInfo(post),
          const SizedBox(height: 10),

          // Quick share row — always visible, never scrolls
          QuickShareRow(
            post: post,
            onShareTap: _onShareTap,
          ),
        ],
      ),
    );
  }

  Widget _buildSongRow(SmartPostContent post) {
    return Row(
      children: [
        const Icon(Icons.music_note, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          'Recommended: ',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
        Flexible(
          child: Text(
            '${post.recommendedSong} ',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          'by ${post.recommendedArtist}',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCaptionText(SmartPostContent post) {
    final fullText = '${post.caption}\n${post.hashtags}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullText,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
          maxLines: _isCaptionExpanded ? null : 3,
          overflow: _isCaptionExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: () =>
              setState(() => _isCaptionExpanded = !_isCaptionExpanded),
          child: Text(
            _isCaptionExpanded ? 'See less' : 'see more',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferralInfo(SmartPostContent post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Use my referral code: ${post.referralCode}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          'Use my referral link: ${post.referralLink}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

