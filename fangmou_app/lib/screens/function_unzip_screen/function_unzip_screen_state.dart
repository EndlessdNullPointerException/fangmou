import 'package:flutter/cupertino.dart';

class FunctionUnzipScreenState {
  final bool decompressDescendantFolder;

  late final TextEditingController pathController;

  final List<TextEditingController> passwordControllerList;

  List<String> get passwordList => passwordControllerList.isNotEmpty ? passwordControllerList.map((i) => i.text).toList() : [];

  FunctionUnzipScreenState({required this.decompressDescendantFolder, required this.passwordControllerList, required this.pathController});

  FunctionUnzipScreenState.initial(this.passwordControllerList) : pathController = TextEditingController(), decompressDescendantFolder = false;

  FunctionUnzipScreenState copyWith({
    bool? decompressDescendantFolder,
    TextEditingController? pathController,
    List<TextEditingController>? passwordControllerList,
  }) {
    return FunctionUnzipScreenState(
      decompressDescendantFolder: decompressDescendantFolder ?? this.decompressDescendantFolder,
      pathController: pathController ?? this.pathController,
      passwordControllerList: passwordControllerList ?? this.passwordControllerList,
    );
  }
}
