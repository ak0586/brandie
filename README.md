# Oriflame Smart Post — Flutter Assignment

A single-screen Flutter UI clone of the Oriflame "Quick Share / Smart Post" feature.
AI-generated social-media-post creator for beauty product sales representatives.
**All data is hardcoded — no backend or API calls required.**

---

## 🚀 How to Run

### Prerequisites
- Flutter **3.22+** (latest stable)
- Dart **3.4+** (null-safety enabled)
- Android Studio / VS Code with Flutter plugin, or a physical/emulator device

### Steps

```bash
# 1. Clone or open the project folder
cd "d:/Flutter Apps/brandie"

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# Run on a specific device
flutter run -d <device-id>

# Check available devices
flutter devices
```

> **Internet connection required at runtime** — product images and user avatars are loaded from Unsplash/Pravatar CDN URLs. The app logic and UI are fully offline-capable; only images depend on connectivity.

---

## 📁 Folder Structure

```
lib/
├── main.dart                    # App entry point → MaterialApp → GeneratingPostsScreen
│
├── theme/
│   └── app_theme.dart           # AppColors, AppTextStyles, AppSpacing
│                                # Single source of truth for all design tokens
│
├── models/
│   ├── smart_post_content.dart  # SmartPostContent model + copyWith
│   └── share_target.dart        # ShareTarget, SharePlatform, ShareVariant enums
│
├── data/
│   └── mock_data.dart           # All hardcoded content: posts, share targets, steps
│
├── screens/
│   ├── generating_posts_screen.dart  # Loading screen with animated checklist
│   ├── smart_post_screen.dart        # Main Smart Post screen (Stack layout)
│   └── dummy_app_screen.dart         # Placeholder simulating app launch
│
└── widgets/
    ├── smart_post_app_bar.dart       # AppBar: custom AI icon + Oriflame logo + camera
    ├── smart_post_tab_row.dart       # 4-tab row with animated green underline
    ├── product_info_overlay.dart     # Product details overlay (3s fade-in)
    ├── edit_caption_sheet.dart       # Bottom sheet modal for editing captions
    ├── quick_share_row.dart          # Horizontal scrollable platform icon row
    ├── share_loading_overlay.dart    # "Generating sales link..." spinner overlay
    └── smart_post_bottom_nav.dart    # Bottom navigation bar (5 icons)
```

---

## 🎨 Design Decisions & Assumptions

### 1. Scroll Direction: Vertical PageView (Reels-style)
**Decision:** Used `PageView(scrollDirection: Axis.vertical)` for the 3-post cards.

**Reason:** The Figma annotation says "Show 3 posts. User can scroll like reels." Instagram Reels uses vertical swipe. The horizontal swipe alternative would contradict the "reels" reference.

### 2. Product Overlay Fade-in Timing
**Decision:** 3-second delay per card, using an `AnimationController` in `SmartPostCard`'s state.

**Reason:** Each card has an *independent* timer keyed to its widget lifecycle. When you swipe away and return, the timer restarts — this is intentional because the "reveal" moment should feel fresh each time you view a card, not stale.

### 3. Overlay vs. Swipe Race Condition
**Ambiguous interaction handled:** What happens when the user swipes while the product overlay is mid-fade-in?

**Answer:** Each card is a separate widget with its own `AnimationController`. A swipe replaces the visible widget with a new `SmartPostCard` widget. The outgoing card's controller is disposed naturally when Flutter removes it from the tree — the animation is simply cut off mid-frame. The new card starts with its own fresh 3-second countdown. This is clean, safe, and requires no special handling.

### 4. Edit Caption Autofocus
**Decision:** The `TextField` in `EditCaptionSheet` is NOT autofocused on open.

**Reason:** The Figma spec says: "first tap on caption: open this view already showing the caption; if user taps caption text field again, bring up keyboard." We honour this two-step intent — users can read the caption before committing to edit. Autofocus is appropriate for forms, not "view + optionally edit" patterns.

### 5. Save Button State via ValueNotifier
**Decision:** Used `ValueNotifier<bool>` for `_isSaveEnabled` instead of `setState`.

