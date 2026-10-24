import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'legal_page_scaffold.dart';

/// TODO: [Legal] Replace body copy with the reviewed privacy policy text.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Privacy Policy',
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Last updated: TODO', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            _section(context, '1. Information we collect',
                'TODO: [Legal] Describe categories of data collected.'),
            _section(context, '2. How we use information',
                'TODO: [Legal] Describe purposes of processing.'),
            _section(context, '3. Cookies and tracking',
                'TODO: [Legal] Describe analytics/cookie usage, referencing the consent banner.'),
            _section(context, '4. Data sharing',
                'TODO: [Legal] Describe third parties, incl. EmailJS as a processor for contact form submissions.'),
            _section(context, '5. Your rights',
                'TODO: [Legal] Describe applicable rights and contact method.'),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
