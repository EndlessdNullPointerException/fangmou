import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';

import '../../../utils/constants/constants.dart';

class TemplateSource {
  final String source;
  final TemplatesFormat name;
  final List<String> sortedExtractedTokens;

  static final regex = RegExp(r'\{\{.*?\}\}');

  TemplateSource({required this.name, required this.source})
    : sortedExtractedTokens = List<String>.from(
        Set.from(regex.allMatches(source).map((match) => match.group(0)!)).toList(),
      )..sort();

  String check(String placeHolder) {
    if (!sortedExtractedTokens.contains(placeHolder)) {
      logger.e('┏━━━━━━━━━━━━━━━$name 不包含这个token━━━━━━━━━━━━━━━━━┓');
      logger.e(placeHolder);
      logger.e('┗━━━━━━━━━━━━━━━$name 不包含这个token━━━━━━━━━━━━━━━━━┛');
      throw "$name 不包含这个token";
    }
    return placeHolder;
  }

  String replaceAll(Map<String, dynamic> map) {
    //  比较传入的 token 和模板中的token是否完全相同

    compareTemplateVariablesNoDeps(map.keys.toList());

    String result = source;
    for (String key in map.keys) {
      logger.d(key);
      logger.d(map[key]);
      result = result.replaceAll(check(key), map[key]);
    }

    final resultExtractedList = Set.from(regex.allMatches(result).map((match) => match.group(0)!)).toList();

    if (resultExtractedList.isNotEmpty) {
      logger.e('┏━━━━━━━━━━━━━━━$name 未替换token列表━━━━━━━━━━━━━━━━━┓');
      for (String token in resultExtractedList) {
        logger.d(token);
      }
      logger.e('┗━━━━━━━━━━━━━━━$name 未替换token列表━━━━━━━━━━━━━━━━━┛');
      throw "有未替换的内容，请检查";
    }

    return result;
  }

  static String placeHolderConstructor(String s) {
    return "{{$s}}";
  }

  void compareTemplateVariablesNoDeps(List<String> paramTokens) {
    // 创建可修改的副本以进行排序
    final sortedParamTokens = List<String>.from(paramTokens)..sort();

    // 如果长度不同，它们肯定不相等
    if (sortedExtractedTokens.length != sortedParamTokens.length) {
      printMessage(sortedParamTokens);
      throw "token 列表的长度不同";
    }

    // 逐个元素进行比较
    for (int i = 0; i < sortedExtractedTokens.length; i++) {
      if (sortedExtractedTokens[i] != sortedParamTokens[i]) {
        printMessage(sortedParamTokens);
        throw "token 列表不全等";
      }
    }

    // 如果循环完成，说明所有元素都相同
  }

  printMessage(sortedParamTokens) {
    logger.d('┏━━━━━━━━━━━━━━━━$name 模板中的token和传入token无法完全对应━━━━━━━━━━━━━━━━┓');
    logger.d('================$name sortedExtractedTokens================');
    for (String s in sortedExtractedTokens) {
      logger.d(s);
    }
    logger.d('================$name sortedParamTokens================');
    for (String s in sortedParamTokens) {
      logger.d(s);
    }
    logger.d('┗━━━━━━━━━━━━━━━━$name 模板中的token和传入token无法完全对应━━━━━━━━━━━━━━━━┛');

  }
}
