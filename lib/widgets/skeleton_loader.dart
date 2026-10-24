import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Full-screen shimmer skeleton shown while the app initializes or
/// while first-paint assets are still loading. Mirrors the real
/// navbar + hero + card-grid layout so there's no layout jump when
/// the actual content swaps in.
class SkeletonLoadingScreen extends StatefulWidget {
  const SkeletonLoadingScreen({super.key});

  @override
  State<SkeletonLoadingScreen> createState() => _SkeletonLoadingScreenState();
}

class _SkeletonLoadingScreenState extends State<SkeletonLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: ContentBounds(
          verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonNavbar(),
                const SizedBox(height: AppSpacing.xxl),
                _skeletonHero(context),
                const SizedBox(height: AppSpacing.xxl),
                _skeletonCardGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _skeletonNavbar() {
    return Row(
      children: [
        _shimmerBox(width: 120, height: 28, radius: AppRadius.sm),
        const Spacer(),
        if (MediaQuery.of(context).size.width >= AppBreakpoints.desktop) ...[
          _shimmerBox(width: 60, height: 16, radius: AppRadius.sm),
          const SizedBox(width: AppSpacing.lg),
          _shimmerBox(width: 60, height: 16, radius: AppRadius.sm),
          const SizedBox(width: AppSpacing.lg),
          _shimmerBox(width: 60, height: 16, radius: AppRadius.sm),
          const SizedBox(width: AppSpacing.lg),
        ],
        _shimmerBox(width: 110, height: 40, radius: AppRadius.pill),
      ],
    );
  }

  Widget _skeletonHero(BuildContext context) {
    final width = context.screenWidth;
    final titleWidth = AppBreakpoints.isMobile(width) ? width * 0.8 : 520.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(width: titleWidth, height: 48, radius: AppRadius.sm),
        const SizedBox(height: AppSpacing.md),
        _shimmerBox(width: titleWidth * 0.7, height: 48, radius: AppRadius.sm),
        const SizedBox(height: AppSpacing.lg),
        _shimmerBox(width: titleWidth * 0.5, height: 18, radius: AppRadius.sm),
        const SizedBox(height: AppSpacing.xl),
        _shimmerBox(width: 160, height: 48, radius: AppRadius.pill),
      ],
    );
  }

  Widget _skeletonCardGrid(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width)
        ? 4
        : AppBreakpoints.isTablet(width)
            ? 2
            : 1;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: List.generate(columns == 1 ? 3 : columns, (i) {
        final cardWidth = columns == 1
            ? width - (AppSpacing.pagePadding(width) * 2)
            : (width - (AppSpacing.pagePadding(width) * 2) -
                    (AppSpacing.lg * (columns - 1))) /
                columns;
        return _shimmerBox(width: cardWidth, height: 160, radius: AppRadius.lg);
      }),
    );
  }

  Widget _shimmerBox({required double width, required double height, required double radius}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 3, 0),
              end: Alignment(_controller.value * 3, 0),
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.05),
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
        );
      },
    );
  }
}
