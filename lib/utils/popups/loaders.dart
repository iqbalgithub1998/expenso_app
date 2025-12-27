import 'package:expenso/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TLoaders {
  static successSnackBar({required title, message = "", duration = 3}) {
    Get.snackbar(
      '',
      '',
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.green.shade600,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
      margin: EdgeInsets.all(20.w),
      icon: Padding(
        padding: EdgeInsets.all(18.w),
        child: const Icon(
          CupertinoIcons.checkmark_alt_circle,
          color: TColors.white,
          size: 30,
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: TColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: TColors.white,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      '',
      '',
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      icon: Padding(
        padding: EdgeInsets.all(18.w),
        child: const Icon(
          CupertinoIcons.exclamationmark_circle,
          color: TColors.white,
          size: 30,
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: TColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: TColors.white,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      '',
      '',
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      icon: Padding(
        padding: EdgeInsets.all(18.w),
        child: const Icon(
          CupertinoIcons.exclamationmark_circle,
          color: TColors.white,
          size: 30,
        ),
      ),
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: TColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: TColors.white,
            fontSize: 14.sp,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
