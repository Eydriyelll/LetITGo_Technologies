import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/values_page.dart';
import '../pages/products_services_page.dart';
import '../pages/careers_page.dart';
import '../pages/history_page.dart';
import '../pages/privacy_policy_page.dart';
import '../pages/terms_page.dart';
import '../pages/not_found_page.dart';

/// ---------------------------------------------------------------------------
/// Central route table.
///
/// The site is now a true multi-page app (not a single scrolling page with
/// anchor links): every major section — About, Values, Products & Services,
/// History, Careers — is its own route, wrapped in a persistent [AppShell]
/// (nav + footer) via [ShellRoute] so the chrome doesn't rebuild on every
/// navigation, only the inner page content does.
///
/// Conventions for whoever adds routes next:
///   - Keep route paths kebab-case and stable (they're indexed by search
///     engines and may be bookmarked/shared).
///   - New top-level pages go inside the ShellRoute's `routes` list below,
///     with their own `name` for `context.goNamed(...)`.
///   - Add new routes to web/sitemap.xml when they ship.
///   - Add the page to Navbar's `_destinations` list if it belongs in the
///     primary nav, and to FooterSection's sitemap list either way.
/// ---------------------------------------------------------------------------
class AppRoutes {
  AppRoutes._();
  static const home = '/';
  static const about = '/about';
  static const values = '/values';
  static const products = '/products-services';
  static const history = '/history';
  static const careers = '/careers';
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
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  observers: [AnalyticsRouteObserver()],
  routes: [
    // Vision used to be its own page; its content now lives as a section
    // on the About page. This keeps any old bookmarks/links alive.
    GoRoute(
      path: '/vision',
      redirect: (context, state) => AppRoutes.about,
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(currentLocation: state.uri.toString(), child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: AppRoutes.values,
          name: 'values',
          builder: (context, state) => const ValuesPage(),
        ),
        GoRoute(
          path: AppRoutes.products,
          name: 'products-services',
          builder: (context, state) => const ProductsServicesPage(),
        ),
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: AppRoutes.careers,
          name: 'careers',
          builder: (context, state) => const CareersPage(),
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
    ),
  ],
  // Custom glassmorphic 404. Kept outside the shell deliberately — an
  // unknown route shouldn't assume the shell's nav state is meaningful.
  errorBuilder: (context, state) => const NotFoundPage(),
);
