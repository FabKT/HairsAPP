import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF101014);
  static const card = Color(0xFF151528);
  static const secondary = Color(0xFF262636);
  static const border = Color(0xFF262636);
  static const primary = Color(0xFF7C2BEE);
  static const primaryEnd = Color(0xFFB447EB);
  static const accent = Color(0xFFB385E0);
  static const foreground = Color(0xFFF2F2F2);
  static const secondaryForeground = Color(0xFFE6E6E6);
  static const mutedForeground = Color(0xFF878792);
  static const muted = Color(0xFF33343F);
  static const emerald = Color(0xFF34D399);
  static const amber = Color(0xFFFBBF24);
  static const sky = Color(0xFF38BDF8);
  static const violet = Color(0xFFA78BFA);
  static const orange = Color(0xFFFB923C);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryEnd],
  );

  static const primarySoftGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x267C2BEE), Color(0x14B385E0)],
  );
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      surface: AppColors.background,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.foreground,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      onSurface: AppColors.foreground,
      surfaceContainerHighest: AppColors.card,
      outline: AppColors.border,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 22),
      titleLarge: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600, fontSize: 15),
      titleSmall: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w500, fontSize: 13),
      bodyLarge: TextStyle(color: AppColors.foreground, fontSize: 15),
      bodyMedium: TextStyle(color: AppColors.secondaryForeground, fontSize: 13),
      bodySmall: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
      labelMedium: TextStyle(color: AppColors.mutedForeground, fontSize: 11),
      labelSmall: TextStyle(color: AppColors.mutedForeground, fontSize: 10),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(color: AppColors.foreground, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppColors.foreground),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withValues(alpha:0.5), width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.secondary.withValues(alpha:0.6),
      selectedColor: AppColors.primary.withValues(alpha:0.3),
      labelStyle: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
      secondaryLabelStyle: const TextStyle(fontSize: 12, color: AppColors.accent),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.secondary.withValues(alpha:0.4);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.mutedForeground;
        }),
        side: WidgetStateProperty.all(BorderSide.none),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primary),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, space: 0),
    splashColor: AppColors.primary.withValues(alpha:0.08),
    highlightColor: AppColors.primary.withValues(alpha:0.04),
  );
}

// Gradient decoration helpers
BoxDecoration gradientDecoration({double radius = 12}) => BoxDecoration(
  gradient: AppColors.primaryGradient,
  borderRadius: BorderRadius.circular(radius),
);

BoxDecoration softGradientDecoration({double radius = 12, bool withBorder = false}) => BoxDecoration(
  gradient: AppColors.primarySoftGradient,
  borderRadius: BorderRadius.circular(radius),
  border: withBorder ? Border.all(color: AppColors.primary.withValues(alpha:0.2), width: 0.5) : null,
);

BoxDecoration cardDecoration({double radius = 16, bool glow = false}) => BoxDecoration(
  color: AppColors.card,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: AppColors.border.withValues(alpha:0.5), width: 0.5),
  boxShadow: glow
      ? [
          BoxShadow(color: AppColors.primary.withValues(alpha:0.12), blurRadius: 20, spreadRadius: -5),
          BoxShadow(color: AppColors.accent.withValues(alpha:0.08), blurRadius: 40, spreadRadius: -10),
        ]
      : null,
);

// Gradient container
class GradientBox extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientBox({super.key, required this.child, this.borderRadius, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    ),
    child: child,
  );
}

// Card container with optional glow
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool glow;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.borderRadius, this.glow = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final decoration = cardDecoration(radius: borderRadius?.topLeft.x ?? 16, glow: glow);
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
          ),
        ),
      );
    }
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: child,
    );
  }
}
