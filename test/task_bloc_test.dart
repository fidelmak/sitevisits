import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sitevisits/data/models/task_api_model.dart';
import 'package:sitevisits/data/repository/task_repository.dart';
import 'package:sitevisits/domain/entity.dart';
import 'package:sitevisits/presentation/bloc/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TaskBloc Unit Tests with bloc_test', () {
    late MockTaskRepository mockRepository;

    final testItem = Item(
      id: 'task_4',
      title: 'Site visit #4',
      status: Status.open,
      updatedAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
    );

    final testApiModel = TaskApiModel(
      items: [testItem],
      nextCursor: '1',
    );

    setUp(() {
      mockRepository = MockTaskRepository();
    });

    test('initial state is TaskInitial', () {
      final bloc = TaskBloc(repository: mockRepository);
      expect(bloc.state, equals(TaskInitial()));
      bloc.close();
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when GetTask succeeds',
      build: () {
        when(() => mockRepository.getTask()).thenAnswer((_) async => testApiModel);
        return TaskBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(GetTask()),
      expect: () => [
        TaskLoading(),
        TaskLoaded(tasks: testApiModel),
      ],
      verify: (_) {
        verify(() => mockRepository.getTask()).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskError] when GetTask fails',
      build: () {
        when(() => mockRepository.getTask()).thenThrow(Exception('Server error'));
        return TaskBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(GetTask()),
      expect: () => [
        TaskLoading(),
        const TaskError('Exception: Server error'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits optimistic pending state then TaskUpdated and TaskLoaded on UpdateTask success',
      build: () {
        final updatedItem = testItem.copyWith(status: Status.done);
        when(() => mockRepository.upDateTask('task_4', Status.done))
            .thenAnswer((_) async => updatedItem);
        return TaskBloc(repository: mockRepository);
      },
      seed: () => TaskLoaded(tasks: testApiModel),
      act: (bloc) => bloc.add(const UpdateTask(id: 'task_4', status: Status.done)),
      expect: () {
        final pendingItem = testItem.copyWith(status: Status.done, syncStatus: 'pending');
        final pendingState = TaskLoaded(tasks: TaskApiModel(items: [pendingItem], nextCursor: '1'));

        final syncedItem = testItem.copyWith(status: Status.done, clearSyncStatus: true);
        final syncedState = TaskLoaded(tasks: TaskApiModel(items: [syncedItem], nextCursor: '1'));

        return [
          pendingState,
          TaskUpdated(syncedItem),
          syncedState,
        ];
      },
      verify: (_) {
        verify(() => mockRepository.upDateTask('task_4', Status.done)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits optimistic pending state, TaskError withFormatted ID #4, and not saved retry status on failure',
      build: () {
        when(() => mockRepository.upDateTask('task_4', Status.done))
            .thenThrow(Exception('Timeout'));
        return TaskBloc(repository: mockRepository);
      },
      seed: () => TaskLoaded(tasks: testApiModel),
      act: (bloc) => bloc.add(const UpdateTask(id: 'task_4', status: Status.done)),
      expect: () {
        final pendingItem = testItem.copyWith(status: Status.done, syncStatus: 'pending');
        final pendingState = TaskLoaded(tasks: TaskApiModel(items: [pendingItem], nextCursor: '1'));

        final errorItem = testItem.copyWith(status: Status.done, syncStatus: 'not saved retry');
        final errorLoadedState = TaskLoaded(tasks: TaskApiModel(items: [errorItem], nextCursor: '1'));

        return [
          pendingState,
          const TaskError("Couldn't update site visit #4"),
          errorLoadedState,
        ];
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskLoaded with searchQuery when SearchTasks returns results',
      build: () {
        when(() => mockRepository.searchTasks('visit #4'))
            .thenAnswer((_) async => testApiModel);
        return TaskBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const SearchTasks('visit #4')),
      expect: () => [
        TaskLoaded(tasks: testApiModel, searchQuery: 'visit #4'),
      ],
      verify: (_) {
        verify(() => mockRepository.searchTasks('visit #4')).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits TaskLoaded with searchQuery and empty items when search query has no match',
      build: () {
        final emptyModel = TaskApiModel(items: []);
        when(() => mockRepository.searchTasks('visit #900'))
            .thenAnswer((_) async => emptyModel);
        return TaskBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const SearchTasks('visit #900')),
      expect: () => [
        TaskLoaded(tasks: TaskApiModel(items: []), searchQuery: 'visit #900'),
      ],
    );
  });
}
