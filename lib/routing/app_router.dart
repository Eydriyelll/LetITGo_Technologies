import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/privacy_policy_page.dart';
import '../pages/terms_page.dart';
import '../pages/not_found_page.dart';

/// ---------------------------------------------------------------------------
/// Central route table.
///
/// The brief is a single-page site today, but this is set up with go_router
/// (not raw Navigator/onUnknownRoute) so the team can add real routed pages
/// later — e.g. /blog, /careers/:id, /case-studies — without a rewrite.
///
/// Conventions for whoever adds routes next:
///   - Keep route paths kebab-case and stable (they're indexed by search
///     engines and may be bookmarked/shared).
///   - Every new top-level page belongs in `routes` below, with its own
///     `name` so it can be referenced via `context.goNamed(...)` instead of
///     hardcoded path strings.
///   - Add new routes to web/sitemap.xml when they ship.
/// ---------------------------------------------------------------------------
class AppRoutes {
  AppRoutes._();
  static const home = '/';
  static const privacyPolicy = '/privacy-policy';
  static const terms = '/terms-and-conditions';
}

/// Analytics routing observer — fires on every navigation so page views
/// can be reported to GA4 (see web/index.html for the gtag bootstrap).
/// TODO: [Dev] Wire this to your JS-interop analytics call once the GA4
/// Measurement ID is available.
class AnalyticsRouteObserver extends NavigatorObserver {
  void _log(Route<dynamic>? route) {
    final name = route?.settings.name ?? route?.settings.arguments?.toString();
    // TODO: [Dev] e.g. js.context.callMethod('gtag', ['event', 'page_view', ...]);
    debugPrint('[analytics] page_view: ${name ?? route?.settings.toString()}');
  }

  @override
  void didPush(Route route, Route? previousRoute) => _log(route);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _log(newRoute);
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  observers: [AnalyticsRouteObserver()],
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      name: 'privacy-policy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: AppRoutes.terms,
      name: 'terms',
      builder: (context, state) => const TermsPage(),
    ),
  ],
  // Custom glassmorphic 404 — this is go_router's equivalent of
  // MaterialApp.onUnknownRoute.
  errorBuilder: (context, state) => const NotFoundPage(),
);
