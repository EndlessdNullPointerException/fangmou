
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/constants/constants.dart';
import 'function_spider_screen_state.dart';

part 'function_spider_screen_viewmodel.g.dart';

@riverpod
class FunctionSpiderScreenViewmodel extends _$FunctionSpiderScreenViewmodel {
  @override
  FunctionSpiderScreenState build() {
    return FunctionSpiderScreenState.initial();
  }

  void filterText() {
    var input = state.inputController.text;
    // 定义允许的字符集合
    final allowedChars = {
      '.', // 保留标点符号
      '\n', '\r', '\\', // 保留布局符号
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', // 保留阿拉伯数字
      //'零','一','二','三','四','五','六','七','八','九','十','百','千','万','亿', // 保留简体数字
      //'壹','贰','叁','肆','伍','陆','柒','捌','玖','拾','佰','仟' // 保留繁体数字
    };
    // 使用StringBuffer来构建结果字符串
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      if (allowedChars.contains(char)) {
        sb.write(char);
      }
    }

    final orderString = sb.toString().split("\n");

    // region <- Logic: 重排序且去重->
    final orderStringList = [];
    for (String s in orderString) {
      String sNumber = s.split(".")[1];
      logger.d(sNumber);
      int number = int.parse(sNumber);
      if (!orderStringList.contains(number)) {
        orderStringList.add(number);
      }
    }
    orderStringList.sort((a, b) => a.compareTo(b));
    // endregion <- Logic: ->

    StringBuffer resultSB = StringBuffer();

    int no = 0;
    for (int i in orderStringList) {
      no++;
      String row = "$no.$i\n";
      resultSB.write(row);
    }

    state.resultController.text = resultSB.toString();
  }
}
