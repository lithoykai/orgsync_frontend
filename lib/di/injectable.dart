import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable.config.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void setup() {}

final getIt = GetIt.instance;

Future<void> init() async {
  $initGetIt(getIt);
}
