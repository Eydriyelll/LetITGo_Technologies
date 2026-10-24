import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'legal_page_scaffold.dart';

/// TODO: [Legal] Replace body copy with the reviewed terms & conditions text.
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Terms & Conditions',
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Last updated: TODO', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            _section(context, '1. Acceptance of terms',
                'TODO: [Legal] Standard acceptance clause.'),
            _section(context, '2. Use of the site',
                'TODO: [Legal] Permitted/prohibited use clause.'),
            _section(context, '3. Intellectual property',
                'TODO: [Legal] Ownership clause.'),
            _section(context, '4. Limitation of liability',
                'TODO: [Legal] Liability clause.'),
            _section(context, '5. Governing law',
                'TODO: [Legal] Jurisdiction clause.'),
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
