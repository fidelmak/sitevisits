import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitevisits/data/datasource/task_datasource.dart';
import 'package:sitevisits/presentation/bloc/task_bloc.dart';
import 'package:sitevisits/presentation/pages/home_screen.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';
import 'package:sitevisits/presentation/theme/app_test.dart';

import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'data/repository/task_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  final repository = TaskRepository(provider: TaskDatasource(client: http.Client()));
  runApp(MyApp(repository: repository,));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return BlocProvider(
          create: (context) => TaskBloc(repository: repository),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: AppText(title: 'My Visits', size: 24.sp),
                backgroundColor: AppColors.background,
                scrolledUnderElevation: 0.0,
                surfaceTintColor: Colors.transparent,
              ),
              body: Padding(
                padding: EdgeInsets.all(12.sp),
                child: const HomeScreen(),
              ),
            ),
          ),
        );
      },
    );
  }
}
