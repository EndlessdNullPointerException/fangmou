import 'package:flutter/cupertino.dart';

class FunctionDecompressScreenState {
  final bool decompressDescendantFolder;

  late final TextEditingController pathController;

  final List<TextEditingController> passwordControllerList;

  List<String> get passwordList => passwordControllerList.isNotEmpty ? passwordControllerList.map((i) => i.text).toList() : [];

  FunctionDecompressScreenState({required this.decompressDescendantFolder, required this.passwordControllerList, required this.pathController});

  FunctionDecompressScreenState.initial(this.passwordControllerList) : pathController = TextEditingController(), decompressDescendantFolder = false;

  FunctionDecompressScreenState copyWith({
    bool? decompressDescendantFolder,
    TextEditingController? pathController,
    List<TextEditingController>? passwordControllerList,
  }) {
    return FunctionDecompressScreenState(
      decompressDescendantFolder: decompressDescendantFolder ?? this.decompressDescendantFolder,
      pathController: pathController ?? this.pathController,
      passwordControllerList: passwordControllerList ?? this.passwordControllerList,
    );
  }
}
