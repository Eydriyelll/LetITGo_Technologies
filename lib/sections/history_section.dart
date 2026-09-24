import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _Milestone {
  final String year;
  final String title;
  final String description;
  const _Milestone(this.year, this.title, this.description);
}

/// Vertical timeline on mobile/tablet, horizontal-feeling stacked cards
/// with a connecting rule on desktop.
/// TODO: [Content Dev] Replace with real company milestones.
class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  static const _milestones = <_Milestone>[
    _Milestone('2016', 'Founded', 'Placeholder milestone description.'),
    _Milestone('2019', 'First enterprise client', 'Placeholder milestone description.'),
    _Milestone('2022', 'Regional expansion', 'Placeholder milestone description.'),
    _Milestone('2025', 'Security practice launched', 'Placeholder milestone description.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Where we\'ve been', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          for (int i = 0; i < _milestones.length; i++)
            _TimelineRow(
              milestone: _milestones[i],
              isLast: i == _milestones.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final _Milestone milestone;
  final bool isLast;
  const _TimelineRow({required this.milestone, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                milestone.year,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.accentLight,
                    ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.md),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.2, color: AppColors.glassBorder),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(milestone.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(milestone.description, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
