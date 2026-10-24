import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import 'legal_page_scaffold.dart';

class _VisionPillar {
  final String title;
  final String description;
  const _VisionPillar(this.title, this.description);
}

/// Full /vision page. Content ported from an earlier draft that used a
/// bespoke Scaffold + hardcoded colors — restyled here onto the shared
/// LegalPageScaffold/GlassCard/AppColors system so it matches every other
/// routed page (Privacy Policy, Terms, History).
class VisionPage extends StatelessWidget {
  const VisionPage({super.key});

  static const _pillars = <_VisionPillar>[
    _VisionPillar(
      'Global benchmark for transformation',
      'To serve as a leading global standard for effortless digital '
          'transformation, enabling businesses and individuals to thrive in '
          'an interconnected world free from technical complexity and risk.',
    ),
    _VisionPillar(
      'Integrated technological excellence',
      'To seamlessly unite cutting-edge cybersecurity, resilient cloud '
          'infrastructure, and intelligent IoT platforms into intuitive, '
          'highly reliable solutions.',
    ),
    _VisionPillar(
      'Empowerment through simplicity',
      'To cultivate a future where technology acts as an uninhibited '
          'driver of innovation and progress rather than an operational '
          'burden.',
    ),
    _VisionPillar(
      'Complete digital peace of mind',
      'To deliver absolute trust and security, empowering our clients to '
          'let go of digital risk and focus entirely on achieving their '
          'core goals.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Our vision',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.isDesktop ? 640 : double.infinity,
            child: Text(
              'Let go of the complexity. Hold onto your vision. Technology '
              'shouldn\'t feel like an obstacle course or an operational '
              'weight — our job is to handle the digital backend, security, '
              'and infrastructure so completely that you can focus entirely '
              'on growth.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Responsive(
            mobile: Column(
              children: [
                for (int i = 0; i < _pillars.length; i++) ...[
                  _PillarCard(index: i, pillar: _pillars[i]),
                  if (i != _pillars.length - 1) const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
            desktop: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                for (int i = 0; i < _pillars.length; i++)
                  SizedBox(
                    width: (AppSpacing.maxContentWidth - AppSpacing.lg) / 2,
                    child: _PillarCard(index: i, pillar: _pillars[i]),
                  ),
              ],
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
