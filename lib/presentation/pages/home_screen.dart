import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> tasks = [
    {
      "id": "task_1",
      "title": "Site visit #1",
      "status": "done",
      "updatedAt": "2026-01-01T00:00:00.000Z",
    },
    {
      "id": "task_2",
      "title": "Site visit #2",
      "status": "open",
      "updatedAt": "2026-01-01T00:37:00.000Z",
    },
    {
      "id": "task_3",
      "title": "Site visit #3",
      "status": "open",
      "updatedAt": "2026-01-01T01:14:00.000Z",
    },
    {
      "id": "task_4",
      "title": "Site visit #4",
      "status": "open",
      "updatedAt": "2026-01-01T01:51:00.000Z",
    },
    {
      "id": "task_5",
      "title": "Site visit #5",
      "status": "done",
      "updatedAt": "2026-01-01T02:28:00.000Z",
    },
    {
      "id": "task_6",
      "title": "Site visit #6",
      "status": "open",
      "updatedAt": "2026-01-01T03:05:00.000Z",
    },
    {
      "id": "task_7",
      "title": "Site visit #7",
      "status": "open",
      "updatedAt": "2026-01-01T03:42:00.000Z",
    },
    {
      "id": "task_8",
      "title": "Site visit #8",
      "status": "open",
      "updatedAt": "2026-01-01T04:19:00.000Z",
    },
    {
      "id": "task_9",
      "title": "Site visit #9",
      "status": "done",
      "updatedAt": "2026-01-01T04:56:00.000Z",
    },
    {
      "id": "task_10",
      "title": "Site visit #10",
      "status": "open",
      "updatedAt": "2026-01-01T05:33:00.000Z",
    },
    {
      "id": "task_11",
      "title": "Site visit #11",
      "status": "open",
      "updatedAt": "2026-01-01T06:10:00.000Z",
    },
    {
      "id": "task_12",
      "title": "Site visit #12",
      "status": "open",
      "updatedAt": "2026-01-01T06:47:00.000Z",
    },
    {
      "id": "task_13",
      "title": "Site visit #13",
      "status": "done",
      "updatedAt": "2026-01-01T07:24:00.000Z",
    },
    {
      "id": "task_14",
      "title": "Site visit #14",
      "status": "open",
      "updatedAt": "2026-01-01T08:01:00.000Z",
    },
    {
      "id": "task_15",
      "title": "Site visit #15",
      "status": "open",
      "updatedAt": "2026-01-01T08:38:00.000Z",
    },
    {
      "id": "task_16",
      "title": "Site visit #16",
      "status": "open",
      "updatedAt": "2026-01-01T09:15:00.000Z",
    },
    {
      "id": "task_17",
      "title": "Site visit #17",
      "status": "done",
      "updatedAt": "2026-01-01T09:52:00.000Z",
    },
    {
      "id": "task_18",
      "title": "Site visit #18",
      "status": "open",
      "updatedAt": "2026-01-01T10:29:00.000Z",
    },
    {
      "id": "task_19",
      "title": "Site visit #19",
      "status": "open",
      "updatedAt": "2026-01-01T11:06:00.000Z",
    },
    {
      "id": "task_20",
      "title": "Site visit #20",
      "status": "open",
      "updatedAt": "2026-01-01T11:43:00.000Z",
    },
  ];

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(

        child: Column(
          children: [
            AppSearch(
              hintText: 'Search visits',
              onSearch: (query) {},
              onClear: () {},
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final Map<String, String> task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TaskCard(
                      title: task["title"].toString(),
                      updateTime: task["updatedAt"].toString(),
                      status: task["status"].toString(),
                      isChecked: _isChecked,
                    ),
                  );
                },
              ),
              ),
          ],
        ),
      ),
    );
  }
}
