import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

/// Persisted consent value. `null` = not yet decided.
enum ConsentChoice { accepted, declined }

class CookieConsentService {
  CookieConsentService._();
  static const _key = 'ligt_cookie_consent';

  static Future<ConsentChoice?> getChoice() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == 'accepted') return ConsentChoice.accepted;
    if (value == 'declined') return ConsentChoice.declined;
    return null;
  }

  static Future<void> setChoice(ConsentChoice choice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      choice == ConsentChoice.accepted ? 'accepted' : 'declined',
    );
    // TODO: [Dev] If `accepted`, this is the hook to conditionally
    // bootstrap analytics (see web/index.html gtag stub) — e.g. call a
    // JS-interop function to flip `window.analyticsConsentGranted = true`.
  }
}

/// Floating glass banner, bottom of viewport. Shows only when no prior
/// choice is stored. Wrap your app's root Stack with this widget.
class CookieConsentBanner extends StatefulWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onViewPrivacyPolicy;

  const CookieConsentBanner({
    super.key,
    this.onAccept,
    this.onDecline,
    this.onViewPrivacyPolicy,
  });

  @override
  State<CookieConsentBanner> createState() => _CookieConsentBannerState();
}

class _CookieConsentBannerState extends State<CookieConsentBanner> {
  bool _loading = true;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final existing = await CookieConsentService.getChoice();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _visible = existing == null;
    });
  }

  Future<void> _handle(ConsentChoice choice) async {
    await CookieConsentService.setChoice(choice);
    if (!mounted) return;
    setState(() => _visible = false);
    if (choice == ConsentChoice.accepted) {
      widget.onAccept?.call();
    } else {
      widget.onDecline?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || !_visible) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppBreakpoints.mobile;

    return Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: AppSpacing.md,
      child: Semantics(
        container: true,
        label: 'Cookie consent notice',
        child: GlassCard(
          fillColor: AppColors.abyssLight.withValues(alpha: 0.55),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: isMobile ? _mobileLayout(context) : _desktopLayout(context),
        ),
      ),
    );
  }

  Widget _message() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontFamily: AppTheme.bodyFontFamily,
          fontSize: 14,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
        children: [
          TextSpan(
            text: 'We use cookies to run this site and understand how it\'s used. '
                'Read our ',
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: AppColors.accentLight,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
            // Tap handling is done via the GestureDetector wrapping this
            // whole RichText in build() below, not a per-span recognizer.
          ),
          TextSpan(text: ' for details.'),
        ],
      ),
    );
  }

  Widget _actions() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        OutlinedButton(
          onPressed: () => _handle(ConsentChoice.declined),
          child: const Text('Decline'),
        ),
        ElevatedButton(
          onPressed: () => _handle(ConsentChoice.accepted),
          child: const Text('Accept'),
        ),
      ],
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: widget.onViewPrivacyPolicy,
            child: _message(),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        _actions(),
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(onTap: widget.onViewPrivacyPolicy, child: _message()),
        const SizedBox(height: AppSpacing.md),
        _actions(),
      ],
    );
  }
}
