import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_test.dart';


// app button widget
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.textColor = AppColors.white,
    this.bgColor = AppColors.success,
    this.size = 16,
  });

  final String title;
  final VoidCallback onPressed;
  final Color textColor;
  final Color bgColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        side: BorderSide(color: bgColor),
        minimumSize: Size.fromHeight(48.h),
      ),
      onPressed: onPressed,
      child: AppText(title: title, color: textColor, size: size),
    );
  }
}