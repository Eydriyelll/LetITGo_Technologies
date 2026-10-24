import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'routing/app_router.dart';

void main() {
  runApp(const LetItGoApp());
}

class LetItGoApp extends StatelessWidget {
  const LetItGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Let IT Go Technologies | Enterprise IT Solutions',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: appRouter,
      // Every page here is built directly on a gradient Container rather
      // than a Scaffold (which normally supplies this for free), but the
      // app still uses Material widgets throughout — InkWell, IconButton,
      // ListTile, TextFormField, ElevatedButton — all of which require a
      // Material ancestor to paint ink/ripple effects and resolve default
      // styling. This `builder` supplies exactly one, app-wide, so no
      // individual page or section needs its own Scaffold/Material wrapper.
      // `type: transparency` means it paints nothing itself — it's purely
      // a capability ancestor, so it never covers the gradient background.
      builder: (context, child) {
        return Material(
          type: MaterialType.transparency,
          child: child,
        );
      },
    );
  }
}
