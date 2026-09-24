import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import '../widgets/contact_modal.dart';

/// Glassmorphic hero. Headline/motto are placeholder copy —
/// TODO: [Marketing] swap in approved messaging.
class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: EdgeInsets.symmetric(
        vertical: context.isMobile ? AppSpacing.xl : AppSpacing.xxxl,
      ),
      child: GlassCard(
        borderRadius: AppRadius.lg,
        padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : AppSpacing.xxl),
        child: Responsive(
          mobile: _content(context, isMobile: true),
          desktop: _content(context, isMobile: false),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Let IT Go Technologies — enterprise IT solutions provider',
          child: Text(
            // TODO: [Marketing] Replace with final headline copy.
            'Enterprise IT,\nwithout the friction.',
            style: (isMobile
                    ? Theme.of(context).textTheme.displayMedium
                    : Theme.of(context).textTheme.displayLarge)
                ?.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: isMobile ? double.infinity : 520,
          child: Text(
            // TODO: [Marketing] Replace with final motto/subhead copy.
            'We design, build and run the infrastructure, platforms and '
            'security your business depends on — so your team can focus on '
            'the work only they can do.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            ElevatedButton(
              onPressed: () => showContactModal(context),
              child: const Text('Start a conversation'),
            ),
            OutlinedButton(
              onPressed: () {
                // TODO: [Dev] Hook to scroll to ProductsServicesSection.
              },
              child: const Text('Explore services'),
            ),
          ],
        ),
      ],
    );
  }
}
