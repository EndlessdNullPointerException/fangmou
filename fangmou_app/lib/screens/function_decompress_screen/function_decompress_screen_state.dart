import 'package:flutter/cupertino.dart';

class FunctionDecompressScreenState {
  final bool decompressDescendantFolder;
  final bool deleteOriginFile;
  final bool decompressAllTypeFile;

  late final TextEditingController pathController;

  final List<TextEditingController> passwordControllerList;

  List<String> get passwordList =>
      passwordControllerList.isNotEmpty ? passwordControllerList.map((i) => i.text).toList() : [];

  FunctionDecompressScreenState({
    required this.decompressDescendantFolder,
    required this.decompressAllTypeFile,
    required this.deleteOriginFile,
    required this.passwordControllerList,
    required this.pathController,
  });

  FunctionDecompressScreenState.initial(this.passwordControllerList)
    : pathController = TextEditingController(),
      decompressDescendantFolder = false,
      decompressAllTypeFile = false,
      deleteOriginFile = false;

  FunctionDecompressScreenState copyWith({
    bool? decompressDescendantFolder,
    bool? deleteOriginFile,
    bool? decompressAllTypeFile,
    TextEditingController? pathController,
    List<TextEditingController>? passwordControllerList,
  }) {
    return FunctionDecompressScreenState(
      decompressDescendantFolder: decompressDescendantFolder ?? this.decompressDescendantFolder,
      deleteOriginFile: deleteOriginFile ?? this.deleteOriginFile,
      decompressAllTypeFile: decompressAllTypeFile ?? this.decompressAllTypeFile,
      pathController: pathController ?? this.pathController,
      passwordControllerList: passwordControllerList ?? this.passwordControllerList,
    );
  }
}
