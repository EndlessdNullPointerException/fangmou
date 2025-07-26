
/// 将大驼峰 (UpperCamelCase) 格式的字符串转换为下划线蛇形 (lower_case_with_underscores，又称 SnakeCase) 格式。
String upperCamelToSnakeCase(String text) {
  if (text.isEmpty) {
    return '';
  }

  // 正则表达式：匹配所有大写字母
  final RegExp exp = RegExp(r'[A-Z]');

  // 使用 replaceAllMapped 处理所有大写字母
  return text.replaceAllMapped(exp, (Match m) {
    final String match = m.group(0)!;
    // 如果不是字符串的开头，就在前面加上下划线
    return (m.start == 0) ? match.toLowerCase() : '_${match.toLowerCase()}';
  });
}

/// 将小驼峰 (lowerCamelCase) 格式的字符串转换为下划线蛇形 (lower_case_with_underscores，又称 SnakeCase) 格式。
String lowerCamelToSnakeCase(String text) {
  if (text.isEmpty) {
    return '';
  }

  // 正则表达式：匹配前面是小写字母的大写字母
  final RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');

  // 使用 replaceAllMapped 在匹配项前添加下划线，然后将整个字符串转为小写
  return text.replaceAllMapped(exp, (Match m) => '_${m.group(0)}').toLowerCase();
}

/// 将列表中的元素向前或向后移动一位，并处理边界情况（循环移动）。
///
/// [list] - 要操作的列表。
/// [oldIndex] - 要移动的元素的当前索引。
/// [moveUp] - 移动方向。`true` 表示向前（向上）移动，`false` 表示向后（向下）移动。
/// [modifyInPlace] - 控制开关。如果为 `true`，将直接修改原始列表；
///                   如果为 `false`（默认），则返回一个包含修改结果的新列表，原始列表不变。
///
/// 返回值：总是返回包含最终结果的列表。
/// 如果 `modifyInPlace` 为 true，返回的是修改后的原始列表自身的引用；
/// 如果为 false，返回的是一个新创建的列表。
List<T> moveElement<T>(
    List<T> list,
    int oldIndex, {
      required bool moveUp,
      bool modifyInPlace = false, // 新增的控制参数，默认为 false
    }) {
  // 1. 输入验证
  if (list.length < 2 || oldIndex < 0 || oldIndex >= list.length) {
    // 根据模式，返回原始列表或其副本
    return modifyInPlace ? list : List<T>.from(list);
  }

  // 2. 根据 modifyInPlace 参数决定操作目标
  // 如果为 true，直接在原始 list 上操作
  // 如果为 false，在 list 的一个副本上操作
  final List<T> targetList = modifyInPlace ? list : List<T>.from(list);

  // 3. 执行移动操作（此部分逻辑与之前相同）
  final int originalLength = targetList.length;
  final T element = targetList.removeAt(oldIndex);

  int newIndex;
  if (moveUp) { // 向前（上）移动
    newIndex = (oldIndex == 0) ? originalLength - 1 : oldIndex - 1;
  } else { // 向后（下）移动
    newIndex = (oldIndex == originalLength - 1) ? 0 : oldIndex + 1;
  }

  targetList.insert(newIndex, element);

  // 4. 返回最终的列表
  return targetList;
}