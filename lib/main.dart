import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/flaky_task_api.dart';
import 'data/datasource/task_datasource.dart';
import 'data/datasource/task_local_datasource.dart';
import 'data/repository/task_repository.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/theme/app_colors.dart';
import 'presentation/theme/app_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localDatasource = TaskLocalDatasource(prefs: prefs);
  final api = FlakyTaskApi();
  final repository = TaskRepository(
    provider: TaskDatasource(api: api),
    localDatasource: localDatasource,
  );

  runApp(MyApp(repository: repository));
}
// my entering point
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
                actions: [
                  BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoaded) {
                        final unsyncedCount = state.tasks.items
                            .where((item) =>
                                item.syncStatus == 'pending' ||
                                item.syncStatus == 'not saved retry')
                            .length;

                        if (unsyncedCount > 0) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Center(
                              child: AppText(
                                title: "$unsyncedCount unsynced",
                                color: AppColors.errorText,
                                weight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
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
