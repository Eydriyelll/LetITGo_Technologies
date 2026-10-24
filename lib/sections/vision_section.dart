import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _VisionPillar {
  final String title;
  final String description;
  const _VisionPillar(this.title, this.description);
}

/// Vision, shown as four pillars. This now lives directly on the About
/// page (it previously linked out to a separate /vision page).
class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  static const _pillars = <_VisionPillar>[
    _VisionPillar(
      'Global Benchmark for Transformation',
      'Setting the standard for seamless digital change, making '
          'technology work without slowing you down.',
    ),
    _VisionPillar(
      'Integrated Technological Excellence',
      'Combining cybersecurity, resilient cloud infrastructure, and '
          'intelligent IoT systems to create powerful, connected solutions.',
    ),
    _VisionPillar(
      'Empowerment Through Simplicity',
      'Making technology easy, so innovation drives your progress \u2014 '
          'not your problems.',
    ),
    _VisionPillar(
      'Complete Digital Peace of Mind',
      'Giving you robust security so you can concentrate on your core '
          'business, worry-free.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our vision', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          Responsive(
            mobile: Column(
              children: [
                for (int i = 0; i < _pillars.length; i++) ...[
                  _PillarCard(index: i, pillar: _pillars[i]),
                  if (i != _pillars.length - 1) const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
            desktop: LayoutBuilder(
              builder: (context, constraints) {
                const gap = AppSpacing.lg;
                final cardWidth = (constraints.maxWidth - gap) / 2;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (int i = 0; i < _pillars.length; i++)
                      SizedBox(
                        width: cardWidth,
                        child: _PillarCard(index: i, pillar: _pillars[i]),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final int index;
  final _VisionPillar pillar;
  const _PillarCard({required this.index, required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${pillar.title}: ${pillar.description}',
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '0${index + 1}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accentLight,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(pillar.title, style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(pillar.description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
