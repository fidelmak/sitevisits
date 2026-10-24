import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_test.dart';

class AppSnackBar {
  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkSlate,
        margin: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: const BorderSide(color: AppColors.darkSlate, width: 1),
        ),
        duration: duration,
        content: Row(
          children: [


            Expanded(
              child: AppText(
                title: message,
                size: 14.sp,
                color: AppColors.white,
                weight: FontWeight.w500,
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onRetry();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: AppText(
                  title: 'Retry',
                  size: 14.sp,
                  color: AppColors.bermuda,
                  weight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.checkboxOutline,
        margin: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: duration,
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.white,
              size: 22.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppText(
                title: message,
                size: 14.sp,
                color: AppColors.white,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.headerBackground,
        margin: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: const BorderSide(color: AppColors.searchBorder, width: 1),
        ),
        duration: duration,
        content: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.textPrimary,
              size: 22.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppText(
                title: message,
                size: 14.sp,
                color: AppColors.textPrimary,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
