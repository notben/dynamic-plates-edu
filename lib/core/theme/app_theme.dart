import 'package:flutter/material.dart';

/// Design System géologique pour Dynamic Plates Edu.
/// Palette calibrée pour la clarté pédagogique et la projection en classe (CO de Pérolles)
/// ainsi que le confort de lecture sur iPad et smartphones.
class AppTheme {
  // Couleurs géologiques fondamentales
  static const Color magmaOrange = Color(0xFFFF5722);
  static const Color magmaHot = Color(0xFFFFAB00);
  static const Color mantleBrown = Color(0xFF8D4004);
  static const Color asthenosphereDark = Color(0xFF4E1D04);
  static const Color oceanicCrust = Color(0xFF37474F);
  static const Color continentalCrust = Color(0xFF8D6E63);
  static const Color oceanBlue = Color(0xFF0288D1);
  static const Color oceanDeep = Color(0xFF01579B);
  static const Color trenchDark = Color(0xFF002244);
  static const Color vegetationGreen = Color(0xFF4CAF50);
  static const Color mountainSnow = Color(0xFFECEFF1);
  static const Color faultRed = Color(0xFFD32F2F);
  static const Color seismicYellow = Color(0xFFFFEB3B);

  // Thème Sombre (optimal pour contraste des coupes géologiques incandescentes)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: magmaOrange,
        onPrimary: Colors.white,
        secondary: oceanBlue,
        onSecondary: Colors.white,
        tertiary: magmaHot,
        surface: Color(0xFF181C24),
        onSurface: Color(0xFFE2E8F0),
        surfaceContainerHighest: Color(0xFF232A36),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1319),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B222D),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141922),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF141922),
        indicatorColor: magmaOrange.withOpacity(0.25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: magmaOrange);
          }
          return const TextStyle(fontSize: 12, color: Color(0xFF94A3B8));
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: magmaOrange, size: 24);
          }
          return const IconThemeData(color: Color(0xFF94A3B8), size: 24);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF141922),
        indicatorColor: magmaOrange.withOpacity(0.25),
        selectedIconTheme: const IconThemeData(color: magmaOrange, size: 26),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF94A3B8), size: 24),
        selectedLabelTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: magmaOrange, fontSize: 13),
        unselectedLabelTextStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
      ),
    );
  }

  // Thème Clair (optimisé pour vidéoprojecteurs et environnements très lumineux)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD84315),
        onPrimary: Colors.white,
        secondary: Color(0xFF0277BD),
        onSecondary: Colors.white,
        tertiary: Color(0xFFF57C00),
        surface: Color(0xFFF8FAFC),
        onSurface: Color(0xFF1E293B),
        surfaceContainerHighest: Color(0xFFE2E8F0),
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
          letterSpacing: 0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFCCBC),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD84315));
          }
          return const TextStyle(fontSize: 12, color: Color(0xFF64748B));
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFFFCCBC),
        selectedIconTheme: IconThemeData(color: Color(0xFFD84315), size: 26),
        unselectedIconTheme: IconThemeData(color: Color(0xFF64748B), size: 24),
        selectedLabelTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD84315), fontSize: 13),
        unselectedLabelTextStyle: TextStyle(color: Color(0xFF64748B), fontSize: 12),
      ),
    );
  }
}
