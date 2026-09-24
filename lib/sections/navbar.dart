import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../utils/section_keys.dart';
import '../widgets/glass_card.dart';
import '../widgets/contact_modal.dart';

/// Sticky, glassmorphic top navigation. Lives outside the scroll view in
/// HomePage (positioned at the top of a Stack) so it stays pinned while
/// the page scrolls underneath it.
class Navbar extends StatelessWidget {
  const Navbar({super.key});

  static final _links = <_NavLink>[
    _NavLink('Mission', SectionKeys.mission),
    _NavLink('Products & Services', SectionKeys.products),
    _NavLink('Careers', SectionKeys.careers),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding(context.screenWidth),
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        borderRadius: AppRadius.pill,
        child: Row(
          children: [
            _Logo(),
            const Spacer(),
            if (context.isDesktop) ..._desktopLinks(context),
            if (context.isDesktop) const SizedBox(width: AppSpacing.lg),
            if (context.isDesktop)
              ElevatedButton(
                onPressed: () => showContactModal(context),
                child: const Text('Get in touch'),
              )
            else
              Semantics(
                button: true,
                label: 'Open menu',
                child: IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => _openMobileMenu(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _desktopLinks(BuildContext context) {
    return _links
        .map((l) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _NavLinkButton(link: l),
            ))
        .toList();
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MobileMenuSheet(links: _links),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder wordmark until a logo file is supplied — "LIGT".
    // TODO: [Design] Replace with assets/images/logo.svg when available.
    return Semantics(
      label: 'Let IT Go Technologies, home',
      button: true,
      child: InkWell(
        onTap: () => context.go('/'),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                gradient: AppColors.accentGradient,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'L',
                style: TextStyle(
                  fontFamily: AppTheme.displayFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.abyssDark,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'LIGT',
              style: TextStyle(
                fontFamily: AppTheme.displayFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink {
  final String label;
  final GlobalKey sectionKey;
  const _NavLink(this.label, this.sectionKey);
}

class _NavLinkButton extends StatelessWidget {
  final _NavLink link;
  const _NavLinkButton({required this.link});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Jump to ${link.label} section',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: () => SectionKeys.scrollTo(link.sectionKey),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(link.label, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}

class _MobileMenuSheet extends StatelessWidget {
  final List<_NavLink> links;
  const _MobileMenuSheet({required this.links});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GlassCard(
        fillColor: AppColors.abyssLight.withValues(alpha: 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final l in links)
              ListTile(
                title: Text(l.label, style: Theme.of(context).textTheme.titleLarge),
                onTap: () {
                  Navigator.of(context).pop();
                  SectionKeys.scrollTo(l.sectionKey);
                },
              ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showContactModal(context);
              },
              child: const Text('Get in touch'),
            ),
          ],
        ),
      ),
    );
  }
}
