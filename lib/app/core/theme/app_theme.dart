import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    backgroundColor: backgroundColor,
    primaryColor: blueColor,
    hintColor: lightGrayColor,
    cardColor: whiteColor,
    errorColor: errorColor,
    textTheme: _lightTextTheme,
    colorScheme: _lightColorScheme,
    elevatedButtonTheme: _lightElevatedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    useMaterial3: true,
  );

  static final _lightTextTheme = TextTheme(
    button: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    ),
    caption: GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: lightGrayColor,
    ),
  );

  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: blueColor,
    brightness: Brightness.light,
    background: backgroundColor,
    onBackground: blackColor,
    primary: blueColor,
    onPrimary: backgroundColor,
    secondary: darkGrayColor,
    onSecondary: backgroundColor,
  );

  static final _lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: blueColor,
      elevation: 10,
      textStyle: _lightTextTheme.button,
      shadowColor: blueColor.withOpacity(0.25),
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
    hintStyle: _lightTextTheme.caption,
    errorStyle: _lightTextTheme.caption?.copyWith(
      color: errorColor,
      fontSize: 10.sp,
    ),
    fillColor: whiteColor,
    filled: true,
    errorMaxLines: 3,
    counterStyle: _lightTextTheme.caption?.copyWith(fontSize: 10.sp),
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
      color: blackColor.withOpacity(0.1),
      width: 1.0,
    ),
  );

  // Dark Theme Configuration
  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    backgroundColor: darkBackgroundColor,
    primaryColor: darkPrimaryColor,
    hintColor: darkHintColor,
    cardColor: darkCardColor,
    errorColor: errorColor,
    textTheme: _darkTextTheme,
    colorScheme: _darkColorScheme,
    elevatedButtonTheme: _darkElevatedButtonTheme,
    inputDecorationTheme: _darkInputDecorationTheme,
    useMaterial3: true,
  );

  static final _darkTextTheme = TextTheme(
    button: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: darkTextColor,
    ),
    caption: GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: darkHintColor,
    ),
  );

  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
    background: darkBackgroundColor,
    onBackground: darkTextColor,
    primary: darkPrimaryColor,
    onPrimary: darkBackgroundColor,
    secondary: darkGrayColor,
    onSecondary: darkBackgroundColor,
  );

  static final _darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPrimaryColor,
      elevation: 10,
      textStyle: _darkTextTheme.button,
      shadowColor: darkPrimaryColor.withOpacity(0.25),
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
    hintStyle: _darkTextTheme.caption,
    errorStyle: _darkTextTheme.caption?.copyWith(
      color: errorColor,
      fontSize: 10.sp,
    ),
    fillColor: darkCardColor,
    filled: true,
    errorMaxLines: 3,
    counterStyle: _darkTextTheme.caption?.copyWith(fontSize: 10.sp),
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
      color: darkGrayColor.withOpacity(0.1),
      width: 1.0,
    ),
  );
}
