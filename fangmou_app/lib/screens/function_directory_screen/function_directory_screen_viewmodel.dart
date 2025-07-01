import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/use_cases/FileBatchProcessor.dart';
import '../../utils/constants/constants.dart';
import 'function_directory_screen_state.dart';

part 'function_directory_screen_viewmodel.g.dart';

@riverpod
class FunctionDirectoryScreenViewmodel extends _$FunctionDirectoryScreenViewmodel {
  final fileBatchProcessor = GetIt.I.get<FileBatchProcessor>();

  @override
  FunctionDirectoryScreenState build() {
    return FunctionDirectoryScreenState.initial();
  }

  void startPathProcess(WidgetRef ref) {
    logger.d("已经获取到地址 $state.pathController.text");
    fileBatchProcessor.fileBatchRemoveByPrefix(state.pathController.text, ref);
  }
}
