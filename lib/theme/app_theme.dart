import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.text,
    required this.background,
    required this.tint,
    required this.buttonForeground,
    required this.icon,
    required this.tabIconDefault,
    required this.tabIconSelected,
  });

  final Color text;
  final Color background;
  final Color tint;
  final Color buttonForeground;
  final Color icon;
  final Color tabIconDefault;
  final Color tabIconSelected;

  @override
  AppThemeColors copyWith({
    Color? text,
    Color? background,
    Color? tint,
    Color? buttonForeground,
    Color? icon,
    Color? tabIconDefault,
    Color? tabIconSelected,
  }) {
    return AppThemeColors(
      text: text ?? this.text,
      background: background ?? this.background,
      tint: tint ?? this.tint,
      buttonForeground: buttonForeground ?? this.buttonForeground,
      icon: icon ?? this.icon,
      tabIconDefault: tabIconDefault ?? this.tabIconDefault,
      tabIconSelected: tabIconSelected ?? this.tabIconSelected,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      text: Color.lerp(text, other.text, t) ?? text,
      background: Color.lerp(background, other.background, t) ?? background,
      tint: Color.lerp(tint, other.tint, t) ?? tint,
      buttonForeground:
          Color.lerp(buttonForeground, other.buttonForeground, t) ??
          buttonForeground,
      icon: Color.lerp(icon, other.icon, t) ?? icon,
      tabIconDefault:
          Color.lerp(tabIconDefault, other.tabIconDefault, t) ?? tabIconDefault,
      tabIconSelected:
          Color.lerp(tabIconSelected, other.tabIconSelected, t) ??
          tabIconSelected,
    );
  }

  static AppThemeColors of(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>()!;
  }
}

class AppTheme {
  // High-contrast palette.
  static const AppThemeColors lightColors = AppThemeColors(
    text: Color(0xFF0B1014),
    background: Color(0xFFFFFFFF),
    tint: Color(0xFF055D85),
    buttonForeground: Color(0xFFFFFFFF),
    icon: Color(0xFF3D464C),
    tabIconDefault: Color(0xFF3D464C),
    tabIconSelected: Color(0xFF055D85),
  );

  static const AppThemeColors darkColors = AppThemeColors(
    text: Color(0xFFF7F8F8),
    background: Color(0xFF0F1416),
    tint: Color(0xFFFFFFFF),
    buttonForeground: Color(0xFF0F1416),
    icon: Color(0xFFD8DCDE),
    tabIconDefault: Color(0xFFD8DCDE),
    tabIconSelected: Color(0xFFFFFFFF),
  );

  // Senior-friendly type scale: minimum body text is 19, comfortable line
  // height, generous letter spacing on small labels.
  static TextTheme _textTheme(Color body) {
    const family = 'SpaceMono';
    return TextTheme(
      displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: family, color: body),
      displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: family, color: body),
      displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: family, color: body),
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: family, color: body),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: family, color: body),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: family, color: body),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: family, color: body),
      titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, fontFamily: family, color: body),
      titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: family, color: body),
      bodyLarge: TextStyle(fontSize: 22, height: 1.5, fontFamily: family, color: body),
      bodyMedium: TextStyle(fontSize: 20, height: 1.5, fontFamily: family, color: body),
      bodySmall: TextStyle(fontSize: 18, height: 1.4, fontFamily: family, color: body),
      labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: family, color: body),
      labelMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: family, color: body),
      labelSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: family, color: body),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required AppThemeColors c,
  }) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: c.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.tint,
        brightness: brightness,
        background: c.background,
      ),
      // Generous spacing helps for shaky / imprecise touches.
      visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      textTheme: _textTheme(c.text),
      iconTheme: IconThemeData(size: 30, color: c.text),
      primaryIconTheme: IconThemeData(size: 30, color: c.text),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.tint,
          foregroundColor: c.buttonForeground,
          minimumSize: const Size(72, 64),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1,
        ).copyWith(
          // Stronger pressed feedback for hand-eye-coordination assistance.
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withOpacity(0.18);
            }
            return null;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.tint,
          minimumSize: const Size(72, 64),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          side: BorderSide(color: c.tint, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.tint,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(56, 56),
          iconSize: 30,
          padding: const EdgeInsets.all(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.text,
        toolbarHeight: 72,
        titleTextStyle: TextStyle(
          color: c.text,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'SpaceMono',
        ),
        iconTheme: IconThemeData(color: c.text, size: 30),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.background,
        selectedItemColor: c.tint,
        unselectedItemColor: c.tabIconDefault,
        selectedIconTheme: const IconThemeData(size: 32),
        unselectedIconTheme: const IconThemeData(size: 30),
        selectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.background,
        titleTextStyle: TextStyle(
          color: c.text,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'SpaceMono',
        ),
        contentTextStyle: TextStyle(
          color: c.text,
          fontSize: 19,
          height: 1.5,
          fontFamily: 'SpaceMono',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      extensions: [c],
    );
  }

  static ThemeData get lightTheme => _build(brightness: Brightness.light, c: lightColors);
  static ThemeData get darkTheme => _build(brightness: Brightness.dark, c: darkColors);
}
