import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: TColors.darkGrey,
    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: TSizes.fontSizeMd,
      color: TColors.black.withValues(alpha: 0.4),
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: TSizes.fontSizeSm,
      color: TColors.black.withValues(alpha: 0.4),
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontSize: 12.sp,
      color: TColors.error,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: TColors.black.withValues(alpha: 0.5),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: BorderSide(
        width: 1,
        color: TColors.dark.withValues(alpha: 0.8),
      ),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: BorderSide(
        width: 1,
        color: TColors.dark.withValues(alpha: 0.8),
      ),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: BorderSide(
        width: 1,
        color: TColors.dark.withValues(alpha: 0.8),
      ),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 1, color: TColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 2, color: TColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: TColors.darkGrey,
    suffixIconColor: TColors.darkGrey,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontSize: 12.sp,
      color: TColors.error,
    ),
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: TSizes.fontSizeMd,
      color: TColors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: TSizes.fontSizeSm,
      color: TColors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: TColors.white.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 1, color: TColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 1, color: TColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 1, color: TColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 1, color: TColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusLg.w)),
      borderSide: const BorderSide(width: 2, color: TColors.warning),
    ),
  );
}
