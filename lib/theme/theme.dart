import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskly/theme/colors/app_colors.dart';

final ThemeData theme = ThemeData();

final TextTheme textTheme = theme.textTheme.copyWith(
  bodySmall: GoogleFonts.barlow(fontSize: 12),
  bodyMedium: GoogleFonts.barlow(fontSize: 14),
  labelSmall: GoogleFonts.barlow(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: GoogleFonts.barlow(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  labelLarge: GoogleFonts.barlow(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: GoogleFonts.barlow(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: GoogleFonts.barlow(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

final FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

final ThemeData lightModeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: AppColors.contentBrand,
  textTheme: textTheme,
  filledButtonTheme: filledButtonTheme,
);

final ThemeData darkModeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: AppColors.contentBrand,
  textTheme: textTheme,
  filledButtonTheme: filledButtonTheme,
);
