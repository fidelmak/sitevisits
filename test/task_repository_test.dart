import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitevisits/data/datasource/task_local_datasource.dart';
import 'package:sitevisits/data/models/task_api_model.dart';
import 'package:sitevisits/domain/entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TaskLocalDatasource Tests', () {
    late TaskLocalDatasource localDatasource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localDatasource = TaskLocalDatasource(prefs: prefs);
    });

    test('should cache and retrieve tasks correctly', () async {
      final items = [
        Item(
          id: '1',
          title: 'Site Visit 1',
          status: Status.open,
          updatedAt: DateTime.now(),
        ),
      ];

      await localDatasource.saveTasks(items);
      final cached = localDatasource.getCachedTasks();

      expect(cached.length, equals(1));
      expect(cached.first.title, equals('Site Visit 1'));
    });

    test('should update task local sync status and count unsynced', () async {
      await localDatasource.updateTaskLocal('task_1', Status.done, 'pending');

      final unsynced = localDatasource.getUnsyncedTasks();
      expect(unsynced.length, equals(1));
      expect(unsynced.first.syncStatus, equals('pending'));

      await localDatasource.markTaskSynced('task_1');
      final unsyncedAfter = localDatasource.getUnsyncedTasks();
      expect(unsyncedAfter.isEmpty, isTrue);
    });

    test('should filter cached tasks by query', () async {
      final items = [
        Item(id: '1', title: 'Inspection HQ', status: Status.open, updatedAt: DateTime.now()),
        Item(id: '2', title: 'Site Audit North', status: Status.done, updatedAt: DateTime.now()),
      ];
      await localDatasource.saveTasks(items);

      final cached = localDatasource.getCachedTasks();
      final filtered = cached
          .where((i) => i.title.toLowerCase().contains('audit'.toLowerCase()))
          .toList();

      expect(filtered.length, equals(1));
      expect(filtered.first.title, equals('Site Audit North'));
    });
  });
}
