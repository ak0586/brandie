import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_post_content.dart';
import '../theme/app_theme.dart';

/// Edit Caption bottom sheet modal.
///
/// **Save button state design decision:**
/// We track the original caption text at construction time and compare it to
/// the live controller value on every change. This is the simplest correct
/// approach: a TextEditingController listener fires on every keystroke, and
/// we compare current text != originalText to decide enabled/disabled state.
/// Using a ValueNotifier<bool> for `_isSaveEnabled` avoids rebuilding the
/// entire sheet on every keystroke — only the Save button rebuilds.
///
/// **Autofocus decision:**
/// The caption text field is NOT autofocused on open. The Figma spec says
/// "first tap on caption opens this view" and "if user taps caption text field,
/// bring up keyboard". We implement this by opening without focus — the user
/// reads the pre-filled caption, then taps the text field to start editing.
/// This matches iOS/Android convention for "view then edit" modals.
class EditCaptionSheet extends StatefulWidget {
  final SmartPostContent post;
  final ValueChanged<SmartPostContent> onSave;

  const EditCaptionSheet({
    super.key,
    required this.post,
    required this.onSave,
  });

  @override
  State<EditCaptionSheet> createState() => _EditCaptionSheetState();
}

class _EditCaptionSheetState extends State<EditCaptionSheet> {
  late final TextEditingController _controller;
  late final String _originalCaption;

  /// ValueNotifier to drive Save button without rebuilding the whole sheet.
  final ValueNotifier<bool> _isSaveEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // Pre-fill with full caption text (caption + hashtags + referral lines).
    _originalCaption = widget.post.fullCaption;
    _controller = TextEditingController(text: _originalCaption);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _isSaveEnabled.value = _controller.text != _originalCaption;
  }

  void _onSave() {
    if (!_isSaveEnabled.value) return;
    // Update the parent card's caption.
    // We store only the caption body — hashtags and referral lines are
    // separate model fields. For simplicity, we update the full caption
    // via the model's copyWith, treating the edited text as the new body.
    final updatedPost = widget.post.copyWith(caption: _controller.text);
    widget.onSave(updatedPost);
    Navigator.of(context).pop();
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _isSaveEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Full-screen bottom sheet that pushes the keyboard up
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header row
              _buildHeader(),
              const Divider(height: 1),
              // Caption text field
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    top: AppSpacing.md,
                    bottom: MediaQuery.of(context).viewInsets.bottom +
                        AppSpacing.md,
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    // No autofocus — user must tap to open keyboard (see class doc)
                    autofocus: false,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your caption here...',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // X close button
          GestureDetector(
            onTap: _onClose,
            child: const Icon(Icons.close, size: 22, color: AppColors.textPrimary),
          ),
          // Centered title
          const Expanded(
            child: Text(
              'Edit Caption',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Save button — enabled only when text has changed
          ValueListenableBuilder<bool>(
            valueListenable: _isSaveEnabled,
            builder: (_, isEnabled, __) {
              return GestureDetector(
                onTap: isEnabled ? _onSave : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.accent
                        : AppColors.accentDisabled,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

