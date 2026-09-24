import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The single reusable glass surface for the whole site.
///
/// PERFORMANCE NOTE (CanvasKit):
/// - `BackdropFilter` forces a save-layer + offscreen blur pass for
///   everything painted beneath it. Stacking many blurred layers on top of
///   each other (e.g. a GlassCard inside a GlassCard, or a blurred navbar
///   sitting over a blurred hero) causes visible frame drops on CanvasKit,
///   especially on mid-range laptops and most mobile GPUs.
/// - Rule of thumb enforced by this widget: never nest two [GlassCard]s.
///   Compose flat — put multiple GlassCards side by side or in a
///   Column/Wrap, not inside one another.
/// - `sigma` is capped at 10 per the brief. Do not raise it site-wide;
///   a small number of hero-only elements can go higher deliberately,
///   but most cards should stay at the default.
/// - `RepaintBoundary` is applied internally so scrolling the page does
///   not force every glass card to re-blur every frame.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = AppRadius.lg,
    this.blurSigma = 10,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final fill = fillColor ?? AppColors.glassFillNeutral;
    final border = borderColor ?? AppColors.glassBorder;

    Widget card = RepaintBoundary(
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: radius,
              border: Border.all(color: border, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: card),
      );
    }

    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: card,
      );
    }

    return card;
  }
}

/// A lighter-weight glass surface with no blur — for use *inside* a
/// GlassCard (e.g. a stat chip on a hero card) where a second blur pass
/// would be wasteful. Keeps the frosted look without the GPU cost.
class GlassChip extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassChip({
    super.key,
    required this.child,
    this.padding =
        const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: child,
    );
  }
}
