import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'function_spider_screen_viewmodel.dart';

class FunctionSpiderScreen extends ConsumerWidget {
  const FunctionSpiderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionSpiderScreenViewmodelProvider);
    var screenViewmodel = ref.watch(functionSpiderScreenViewmodelProvider.notifier);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              minLines: 16,
              maxLines: 16,
              controller: screenState.inputController,
              decoration: InputDecoration(border: InputBorder.none,),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(onPressed: screenViewmodel.filterText, child: Text("D")),
        SizedBox(height: 10,),
        Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              minLines: 16,
              maxLines: 16,
              controller: screenState.resultController,
              decoration: InputDecoration(border: InputBorder.none,),
            ),
          ),
        ),

        Text("1.去除数字之外的内容（保留汉字形式的数字）"),

        // Flexible(
        //   fit: FlexFit.loose,
        //   child: TextField(
        //     controller: TextEditingController(),
        //     decoration: InputDecoration(
        //       hintText: "选择或输入路径",
        //       border: InputBorder.none, // 隐藏TextField原生边框
        //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
        //     ),
        //   ),
        // ),
        Text("1.去除数字之外的内容（保留汉字形式的数字）"),
        Text("2.通过 JM 号获取漫画标题"),
        Text("3.通过 标题 从 EH 获取对应的下载链接"),
        Text("4.获取仓库指定用户，从某个日期开始到现在发布的所有文章中的网盘地址以及提取码"),
      ],
    );
  }
}
