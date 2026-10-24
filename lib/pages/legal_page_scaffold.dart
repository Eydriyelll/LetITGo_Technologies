import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Shared heading chrome for simple content pages (History, Privacy
/// Policy, Terms). The surrounding background, scroll, and persistent
/// nav all come from AppShell now, so this just lays out a title above
/// the page's own content.
class LegalPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const LegalPageScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppSpacing.xl),
          child,
        ],
      ),
    );
  }
}
