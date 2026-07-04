import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // Light Theme Colors
  static Color backgroundColor = const Color(0xffF5F8FA);
  static Color blueColor = const Color(0xff1DA1F2);
  static Color blackColor = const Color(0xff14171A);
  static Color darkGrayColor = const Color(0xff657786);
  static Color lightGrayColor = const Color(0xffAAB8C2);
  static Color errorColor = const Color(0xffFB4747);
  static Color whiteColor = const Color(0xffffffff);

  // Dark Theme Colors
  static Color darkBackgroundColor = const Color(0xff1A1A2E);
  static Color darkPrimaryColor = const Color(0xff0F3460);
  static Color darkCardColor = const Color(0xff16213E);
  static Color darkTextColor = const Color(0xffE94560);
  static Color darkHintColor = const Color(0xff6B7280);

  // Light Theme Configuration
  static final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: blueColor,
    hintColor: lightGrayColor,
    cardColor: whiteColor,
    textTheme: _lightTextTheme,
    elevatedButtonTheme: _lightElevatedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    useMaterial3: true, colorScheme: _lightColorScheme.copyWith(surface: backgroundColor).copyWith(error: errorColor),
  );

  static final _lightTextTheme = TextTheme(
    labelLarge: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: lightGrayColor,
    ),
  );

  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: blueColor,
    brightness: Brightness.light,
    surface: backgroundColor,
    onSurface: blackColor,
    primary: blueColor,
    onPrimary: backgroundColor,
    secondary: darkGrayColor,
    onSecondary: backgroundColor,
  );

  static final _lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: blueColor,
      elevation: 10,
      textStyle: _lightTextTheme.labelLarge,
      shadowColor: blueColor.withValues(alpha: 0.25),
      foregroundColor: backgroundColor,
      padding: EdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      disabledBackgroundColor: blueColor,
      disabledForegroundColor: backgroundColor,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(16.w),
    hintStyle: _lightTextTheme.bodySmall,
    errorStyle: _lightTextTheme.bodySmall?.copyWith(
      color: errorColor,
      fontSize: 10.sp,
    ),
    fillColor: whiteColor,
    filled: true,
    errorMaxLines: 3,
    counterStyle: _lightTextTheme.bodySmall?.copyWith(fontSize: 10.sp),
    suffixIconColor: darkGrayColor,
    prefixIconColor: lightGrayColor,
    enabledBorder: _outlineInputBorder,
    border: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
    errorBorder: _outlineInputBorder.copyWith(
      borderSide: BorderSide(color: errorColor),
    ),
  );

  static final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.r),
    borderSide: BorderSide(
      color: blackColor.withValues(alpha: 0.1),
      width: 1.0,
    ),
  );

  // Dark Theme Configuration
  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    hintColor: darkHintColor,
    cardColor: darkCardColor,
    textTheme: _darkTextTheme,
    elevatedButtonTheme: _darkElevatedButtonTheme,
    inputDecorationTheme: _darkInputDecorationTheme,
    useMaterial3: true, colorScheme: _darkColorScheme.copyWith(surface: darkBackgroundColor).copyWith(error: errorColor),
  );

  static final _darkTextTheme = TextTheme(
    labelLarge: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: darkTextColor,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: darkHintColor,
    ),
  );

  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
    surface: darkBackgroundColor,
    onSurface: darkTextColor,
    primary: darkPrimaryColor,
    onPrimary: darkBackgroundColor,
    secondary: darkGrayColor,
    onSecondary: darkBackgroundColor,
  );

  static final _darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPrimaryColor,
      elevation: 10,
      textStyle: _darkTextTheme.labelLarge,
      shadowColor: darkPrimaryColor.withValues(alpha: 0.25),
      foregroundColor: darkBackgroundColor,
      padding: EdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      disabledBackgroundColor: darkPrimaryColor,
      disabledForegroundColor: darkBackgroundColor,
    ),
  );

  static final _darkInputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(16.w),
    hintStyle: _darkTextTheme.bodySmall,
    errorStyle: _darkTextTheme.bodySmall?.copyWith(
      color: errorColor,
      fontSize: 10.sp,
    ),
    fillColor: darkCardColor,
    filled: true,
    errorMaxLines: 3,
    counterStyle: _darkTextTheme.bodySmall?.copyWith(fontSize: 10.sp),
    suffixIconColor: darkHintColor,
    prefixIconColor: darkGrayColor,
    enabledBorder: _darkOutlineInputBorder,
    border: _darkOutlineInputBorder,
    focusedBorder: _darkOutlineInputBorder,
    errorBorder: _darkOutlineInputBorder.copyWith(
      borderSide: BorderSide(color: errorColor),
    ),
  );

  static final _darkOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.r),
    borderSide: BorderSide(
      color: darkGrayColor.withValues(alpha: 0.1),
      width: 1.0,
    ),
  );
}
