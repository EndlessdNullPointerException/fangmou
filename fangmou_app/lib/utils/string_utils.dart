String camelToSnake(String input) {
  if (input.isEmpty) {
    return '';
  }

  // 正则表达式，用于在需要的地方插入下划线
  // 1. 在小写字母/数字和-大写字母之间
  final RegExp pattern1 = RegExp(r'(?<=[a-z0-9])[A-Z]');
  // 2. 在大写字母和-大写字母+小写字母之间（处理首字母缩略词，如HTTP-R）
  final RegExp pattern2 = RegExp(r'(?<=[A-Z])[A-Z](?=[a-z])');

  // 先处理类似 HTTPRequest 的情况，再处理普通情况
  String result = input.replaceAllMapped(pattern2, (match) => '_${match.group(0)}');
  result = result.replaceAllMapped(pattern1, (match) => '_${match.group(0)}');

  return result.toLowerCase();
}

/// 将下划线命名的字符串转换为驼峰命名。
///
/// [capitalizeFirst] 参数控制是否生成大驼峰（PascalCase）。
/// - `false` (默认): 生成小驼峰 (camelCase)。
/// - `true`: 生成大驼峰 (PascalCase)。
///
/// 示例:
/// 'snake_case' -> 'snakeCase'
/// 'snake_case', capitalizeFirst: true -> 'SnakeCase'
String snakeToCamel(String input, {bool capitalizeFirst = false}) {
  if (input.isEmpty) {
    return '';
  }

  final List<String> parts = input.split('_');

  if (parts.length == 1) {
    // 如果没有下划线，则根据参数决定是否大写首字母
    return capitalizeFirst ? parts[0][0].toUpperCase() + parts[0].substring(1) : parts[0];
  }

  // 第一个单词根据 capitalizeFirst 参数处理
  final String firstPart = capitalizeFirst ? parts[0][0].toUpperCase() + parts[0].substring(1) : parts[0];

  // 后续单词全部首字母大写
  final List<String> remainingParts =
      parts.sublist(1).map((part) {
        if (part.isEmpty) return ''; // 处理连续下划线 "a__b"
        return part[0].toUpperCase() + part.substring(1);
      }).toList();

  return [firstPart, ...remainingParts].join('');
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
  if (moveUp) {
    // 向前（上）移动
    newIndex = (oldIndex == 0) ? originalLength - 1 : oldIndex - 1;
  } else {
    // 向后（下）移动
    newIndex = (oldIndex == originalLength - 1) ? 0 : oldIndex + 1;
  }

  targetList.insert(newIndex, element);

  // 4. 返回最终的列表
  return targetList;
}

String changeFirstLetterCase(String inputOrigin, {required bool toUpper}) {
  String input = inputOrigin.substring(0);

  // 1. 处理空字符串的边缘情况
  if (input.isEmpty) {
    return '';
  }

  // 2. 使用正则表达式校验字符串是否只包含英文字母
  final RegExp alphaRegex = RegExp(r'^[a-zA-Z]+$');
  if (!alphaRegex.hasMatch(input)) {
    // 3. 如果校验失败，则抛出异常
    throw ArgumentError('输入字符串必须只包含英文字母 (a-z, A-Z)，但收到了: "$input"');
  }

  // 4. 执行大小写转换
  final firstLetter = toUpper ? input[0].toUpperCase() : input[0].toLowerCase();

  final restOfTheString = input.substring(1);

  return '$firstLetter$restOfTheString';
}
