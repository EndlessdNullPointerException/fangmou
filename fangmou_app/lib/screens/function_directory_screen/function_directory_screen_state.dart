import 'package:fangmou_app/screens/function_directory_screen/model/process_mode.dart';
import 'package:flutter/cupertino.dart';

class FunctionDirectoryScreenState {
  final TextEditingController pathController;
  final ProcessMode processMode;

  FunctionDirectoryScreenState({required this.pathController, required this.processMode});

  FunctionDirectoryScreenState.initial() : pathController = TextEditingController(), processMode = ProcessMode.manga;

  FunctionDirectoryScreenState copyWith({pathController, processMode}) {
    return FunctionDirectoryScreenState(
      pathController: pathController ?? this.pathController,
      processMode: processMode ?? this.processMode,
    );
  }
}
