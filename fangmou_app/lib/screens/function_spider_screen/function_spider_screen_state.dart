import 'package:flutter/widgets.dart';

class FunctionSpiderScreenState {
  final TextEditingController inputController;
  final TextEditingController resultController;

  FunctionSpiderScreenState({required this.inputController,required this.resultController});

  FunctionSpiderScreenState.initial():inputController = TextEditingController(),resultController = TextEditingController();
}
