import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../routing/app_router.dart';
import '../widgets/glass_card.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return ContentBounds(
      verticalPadding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.xxl),
      child: GlassCard(
        fillColor: AppColors.abyssLight.withValues(alpha: 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Responsive(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _brandBlock(context),
                  const SizedBox(height: AppSpacing.lg),
                  _sitemapLinks(context),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _brandBlock(context)),
                  Expanded(flex: 1, child: _sitemapLinks(context)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Divider(color: AppColors.glassBorder, height: 1),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: AppSpacing.sm,
              children: [
                Text(
                  '\u00a9 $year Let IT Go Technologies. All rights reserved.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Wrap(
                  spacing: AppSpacing.lg,
                  children: [
                    _legalLink(context, 'Privacy Policy', AppRoutes.privacyPolicy),
                    _legalLink(context, 'Terms & Conditions', AppRoutes.terms),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo-mark.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'LET IT GO',
              style: TextStyle(
                fontFamily: AppTheme.displayFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: 340,
          child: Text(
            // TODO: [Marketing] Replace with approved footer tagline.
            'Enterprise IT infrastructure, security and managed services.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _sitemapLinks(BuildContext context) {
    const items = <MapEntry<String, String>>[
      MapEntry('About', AppRoutes.about),
      MapEntry('Values', AppRoutes.values),
      MapEntry('Products & services', AppRoutes.products),
      MapEntry('History', AppRoutes.history),
      MapEntry('Careers', AppRoutes.careers),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Sitemap', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () => context.push(item.value),
              child: Text(item.key, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
      ],
    );
  }

  Widget _legalLink(BuildContext context, String label, String route) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () => context.push(route),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.accentLight,
              ),
        ),
      ),
    );
  }
}
