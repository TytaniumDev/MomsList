import 'package:moms_list/app/app.dart';
import 'package:moms_list/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
