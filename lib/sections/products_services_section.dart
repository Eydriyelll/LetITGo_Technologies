import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class _Offering {
  final IconData icon;
  final String title;
  final String description;
  const _Offering(this.icon, this.title, this.description);
}

class ProductsServicesSection extends StatelessWidget {
  const ProductsServicesSection({super.key});

  static const _offerings = <_Offering>[
    _Offering(
      Icons.inventory_2_outlined,
      'Long-Term Data Archiving (Permafrost Cold Storage)',
      'Secure, compliant deep storage designed for medical, legal, and financial records\u2014retaining files for decades without running up active cloud bills.',
    ),
    _Offering(
      Icons.bolt_outlined,
      'Automated Disaster Recovery (Avalanche Instant Thaw)',
      'A warm-standby failover microservice that automatically brings systems back online in under three minutes if a server crashes or gets hit by ransomware.',
    ),
    _Offering(
      Icons.lock_clock_outlined,
      'Release Management & Guardrails (Code Freeze Automation)',
      'Automated DevOps pipelines that safely lock down deployment branches ahead of critical holidays and major launches to stop unvetted code from breaking production.',
    ),
    _Offering(
      Icons.thermostat_outlined,
      'Infrastructure Health & Diagnostics (Sub-Zero Audits)',
      'Direct thermal profiling and performance tuning for server racks and data rooms to stop hardware throttling and cut power costs.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width)
        ? 4
        : AppBreakpoints.isTablet(width)
            ? 2
            : 1;

    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products & services',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              // Uniform height: Desktop & tablet need sufficient vertical room for longer titles
              final double cardHeight = AppBreakpoints.isDesktop(width)
                  ? 340.0
                  : AppBreakpoints.isTablet(width)
                      ? 300.0
                      : 260.0;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _offerings
                    .map(
                      (o) => SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: _OfferingCard(item: o),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OfferingCard extends StatelessWidget {
  final _Offering item;
  const _OfferingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.title}: ${item.description}',
      button: true,
      child: GlassCard(
        onTap: () {
          // TODO: [Dev] Link to a dedicated service detail route/section.
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(item.icon, color: AppColors.abyssDark, size: 22),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
