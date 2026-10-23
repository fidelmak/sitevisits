import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../data/models/task_api_model.dart';
import '../../domain/entity.dart';
import '../bloc/task_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/error_widgets.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();


  final bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    debugPrint('initState: dispatching GetTask');
    context.read<TaskBloc>().add(GetTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(

        child: Column(
          children: [
            AppSearch(
              hintText: 'Search visits',
              onSearch: (query) {

              },
              onClear: () {

              },
            ),
            Expanded(
              child: BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if(state is TaskLoading){
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('loading Tasks')));
                  }
                  if(state is TaskUpdated){
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Task Updated')));
                  }
                  if(state is TaskError){
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('loading Error')));
                  }

                },
                builder: (context, state) {


                  if(state is TaskLoading){
                    return  Center(
                      child: SizedBox(
                        width: 50.r,
                        height: 50.r,
                        child: const CircularProgressIndicator(
                          color: AppColors.checkboxOutline,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  if(state is TaskLoaded){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount:state.tasks.items.length ?? 0,
                    itemBuilder: (context, index) {
                    //  final Map<String, String> task = tasks[index];
                      final tasks = state.tasks.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TaskCard(
                          title:tasks.title, //task["title"].toString(),

                          updateTime: tasks.updatedAt, //task["updatedAt"].toString(),
                          status:tasks.status.toString(), //task["status"].toString(),
                          isChecked:  tasks.status == Status.open ? _isChecked : !_isChecked,
                          update: () {
                            debugPrint('1. tap: ${tasks.id}');
                            if (tasks.status == Status.archived) return;
                            context.read<TaskBloc>().add(UpdateTask(
                              id: tasks.id,
                              status: tasks.status == Status.done ? Status.open : Status.done,
                            ));

                          },
                        ),
                      );
                    },
                  );}
                  return ErrorWidgets(onPress: () {

                  context.read<TaskBloc>().add(GetTask());
                  },);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
