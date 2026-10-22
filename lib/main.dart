import 'package:flutter/material.dart';
import 'package:sitevisits/presentation/pages/home_screen.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';
import 'package:sitevisits/presentation/theme/app_test.dart';
import 'package:sitevisits/presentation/widgets/app_search_bar.dart';
import 'package:sitevisits/presentation/widgets/task_card.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: AppText(title: 'My Visits', size: 24.sp),
              backgroundColor: AppColors.background,
              scrolledUnderElevation: 0.0,
              surfaceTintColor: Colors.transparent,
            ),
            body: Center(child: const HomeScreen()),
          ),
        );
      },
    );
  }
}
