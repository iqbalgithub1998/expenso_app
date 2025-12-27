import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.light,
      side: const BorderSide(color: TColors.textWhite),
      textStyle: TextStyle(
        fontSize: 16.sp,
        color: TColors.black,
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(TSizes.borderRadiusLg.r),
        ),
      ),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.light,
      side: const BorderSide(color: TColors.borderPrimary),
      textStyle: TextStyle(
        fontSize: 16.sp,
        color: TColors.textWhite,
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
      ),
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(TSizes.borderRadiusLg.r),
        ),
      ),
    ),
  );
}
