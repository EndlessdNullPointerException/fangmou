class Template {
  final List<String> placeholders;
  final String template;

  /// skipExample属性只能用 TemplateGenerateTemplate
  /// 这个属性的作用是跳过 [模板生成模板] 中用作示例的 {{example}}
  Template({required this.placeholders, required this.template,bool skipExample = false})
    : assert(Template.compareTemplateVariablesNoDeps(template, placeholders,skipExample), "请重新确认模板和占位符");

  String check(String placeHolder) {
    assert(placeholders.contains(placeHolder));
    return placeHolder;
  }

  String replaceAll(Map<String, dynamic> map) {
    String result = template;
    for (String key in map.keys) {
      result = result.replaceAll(check(key), map[key]);
    }
    return result;
  }

  /// 从输入字符串中提取所有被 '{{' 和 '}}' 包裹的变量，
  /// 并与预期列表进行比较
  static bool compareTemplateVariablesNoDeps(String inputString, List<String> expectedList,skipExample) {
    final regex = RegExp(r'\{\{.*?\}\}');
    final extractedList = Set.from(regex.allMatches(inputString).map((match) => match.group(0)!)).toList();

    // 跳过 [模板生成模板] 中用作示例的 {{example}}
    if(skipExample) extractedList.remove("{{example}}");

    // 如果长度不同，它们肯定不相等
    if (extractedList.length != expectedList.length) {
      return false;
    }

    // 创建可修改的副本以进行排序
    final sortedExtracted = List<String>.from(extractedList)..sort();
    final sortedExpected = List<String>.from(expectedList)..sort();

    // 逐个元素进行比较
    for (int i = 0; i < sortedExtracted.length; i++) {
      if (sortedExtracted[i] != sortedExpected[i]) {
        return false;
      }
    }

    // 如果循环完成，说明所有元素都相同
    return true;
  }
}
