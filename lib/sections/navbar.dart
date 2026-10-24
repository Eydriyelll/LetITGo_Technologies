import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../routing/app_router.dart';
import '../widgets/glass_card.dart';
import '../widgets/contact_modal.dart';

class _NavDestination {
  final String label;
  final String path;
  const _NavDestination(this.label, this.path);
}

const _destinations = <_NavDestination>[
  _NavDestination('Home', AppRoutes.home),
  _NavDestination('About', AppRoutes.about),
  _NavDestination('Values', AppRoutes.values),
  _NavDestination('Products & Services', AppRoutes.products),
  _NavDestination('History', AppRoutes.history),
  _NavDestination('Careers', AppRoutes.careers),
];

/// Persistent top navigation, rendered once by [AppShell] and never
/// rebuilt on navigation — only [currentLocation] changes, which drives
/// which link is shown as active. Every destination here is a real route
/// (go_router), not a scroll-to-anchor.
class Navbar extends StatelessWidget {
  final String currentLocation;
  const Navbar({super.key, required this.currentLocation});

  bool _isActive(String path) {
    if (path == AppRoutes.home) return currentLocation == AppRoutes.home;
    return currentLocation.startsWith(path);
  }

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
    return _destinations
        .map((d) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: _NavLinkButton(destination: d, active: _isActive(d.path)),
            ))
        .toList();
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MobileMenuSheet(
        destinations: _destinations,
        isActive: _isActive,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Let IT Go Technologies, home',
      button: true,
      child: InkWell(
        onTap: () => context.go(AppRoutes.home),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo-mark.png',
              width: 34,
              height: 34,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'LET IT GO',
              style: TextStyle(
                fontFamily: AppTheme.displayFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 17,
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

class _NavLinkButton extends StatelessWidget {
  final _NavDestination destination;
  final bool active;
  const _NavLinkButton({required this.destination, required this.active});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go to ${destination.label} page',
      selected: active,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: () => context.go(destination.path),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active ? AppColors.accentLight.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            destination.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: active ? AppColors.accentLight : AppColors.textPrimary,
                ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuSheet extends StatelessWidget {
  final List<_NavDestination> destinations;
  final bool Function(String path) isActive;
  const _MobileMenuSheet({required this.destinations, required this.isActive});

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
            for (final d in destinations)
              ListTile(
                title: Text(
                  d.label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isActive(d.path) ? AppColors.accentLight : AppColors.textPrimary,
                      ),
                ),
                trailing: isActive(d.path)
                    ? const Icon(Icons.circle, size: 8, color: AppColors.accentLight)
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(d.path);
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
