import 'package:expenso/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: TColors.black, size: TSizes.iconMd),
    actionsIconTheme: const IconThemeData(
      color: TColors.black,
      size: TSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: TColors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: TColors.black, size: TSizes.iconMd),
    actionsIconTheme: const IconThemeData(
      color: TColors.white,
      size: TSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: TColors.white,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
