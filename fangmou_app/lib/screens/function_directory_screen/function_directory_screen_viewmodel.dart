import 'package:fangmou_app/screens/function_directory_screen/model/process_mode.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common_widgets/loading_status_widget.dart';
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

  Stream<LoadingStatusData> startPathProcess() async* {
    logger.d("已经获取到地址 $state.pathController.text");
    yield LoadingStatusData(loadingStatus: LoadingStatus.loading, currentStatusDescription: "开始处理，路径为${state.pathController.text}");

    try {
      yield* fileBatchProcessor.fileBatchRemoveByPrefix(state.pathController.text, state.processMode);
      yield LoadingStatusData(loadingStatus: LoadingStatus.success, currentStatusDescription: "完成");
    } catch (e) {
      logger.d(e);
      yield LoadingStatusData(loadingStatus: LoadingStatus.error, currentStatusDescription: "$e");
    }
  }

  void changeProcessMode(ProcessMode? value) {
    logger.d("=============");
    logger.d(value);
    state = state.copyWith(processMode: value);
    logger.d(state.processMode);
    logger.d("=============");
  }
}
