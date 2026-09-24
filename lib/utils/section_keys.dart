import 'package:flutter/material.dart';

/// One GlobalKey per scrollable section, shared between the Navbar (which
/// triggers the scroll) and HomePage (which assigns each key to its
/// section widget). Keeping these in one place avoids key collisions as
/// more sections get added.
class SectionKeys {
  SectionKeys._();

  static final hero = GlobalKey(debugLabel: 'hero');
  static final mission = GlobalKey(debugLabel: 'mission');
  static final vision = GlobalKey(debugLabel: 'vision');
  static final values = GlobalKey(debugLabel: 'values');
  static final history = GlobalKey(debugLabel: 'history');
  static final products = GlobalKey(debugLabel: 'products');
  static final orgChart = GlobalKey(debugLabel: 'org_chart');
  static final careers = GlobalKey(debugLabel: 'careers');
  static final footer = GlobalKey(debugLabel: 'footer');

  static Future<void> scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return Future.value();
    return Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}
