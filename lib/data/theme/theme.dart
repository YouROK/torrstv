import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torrstv/data/theme/colors.dart';

class AppThemes {
  static ThemeData get darkTheme {
    final ColorScheme darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.orange,
      onPrimary: AppColors.green,
      primaryContainer: AppColors.orangeDark,

      secondary: AppColors.orange,
      onSecondary: AppColors.green,
      secondaryContainer: AppColors.orangeDark,

      surface: AppColors.scrim30,
      onSurface: AppColors.tvWhite,

      error: Colors.red,
      onError: Colors.white,
    );

    return ThemeData.from(colorScheme: darkColorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.darkGray,

      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.surface, // или Color(0xFF424242)
        contentTextStyle: TextStyle(color: darkColorScheme.onSurface),
        actionTextColor: darkColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkGray,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.darkGray,
          systemNavigationBarColor: AppColors.darkGray,
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.tvWhite,
        unselectedLabelColor: AppColors.lightGray,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.orange,
        ),
        splashFactory: NoSplash.splashFactory,
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.tvWhite),
      ),
    );
  }

  static ThemeData get blackTheme {
    ThemeData baseTheme = darkTheme;

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.green,
        onPrimary: AppColors.orange,
        secondary: AppColors.green,
        surface: AppColors.black,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.blackOpaque,
          systemNavigationBarColor: AppColors.blackOpaque,
        ),
      ),
    );
  }
}
