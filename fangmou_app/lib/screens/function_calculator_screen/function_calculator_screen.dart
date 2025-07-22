import 'package:fangmou_app/common_widgets/simple_content_card.dart';
import 'package:fangmou_app/screens/function_calculator_screen/model/calculate_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'function_calculator_screen_viewmodel.dart';

class FunctionCalculatorScreen extends ConsumerWidget {
  const FunctionCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionCalculatorScreenViewmodelProvider);
    var screenViewmodel = ref.watch(functionCalculatorScreenViewmodelProvider.notifier);
    return SimpleContentCard(content: Column(
      children: [
        TextField(
          readOnly: true,
          controller: screenState.formula,
          textAlign: TextAlign.right, // 文字右对齐
          textDirection: TextDirection.ltr,// 从右向左输入
          style: const TextStyle(color: Colors.black,fontSize: 10),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Color(0x110099ee),
            filled: true,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          readOnly: true,
          style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 30),
          textAlign: TextAlign.right, // 文字右对齐
          textDirection: TextDirection.ltr,// 从右向左输入
          controller: screenState.input,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Color(0x110099ee),
            filled: true,
          ),
        ),
        SizedBox(height: 10),
        buttons(screenViewmodel),
      ],
    ));
  }

  Widget buttons(screenViewmodel) {
    return Column(
      children: [
        for (int py = 6; py >= 0; py--) Row(children: [for (int px = 0; px < 5; px++) button(px, py, screenViewmodel)]),
      ],
    );
  }

  Widget button(px, py, screenViewmodel) {
    final CalculateButton item = CalculateButton.fromPosition(positionX: px, positionY: py);
    return Flexible(
      flex: 5,
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(item.backGroundColor), // 背景颜色
              foregroundColor: WidgetStateProperty.all<Color>(item.fontColor),
            ),
            onPressed: () => screenViewmodel.addChar(item),
            child: Text(style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20), item.icon),
          ),
        ),
      ),
    );
  }
}
