import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// LET IT GO TECHNOLOGIES — "FROZEN / PERMAFROST" DESIGN SYSTEM
///
/// Single source of truth for color, type, spacing and breakpoints.
/// Import this file wherever raw hex values would otherwise be typed —
/// no widget outside this file should hardcode a Color(0x...) value.
/// ---------------------------------------------------------------------------
class AppColors {
  AppColors._();

  // Background — deep midnight abyss
  static const Color abyssDark = Color(0xFF061838);
  static const Color abyssLight = Color(0xFF0B2447);

  // Primary / structure — cobalt / royal blue
  static const Color primaryDark = Color(0xFF1952B3);
  static const Color primaryLight = Color(0xFF1D63D8);

  // Accent / interactive — glacier cyan / electric ice
  static const Color accentDark = Color(0xFF0091FF);
  static const Color accentLight = Color(0xFF40B5FF);

  // Text & borders — frosted ice / pale lavender mist
  static const Color textPrimary = Color(0xFFE4EDFF);
  static const Color textSecondary = Color(0xFFC8DCFE);

  // Functional
  static const Color success = Color(0xFF3DDC97);
  static const Color danger = Color(0xFFFF6B6B);

  // Glass surface fills
  static Color glassFillNeutral = Colors.white.withValues(alpha: 0.06);
  static Color glassFillTinted = primaryDark.withValues(alpha: 0.12);
  static Color glassBorder = Colors.white.withValues(alpha: 0.18);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [abyssDark, abyssLight],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryDark, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentDark, accentLight],
  );
}

/// Breakpoints, matched to the brief:
/// Desktop >= 1024, Tablet 600–1023, Mobile < 600.
class AppBreakpoints {
  AppBreakpoints._();
  static const double mobile = 600;
  static const double desktop = 1024;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}

/// Consistent spacing scale — use instead of magic numbers.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;
  static const double xxl = 64;
  static const double xxxl = 96;

  /// Horizontal page padding that scales with breakpoint.
  static double pagePadding(double width) {
    if (AppBreakpoints.isDesktop(width)) return xxxl;
    if (AppBreakpoints.isTablet(width)) return xl;
    return md;
  }

  /// Max content width so lines don't stretch edge-to-edge on ultrawide.
  static const double maxContentWidth = 1280;
}

class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 22;
  static const double pill = 999;
}

class AppTheme {
  AppTheme._();

  // Two-family type system: a tight, structural display face for headlines,
  // and a highly legible text face for body copy. Both resolve through
  // Google Fonts-style family names but are declared as package fonts so the
  // team can drop in licensed .ttf files under assets/fonts without touching
  // widget code. Falls back to system sans if fonts aren't bundled yet.
  static const String displayFontFamily = 'ClashDisplay';
  static const String bodyFontFamily = 'GeneralSans';

  static ThemeData get themeData {
    final base = ThemeData.dark(useMaterial3: true);

    final textTheme = base.textTheme
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        )
        .copyWith(
          displayLarge: const TextStyle(
            fontFamily: displayFontFamily,
            fontSize: 64,
            height: 1.05,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.2,
            color: AppColors.textPrimary,
          ),
          displayMedium: const TextStyle(
            fontFamily: displayFontFamily,
            fontSize: 44,
            height: 1.1,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
          ),
          headlineLarge: const TextStyle(
            fontFamily: displayFontFamily,
            fontSize: 32,
            height: 1.15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: AppColors.textPrimary,
          ),
          headlineMedium: const TextStyle(
            fontFamily: displayFontFamily,
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleLarge: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 18,
            height: 1.55,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          bodyMedium: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 15,
            height: 1.55,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          labelLarge: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.abyssDark,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryLight,
        secondary: AppColors.accentLight,
        surface: AppColors.abyssLight,
        error: AppColors.danger,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      focusColor: AppColors.accentLight.withValues(alpha: 0.4),
      // Visible keyboard focus ring for accessibility (WCAG 2.4.7).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentLight,
          foregroundColor: AppColors.abyssDark,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.08)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: AppColors.glassBorder, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
    );
  }
}
