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
  static const AppThemeColors lightColors = AppThemeColors(
    text: Color(0xFF11181C),
    background: Color(0xFFFFFFFF),
    tint: Color(0xFF0A7EA4),
    buttonForeground: Color(0xFFFFFFFF),
    icon: Color(0xFF687076),
    tabIconDefault: Color(0xFF687076),
    tabIconSelected: Color(0xFF0A7EA4),
  );

  static const AppThemeColors darkColors = AppThemeColors(
    text: Color(0xFFECEDEE),
    background: Color(0xFF151718),
    tint: Color(0xFFFFFFFF),
    buttonForeground: Color(0xFF151718),
    icon: Color(0xFF9BA1A6),
    tabIconDefault: Color(0xFF9BA1A6),
    tabIconSelected: Color(0xFFFFFFFF),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: lightColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightColors.tint,
        brightness: Brightness.light,
        background: lightColors.background,
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 14)).apply(
        bodyColor: lightColors.text,
        displayColor: lightColors.text,
        fontFamily: 'SpaceMono',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColors.tint,
          foregroundColor: lightColors.buttonForeground,
        ),
      ),
      extensions: const [lightColors],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: darkColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkColors.tint,
        brightness: Brightness.dark,
        background: darkColors.background,
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 14)).apply(
        bodyColor: darkColors.text,
        displayColor: darkColors.text,
        fontFamily: 'SpaceMono',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColors.tint,
          foregroundColor: darkColors.buttonForeground,
        ),
      ),
      extensions: const [darkColors],
    );
  }
}
