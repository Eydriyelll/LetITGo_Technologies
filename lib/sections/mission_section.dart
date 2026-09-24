import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

/// TODO: [Content Dev] Paste final Mission copy into the body Text below.
/// Layout/structure is final — only the copy is a placeholder.
class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: GlassCard(
        fillColor: AppColors.glassFillTinted,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our mission', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: context.isDesktop ? 640 : double.infinity,
              child: Text(
                // TODO: [Content Dev] Replace with approved mission statement.
                'To give growing enterprises the same calibre of IT '
                'infrastructure, security and support that only the largest '
                'organizations could once afford — delivered with clarity, '
                'speed and a team that answers the phone.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
