import 'package:decimal/decimal.dart';
import 'package:fangmou_app/screens/function_calculator_screen/model/calculate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'function_calculator_screen_state.dart';

part 'function_calculator_screen_viewmodel.g.dart';

@riverpod
class FunctionCalculatorScreenViewmodel extends _$FunctionCalculatorScreenViewmodel {
  @override
  FunctionCalculatorScreenState build() {
    return FunctionCalculatorScreenState.initiate();
  }

  void addChar(CalculateButton calculateButton) {
    switch (calculateButton) {
      case CalculateButton.backspace:
        state.input.text = state.input.text.substring(0, state.input.text.length - 1);
        break;
      case CalculateButton.clean:
        state = FunctionCalculatorScreenState.initiate();
        break;
      default:
        state = process(calculateButton);
    }
  }

  FunctionCalculatorScreenState process(CalculateButton calculateButton) {
    switch (calculateButton.type) {
      case CalculateButtonType.number:
        return number(calculateButton);
      case CalculateButtonType.operator:
        return operator(calculateButton);
      case CalculateButtonType.other:
        return state;
    }
  }

  FunctionCalculatorScreenState number(CalculateButton calculateButton) {
    final input = state.input.text;

    String inputResult = "";
    switch (calculateButton) {
      case CalculateButton.negate:
        if (input.startsWith(CalculateButton.negate.symbol)) {
          inputResult = input.substring(1);
        } else {
          inputResult = calculateButton.symbol + input;
        }
        break;
      case CalculateButton.decimalPoint:
        if (!input.endsWith(CalculateButton.decimalPoint.symbol)) {
          inputResult = input + CalculateButton.decimalPoint.symbol;
        } else {
          inputResult = input;
        }
        break;
      default:
        inputResult = input + calculateButton.symbol;
    }
    return state.copyWith(lastClick: calculateButton, input: TextEditingController(text: inputResult));
  }

  FunctionCalculatorScreenState operator(CalculateButton calculateButton) {
    if (state.input.text.isEmpty) return state;
    final input = Decimal.parse(state.input.text);
    final formula = state.formula.text;
    final lastOperator = state.lastOperator;
    String inputResult = "";
    String formulaResult = "";

    // 使用了重复的操作符，不进行处理
    if (calculateButton == state.lastClick) return state;

    if (lastOperator == CalculateButton.space) {
      // region <- Logic:初次输入数字和计算符号，等待下一次输入 ->
      formulaResult = input.toString() + calculateButton.symbol;
      inputResult = "";
      // endregion <- Logic: ->
    } else {
      // region <- Logic:运算处理 ->
      Decimal lastValue;
      if (lastOperator == CalculateButton.equalTo) {
        lastValue = input;
      } else {
        lastValue = Decimal.parse(formula.substring(0, formula.length - 1));
      }
      switch (lastOperator) {
        case CalculateButton.equalTo:
          lastValue = lastValue;
          break;
        case CalculateButton.add:
          lastValue = lastValue + input;
          break;
        case CalculateButton.subtract:
          lastValue = lastValue - input;
          break;
        case CalculateButton.multiply:
          lastValue = lastValue * input;
          break;
        case CalculateButton.divide:
          lastValue = (lastValue / input).toDecimal(scaleOnInfinitePrecision: 10);
        default:
          throw "未处理的操作符";
      }

      if(CalculateButton.equalTo == calculateButton){
        formulaResult =formula + lastValue.toString() + calculateButton.symbol;
        inputResult = lastValue.toString();
      }else{
        formulaResult = lastValue.toString() + calculateButton.symbol;
        inputResult = "";
      }
      // endregion <- Logic:运算处理 ->
    }

    return state.copyWith(
      input: TextEditingController(text: inputResult),
      formula: TextEditingController(text: formulaResult),
      lastClick: calculateButton,
      lastOperator: calculateButton,
    );
  }
}
