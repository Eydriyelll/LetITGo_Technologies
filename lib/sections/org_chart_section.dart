import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

/// Two-branch hierarchical placeholder: Executive division and Technical
/// division, each rooted under a top "Leadership" node.
/// TODO: [HR/Content] Replace node labels/names with real org structure.
class OrgChartSection extends StatelessWidget {
  const OrgChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How we\'re organized', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          const Center(child: _OrgNode(label: 'Leadership', subtitle: 'Placeholder name')),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: SizedBox(
              width: 2,
              height: AppSpacing.lg,
              child: ColoredBox(color: AppColors.glassBorder),
            ),
          ),
          const Responsive(
            mobile: Column(
              children: [
                _DivisionBranch(
                  title: 'Executive division',
                  roles: ['Placeholder — CFO', 'Placeholder — COO', 'Placeholder — VP Sales'],
                ),
                SizedBox(height: AppSpacing.lg),
                _DivisionBranch(
                  title: 'Technical division',
                  roles: ['Placeholder — CTO', 'Placeholder — Head of Security', 'Placeholder — Head of Cloud Ops'],
                ),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DivisionBranch(
                    title: 'Executive division',
                    roles: ['Placeholder — CFO', 'Placeholder — COO', 'Placeholder — VP Sales'],
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: _DivisionBranch(
                    title: 'Technical division',
                    roles: ['Placeholder — CTO', 'Placeholder — Head of Security', 'Placeholder — Head of Cloud Ops'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgNode extends StatelessWidget {
  final String label;
  final String subtitle;
  const _OrgNode({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label — $subtitle',
      child: GlassCard(
        fillColor: AppColors.glassFillTinted,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _DivisionBranch extends StatelessWidget {
  final String title;
  final List<String> roles;
  const _DivisionBranch({required this.title, required this.roles});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          for (final role in roles)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(role, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