**Reason:** The `TextField` listener fires on every keystroke. Using `setState` would rebuild the entire bottom sheet on every character typed. `ValueNotifier` + `ValueListenableBuilder` isolates the rebuild to just the Save button widget — better performance and correctness.

### 6. Stack-based Layout for Fixed Overlays
**Decision:** Restructured `SmartPostScreen` to place `PageView` (containing only images) at the base of a `Stack`, with all UI elements (app bar, bottom panel, navigation) floating on top.

**Reason:** To perfectly replicate a TikTok/Reels vertical scroll, the bottom navigation and interactive buttons must remain fixed while the images slide underneath them. This allows the bottom navigation bar to be fully transparent, blending seamlessly with the image.

### 7. Mid-Swipe Live Indicator Updates
**Decision:** Attached a listener directly to `PageController` rather than relying solely on `onPageChanged`.

**Reason:** `onPageChanged` only fires when a page transition fully settles. By listening to the controller's offset, we can dynamically update the dot indicators and "X of Y" counter in real-time as the user's thumb drags the image, providing instant, fluid feedback.

### 8. Simulated App Launch Workflow
**Decision:** Navigating to `DummyAppScreen` passing the `ShareTarget` model instead of opening real external intents.

**Reason:** Since this is a standalone UI assignment, attempting to use `url_launcher` to check for specific packages (Instagram/TikTok) would require native Android/iOS permission configurations and fail on simulators without the apps installed. The dummy screen proves the routing architecture works correctly.

### 9. Caption Storage on Save
**Decision:** When user taps "Save", we update `SmartPostContent.caption` with the full edited text (including hashtags and referral lines, since the field shows the full caption).

**Trade-off:** In a real app, the caption body, hashtags, and referral lines would be separate fields edited separately. For this assignment, since the edit modal shows everything together, we treat the complete text as the caption.

### 10. Share Targets: Instagram & Facebook Twice
The design shows two Instagram icons (Feed vs Story) and two Facebook icons (Feed vs Story). Both are distinct `ShareTarget` objects with different `ShareVariant` enum values. The visual difference is a slightly different gradient/shade on the icon.

### 11. Oriflame Logo as Text
No logo image asset is required. The `ORIFLAME / SWEDEN` text in the design is replicated with `Inter` bold font + letter-spacing, matching the logo's visual character without needing an asset file.

---

## ✨ Bonus UX Touches & Figma Fidelity

1. **Per-card 3s overlay with slide-up animation** — product info slides up and fades in (not just fades), matching Instagram Reels' product reveal pattern.
2. **Animated `AnimatedSwitcher` on loading steps** — smooth crossfade between empty circle → green check icon.
3. **Figma-Perfect "Ready to share" Badge** — precise `LinearGradient` mapping (dusty pink to pastel purple) matching the inspector CSS, combined with `Icons.auto_awesome` for the exact sparkle motif.
4. **Transparent Floating Bottom Nav** — by removing it from the `Column` and floating it within the `Stack`, the nav bar sits transparently over the image background.
5. **Authentic Share Loading Overlay** — rebuilt the overlay into a white card containing a thick, infinite circular spinner and a rounded linear progress bar, seamlessly transitioning through 4 text stages as the animation progresses.
6. **Pixel-Perfect App Icons** — extracted the true Oriflame "O" swirl logo and constructed a charcoal grey (`#262928`) background for iOS and Android Adaptive Icons, ensuring it fills the splash screen without Android masking distortion.
7. **`DraggableScrollableSheet` for Edit Caption** — allows the user to drag the sheet to different heights, adapting to keyboard presence naturally.
8. **Caption text tappable** — tapping the caption body (not just the "Edit Caption" button) opens the modal, matching Figma's note: "tapping the caption in the main card opens edit view."

---

## 🔧 Flutter/Dart Version

| Tool    | Version |
|---------|---------|
| Flutter | 3.22.x+ (stable channel) |
| Dart    | 3.4.x+ |

Run `flutter doctor` to verify your environment.
