import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

/// Founder/origin blurb plus a community-outreach photo. Sits at the top
/// of the About page, above Motto/Mission/Vision/Org Chart.
class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About us', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppSpacing.lg),
          Responsive(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _introText(context),
                const SizedBox(height: AppSpacing.lg),
                const _OutreachPhoto(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _introText(context)),
                const SizedBox(width: AppSpacing.xl),
                const Expanded(flex: 2, child: _OutreachPhoto()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _introText(BuildContext context) {
    return Text(
      'Founded by Robby Ruth Abaquin, we exist to solve the toughest '
      'technical challenges in IoT, Cloud Computing, and Cybersecurity. '
      'Driven by a passion for innovation, our team believes technology '
      'should empower \u2014 not hinder \u2014 businesses and individuals. We '
      'deliver solutions that are simple, secure, and practical, enabling '
      'clients to thrive in a digital world.',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class _OutreachPhoto extends StatelessWidget {
  const _OutreachPhoto();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Semantics(
              label: 'Our team at a community donation drive',
              image: true,
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  'assets/images/about-csce-donation.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Text(
              // TODO: [Content Dev] Adjust wording/date as needed.
              'Giving back: our team donating hygiene essentials to CSCE as '
              'part of our community outreach efforts.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
