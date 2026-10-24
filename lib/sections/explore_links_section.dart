import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../routing/app_router.dart';
import '../widgets/glass_card.dart';

class _ExploreLink {
  final IconData icon;
  final String title;
  final String blurb;
  final String route;
  const _ExploreLink(this.icon, this.title, this.blurb, this.route);
}

const _links = <_ExploreLink>[
  _ExploreLink(Icons.groups_outlined, 'About', 'Our story, mission and vision.', AppRoutes.about),
  _ExploreLink(Icons.favorite_outline, 'Values', 'What guides how we work.', AppRoutes.values),
  _ExploreLink(Icons.widgets_outlined, 'Products & Services', 'What we offer.', AppRoutes.products),
  _ExploreLink(Icons.timeline_outlined, 'History', 'How we got here.', AppRoutes.history),
  _ExploreLink(Icons.work_outline, 'Careers', 'Open roles, by specialization.', AppRoutes.careers),
];

/// Landing-page quick-links grid pointing into the now-separate pages.
class ExploreLinksSection extends StatelessWidget {
  const ExploreLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width)
        ? 3
        : AppBreakpoints.isTablet(width)
            ? 2
            : 1;

    return ContentBounds(
      verticalPadding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = AppSpacing.lg;
          final cardWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final link in _links)
                SizedBox(width: cardWidth, child: _LinkCard(link: link)),
            ],
          );
        },
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final _ExploreLink link;
  const _LinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${link.title}: ${link.blurb}',
      button: true,
      child: GlassCard(
        onTap: () => context.push(link.route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(link.icon, color: AppColors.accentLight, size: 26),
            const SizedBox(height: AppSpacing.md),
            Text(link.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(link.blurb, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
