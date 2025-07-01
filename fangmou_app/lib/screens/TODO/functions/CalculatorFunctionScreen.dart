import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorFunctionScreen extends ConsumerWidget {
  const CalculatorFunctionScreen({super.key});

  // TODO
  //  计算器页
  //  1.输入框，输入的字符串会被识别为算式，实时显示计算结果
  //  2.计算结果和算式可以存入槽位，用于其他的计算结果，槽位中的数据在程序打开期间会被一直保存，程序关闭后清除
  //  3.可以将槽位中的结果持久化到便签中
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 10000,
      child: Center(
        child: Column(
          children: [
            Text("计算器页"),
            Text("1.输入框，输入的字符串会被识别为算式，实时显示计算结果"),
            Text("2.计算结果和算式可以存入槽位，用于其他的计算结果，槽位中的数据在程序打开期间会被一直保存，程序关闭后清除"),
            Text("3.可以将槽位中的结果持久化到便签中"),
          ],
        ),
      ),
    );
  }
}
