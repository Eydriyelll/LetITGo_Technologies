import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

/// A short brand-voice beat, separate from [MissionSection]. Pulled out of
/// a file that originally reused the `MissionSection` class name — kept as
/// its own section so neither the real mission copy nor this tagline got
/// lost in the merge.
class MottoSection extends StatelessWidget {
  const MottoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our motto', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: context.isDesktop ? 640 : double.infinity,
              child: Text(
                'The bugs never bothered us anyway.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
