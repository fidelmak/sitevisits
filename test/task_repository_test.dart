import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitevisits/data/datasource/task_datasource.dart';
import 'package:sitevisits/data/datasource/task_local_datasource.dart';
import 'package:sitevisits/data/models/task_api_model.dart';
import 'package:sitevisits/data/repository/task_repository.dart';
import 'package:sitevisits/domain/entity.dart';

class MockTaskDatasource extends Mock implements TaskDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;
    late MockTaskDatasource mockDatasource;
    late TaskLocalDatasource localDatasource;

    final testItem = Item(
      id: 'task_1',
      title: 'Site Visit 1',
      status: Status.open,
      updatedAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
    );

    final testApiModel = TaskApiModel(
      items: [testItem],
      nextCursor: '1',
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localDatasource = TaskLocalDatasource(prefs: prefs);
      mockDatasource = MockTaskDatasource();

      repository = TaskRepository(
        provider: mockDatasource,
        localDatasource: localDatasource,
      );
    });

    test('getTask fetches from remote and caches items locally', () async {
      when(() => mockDatasource.getTasks()).thenAnswer((_) async => testApiModel);

      final result = await repository.getTask();

      expect(result.items.length, equals(1));
      expect(result.items.first.id, equals('task_1'));

      final cached = localDatasource.getCachedTasks();
      expect(cached.length, equals(1));
      expect(cached.first.id, equals('task_1'));
    });

    test('getTask falls back to local cache when remote throws error', () async {
      await localDatasource.saveTasks([testItem]);
      when(() => mockDatasource.getTasks()).thenThrow(Exception('Network error'));

      final result = await repository.getTask();

      expect(result.items.length, equals(1));
      expect(result.items.first.title, equals('Site Visit 1'));
    });

    test('upDateTask updates remote and clears sync status on success', () async {
      final updatedItem = testItem.copyWith(status: Status.done);
      when(() => mockDatasource.upDateTasks('task_1', Status.done))
          .thenAnswer((_) async => updatedItem);

      final result = await repository.upDateTask('task_1', Status.done);

      expect(result.status, equals(Status.done));
      expect(result.syncStatus, isNull);

      final unsynced = localDatasource.getUnsyncedTasks();
      expect(unsynced.isEmpty, isTrue);
    });

    test('upDateTask marks task as not saved retry locally on remote failure', () async {
      when(() => mockDatasource.upDateTasks('task_1', Status.done))
          .thenThrow(Exception('Server error'));

      await expectLater(
        repository.upDateTask('task_1', Status.done),
        throwsA(isA<Exception>()),
      );

      final unsynced = localDatasource.getUnsyncedTasks();
      expect(unsynced.length, equals(1));
      expect(unsynced.first.syncStatus, equals('not saved retry'));
    });

    test('searchTasks falls back to filtering local cache when network fails', () async {
      final item2 = Item(
        id: 'task_2',
        title: 'HQ Audit',
        status: Status.open,
        updatedAt: DateTime.now(),
      );
      await localDatasource.saveTasks([testItem, item2]);

      when(() => mockDatasource.getTasks(query: 'audit', cursor: null))
          .thenThrow(Exception('Network error'));

      final result = await repository.searchTasks('audit');

      expect(result.items.length, equals(1));
      expect(result.items.first.title, equals('HQ Audit'));
    });
  });
}
