import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/cookie_consent_banner.dart';
import '../sections/navbar.dart';
import '../sections/footer_section.dart';

/// Wraps every routed page: gradient background, sticky nav, the page's
/// own content, then a shared footer — all in one scroll view so pages
/// don't each need their own Scaffold/SafeArea/background.
///
/// This is what makes the nav "persistent": go_router's ShellRoute keeps
/// this widget mounted across navigations and only swaps [child], so the
/// nav bar and footer never rebuild or flicker when moving between pages.
class AppShell extends StatefulWidget {
  final Widget child;
  final String currentLocation;

  const AppShell({super.key, required this.child, required this.currentLocation});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // TODO: [Dev] Replace with real bootstrap work if needed (remote
    // config fetch, font preloading, etc).
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: !_ready
            ? const SkeletonLoadingScreen()
            : Stack(
                children: [
                  Column(
                    children: [
                      Navbar(currentLocation: widget.currentLocation),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              widget.child,
                              const FooterSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  CookieConsentBanner(
                    onViewPrivacyPolicy: () => context.push('/privacy-policy'),
                  ),
                ],
              ),
      ),
    );
  }
}
