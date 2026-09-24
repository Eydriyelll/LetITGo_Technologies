import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Builds different layouts per breakpoint without repeating
/// LayoutBuilder/MediaQuery boilerplate in every section file.
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (AppBreakpoints.isDesktop(width)) return desktop;
        if (AppBreakpoints.isTablet(width)) return tablet ?? desktop;
        return mobile;
      },
    );
  }
}

/// Centers content and clamps it to [AppSpacing.maxContentWidth],
/// with breakpoint-aware horizontal padding. Wrap every section body
/// in this so the whole page shares one consistent measure.
class ContentBounds extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? verticalPadding;

  const ContentBounds({super.key, required this.child, this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = AppSpacing.pagePadding(width);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad).add(
            verticalPadding ?? EdgeInsets.zero,
          ),
          child: child,
        ),
      ),
    );
  }
}

extension BuildContextWidth on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  bool get isMobile => AppBreakpoints.isMobile(screenWidth);
  bool get isTablet => AppBreakpoints.isTablet(screenWidth);
  bool get isDesktop => AppBreakpoints.isDesktop(screenWidth);
}
