import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitevisits/core/network/flaky_task_api.dart';
import 'package:sitevisits/data/datasource/task_datasource.dart';
import 'package:sitevisits/data/datasource/task_local_datasource.dart';
import 'package:sitevisits/data/repository/task_repository.dart';
import 'package:sitevisits/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localDatasource = TaskLocalDatasource(prefs: prefs);
    final api = FlakyTaskApi(seed: 1);
    final repository = TaskRepository(
      provider: TaskDatasource(api: api),
      localDatasource: localDatasource,
    );

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();
    expect(find.text('My Visits'), findsOneWidget);
  });
}
