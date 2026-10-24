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
///     with their own `name` for `context.goNamed(...)`, built via
///     `_fadePage` so the transition animation stays consistent.
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

/// A gentle fade + slight rise, used for every page in the shell so moving
/// between pages feels like one continuous app rather than a hard cut.
/// Short and subtle on purpose — this runs on every navigation, so it
/// should never feel like it's in the way.
CustomTransitionPage<void> _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * 12),
          child: child,
        ),
      );
    },
  );
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
          pageBuilder: (context, state) => _fadePage(const HomePage(), state),
        ),
        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          pageBuilder: (context, state) => _fadePage(const AboutPage(), state),
        ),
        GoRoute(
          path: AppRoutes.values,
          name: 'values',
          pageBuilder: (context, state) => _fadePage(const ValuesPage(), state),
        ),
        GoRoute(
          path: AppRoutes.products,
          name: 'products-services',
          pageBuilder: (context, state) => _fadePage(const ProductsServicesPage(), state),
        ),
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          pageBuilder: (context, state) => _fadePage(const HistoryPage(), state),
        ),
        GoRoute(
          path: AppRoutes.careers,
          name: 'careers',
          pageBuilder: (context, state) => _fadePage(const CareersPage(), state),
        ),
        GoRoute(
          path: AppRoutes.privacyPolicy,
          name: 'privacy-policy',
          pageBuilder: (context, state) => _fadePage(const PrivacyPolicyPage(), state),
        ),
        GoRoute(
          path: AppRoutes.terms,
          name: 'terms',
          pageBuilder: (context, state) => _fadePage(const TermsPage(), state),
        ),
      ],
    ),
  ],
  // Custom glassmorphic 404. Kept outside the shell deliberately — an
  // unknown route shouldn't assume the shell's nav state is meaningful.
  errorBuilder: (context, state) => const NotFoundPage(),
);
