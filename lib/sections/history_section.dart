import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _Milestone {
  final String step;
  final String title;
  final String description;
  const _Milestone(this.step, this.title, this.description);
}

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  static const _milestones = <_Milestone>[
    _Milestone(
      '01',
      'A shared frustration',
      'Across cloud computing, IoT, and cybersecurity, Robby saw bugs getting in the way of people\u2019s work.',
    ),
    _Milestone(
      '02',
      'A vision for support',
      'She set out to build a company people could turn to when bugs became a problem.',
    ),
    _Milestone(
      '03',
      'A team that keeps learning',
      'With a close group of friends, Robby brought the idea to life. Together, we keep adapting and improving.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The story behind our work', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          for (int i = 0; i < _milestones.length; i++)
            _TimelineRow(
              milestone: _milestones[i],
              isLast: i == _milestones.length - 1,
            ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Read our full story'),
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
                milestone.step,
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
