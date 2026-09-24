import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Shared chrome for lightweight legal/route-placeholder pages so
/// Privacy Policy, Terms and any future legal page look consistent.
class LegalPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const LegalPageScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ContentBounds(
            verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  button: true,
                  label: 'Back to home',
                  child: InkWell(
                    onTap: () => context.go('/'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, color: AppColors.accentLight, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Back to home',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.accentLight,
                                )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(title, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: AppSpacing.xl),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
