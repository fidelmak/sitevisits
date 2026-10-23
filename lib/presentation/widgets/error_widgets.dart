import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_test.dart';
import 'app_button.dart';

class ErrorWidgets extends StatelessWidget {
  final VoidCallback onPress;
  const ErrorWidgets({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        SizedBox(height: 80.h,),
      Icon(Icons.error_outline,

            color: AppColors.errorText.withAlpha(140),
          size: 70.r,
        ),
        SizedBox(height: 12.h,),
        const AppText(
          title: "Could't load your visits",
          weight: FontWeight.bold,
        ),

        SizedBox(height: 12.h,),
        const AppText(title: "Check your connection and try again"),

        SizedBox(height: 12.h,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 130.sp),
          child: AppButton(title: 'Retry', onPressed: onPress,size: 20.sp,),
        ),
      ],
    );
  }
}
