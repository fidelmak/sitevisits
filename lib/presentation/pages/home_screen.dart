import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


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

    context.read<TaskBloc>().add(GetTask());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TaskBloc>().add(LoadMoreTasks());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Triggers
    return currentScroll >= (maxScroll - 200);
  }
  Timer? _debounce;



  void _onSearch(String query) {
    // Cancel
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Wait 400ms after the user stops typing before dispatching
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        // Reset
        context.read<TaskBloc>().add(GetTask());
      } else {
        context.read<TaskBloc>().add(SearchTasks(trimmed));
      }
    });
  }

  void _onClear() {
    _debounce?.cancel();
    // Reset
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
              onSearch: _onSearch,
              onClear: _onClear,
            ),
            Expanded(
              child: BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('loading Tasks')),
                    );
                  }
                  if (state is TaskUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task Updated')),
                    );
                  }
                  if (state is TaskError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('loading Error')),
                    );
                  }
                },

                buildWhen: (previous, current) {
                  // this  Prevents temporary status from destroying the ListView
                  return current is TaskLoaded ||
                      current is TaskLoading ||
                      current is TaskError;
                },
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return Center(
                      child: SizedBox(
                        width: 50.r,
                        height: 50.r,
                        child: const CircularProgressIndicator(

                          color: AppColors.success,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  if (state is TaskLoaded) {
                    return


                      RefreshIndicator(
                        color: AppColors.checkboxOutline,
                        onRefresh: () {
                          final completer = Completer<void>();
                          context.read<TaskBloc>().add(RefreshTasks(completer: completer));
                          return completer.future;
                        },
                        child: state.tasks.items.isEmpty
                            ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('No Visit found')),
                          ],
                        )
                            : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                                             // itemCount: state.tasks.items.length ?? 0,
                        itemCount: state.isLoadingMore
                            ? state.tasks.items.length + 1
                            :state.tasks.items.length,



                        itemBuilder: (context, index) {

                          if (index == state.tasks.items.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: SizedBox(
                                  width: 24.r,
                                  height: 24.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.checkboxOutline,
                                  ),
                                ),
                              ),
                            );
                          }
                          //  final Map<String, String> task = tasks[index];
                          final tasks = state.tasks.items[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TaskCard(
                              title: tasks.title,

                              //task["title"].toString(),
                              updateTime: tasks.updatedAt,
                              //task["updatedAt"].toString(),
                              status: tasks.status.toString(),
                              //task["status"].toString(),
                              isChecked: tasks.status == Status.open
                                  ? _isChecked
                                  : !_isChecked,
                              update: () {
                                debugPrint('1. tap: ${tasks.id}');
                                if (tasks.status == Status.archived) return;
                                context.read<TaskBloc>().add(
                                  UpdateTask(
                                    id: tasks.id,
                                    status: tasks.status == Status.done
                                        ? Status.open
                                        : Status.done,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                                            ),
                      );
                  }
                  if (state is TaskError) {
                    return ErrorWidgets(
                      onPress: () {
                        context.read<TaskBloc>().add(GetTask());
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
