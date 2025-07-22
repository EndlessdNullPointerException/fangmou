import 'package:fangmou_app/screens/function_calculator_screen/model/calculate_button.dart';
import 'package:flutter/cupertino.dart';

class FunctionCalculatorScreenState {
  final TextEditingController input;
  final TextEditingController formula;
  final CalculateButton lastClick;
  final CalculateButton lastOperator;

  FunctionCalculatorScreenState({required this.input, required this.formula, required this.lastClick, required this.lastOperator});

  FunctionCalculatorScreenState.initiate()
    : input = TextEditingController(),
      formula = TextEditingController(),
      lastClick = CalculateButton.space,
      lastOperator = CalculateButton.space;

  FunctionCalculatorScreenState copyWith({
    TextEditingController? input,
    TextEditingController? formula,
    CalculateButton? lastClick,
    CalculateButton? lastOperator,
  }) {
    return FunctionCalculatorScreenState(
      input: input ?? this.input,
      formula: formula ?? this.formula,
      lastClick: lastClick ?? this.lastClick,
      lastOperator: lastOperator ?? this.lastOperator,
    );
  }
}
