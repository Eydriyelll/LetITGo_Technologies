import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _ValueItem {
  final IconData icon;
  final String title;
  final String description;
  const _ValueItem(this.icon, this.title, this.description);
}

/// Responsive Wrap of 6 value cards.
/// TODO: [Content Dev] Replace icon/title/description trio for each value.
class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  static const _values = <_ValueItem>[
    _ValueItem(Icons.shield_outlined, 'Security first', 'Placeholder description.'),
    _ValueItem(Icons.bolt_outlined, 'Built to scale', 'Placeholder description.'),
    _ValueItem(Icons.handshake_outlined, 'Honest partnership', 'Placeholder description.'),
    _ValueItem(Icons.visibility_outlined, 'Full transparency', 'Placeholder description.'),
    _ValueItem(Icons.support_agent_outlined, 'Always reachable', 'Placeholder description.'),
    _ValueItem(Icons.eco_outlined, 'Built to last', 'Placeholder description.'),
  ];

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
          Text('What guides us', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _values
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
  final _ValueItem item;
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
            Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
