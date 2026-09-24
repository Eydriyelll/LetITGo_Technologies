import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _Offering {
  final IconData icon;
  final String title;
  final String description;
  const _Offering(this.icon, this.title, this.description);
}

/// TODO: [Content Dev] Replace with the 4 real product/service offerings.
class ProductsServicesSection extends StatelessWidget {
  const ProductsServicesSection({super.key});

  static const _offerings = <_Offering>[
    _Offering(Icons.cloud_outlined, 'Cloud infrastructure', 'Placeholder description of this offering.'),
    _Offering(Icons.security_outlined, 'Managed security', 'Placeholder description of this offering.'),
    _Offering(Icons.dns_outlined, 'IT managed services', 'Placeholder description of this offering.'),
    _Offering(Icons.integration_instructions_outlined, 'Systems integration', 'Placeholder description of this offering.'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width)
        ? 4
        : AppBreakpoints.isTablet(width)
            ? 2
            : 1;

    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products & services', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _offerings
                    .map((o) => SizedBox(width: cardWidth, child: _OfferingCard(item: o)))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OfferingCard extends StatelessWidget {
  final _Offering item;
  const _OfferingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.title}: ${item.description}',
      button: true,
      child: GlassCard(
        onTap: () {
          // TODO: [Dev] Link to a dedicated service detail route/section.
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(item.icon, color: AppColors.abyssDark, size: 22),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
