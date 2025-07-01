export 'constants.dart';

// 定义常量对象
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

// 顶层常量
final GetIt getIt = GetIt.instance;
final logger = getIt<Logger>();
