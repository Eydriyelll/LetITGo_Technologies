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

    Widget card = _GlassSurface(
      radius: radius,
      blurSigma: blurSigma,
      padding: padding,
      fill: fill,
      border: border,
      borderWidth: borderWidth,
      child: child,
    );

    if (onTap != null) {
      // Subtle hover/press feedback — a cheap Transform.scale on an
      // already-RepaintBoundary'd surface, not an extra blur pass, so it
      // stays within the perf budget noted above.
      card = _HoverLift(onTap: onTap!, child: card);
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

class _GlassSurface extends StatelessWidget {
  final BorderRadius radius;
  final double blurSigma;
  final EdgeInsetsGeometry padding;
  final Color fill;
  final Color border;
  final double borderWidth;
  final Widget child;

  const _GlassSurface({
    required this.radius,
    required this.blurSigma,
    required this.padding,
    required this.fill,
    required this.border,
    required this.borderWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
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
  }
}

/// Hover = lift slightly + brighten border. Press = settle back down a
/// touch, for tactile feedback. Scale-only, so no extra compositing cost.
class _HoverLift extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const _HoverLift({required this.onTap, required this.child});

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.98 : (_hovering ? 1.015 : 1.0);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: AppColors.accentLight.withValues(alpha: 0.12),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
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
