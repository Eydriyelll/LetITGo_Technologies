import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../utils/company_values.dart';
import '../widgets/glass_card.dart';

class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width)
        ? 3
        : AppBreakpoints.isTablet(width)
            ? 2
            : 1;

    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What guides us',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: companyValues
                    .map((v) => SizedBox(
                          width: cardWidth,
                          child: _ValueCard(item: v),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final CompanyValue item;
  const _ValueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.title}: ${item.description}',
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: AppColors.accentLight, size: 28),
            const SizedBox(height: AppSpacing.md),
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(item.description,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
