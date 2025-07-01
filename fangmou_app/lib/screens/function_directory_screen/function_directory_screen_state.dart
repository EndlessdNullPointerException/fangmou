import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FunctionDirectoryScreenState {
  final TextEditingController pathController;

  FunctionDirectoryScreenState({required this.pathController});

  FunctionDirectoryScreenState.initial() : pathController = TextEditingController();
}
