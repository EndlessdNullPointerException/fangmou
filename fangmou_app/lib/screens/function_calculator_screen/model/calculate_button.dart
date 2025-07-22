import 'package:flutter/material.dart';

enum CalculateButton {
  space(icon: " ", symbol: " ", positionX: -1, positionY: -1, type: CalculateButtonType.other),

  // region <- Values:数字 ->
  zero(icon: "0", symbol: "0", positionX: 2, positionY: 0, type: CalculateButtonType.number),
  one(icon: "1", symbol: "1", positionX: 1, positionY: 1, type: CalculateButtonType.number),
  two(icon: "2", symbol: "2", positionX: 2, positionY: 1, type: CalculateButtonType.number),
  three(icon: "3", symbol: "3", positionX: 3, positionY: 1, type: CalculateButtonType.number),
  four(icon: "4", symbol: "4", positionX: 1, positionY: 2, type: CalculateButtonType.number),
  five(icon: "5", symbol: "5", positionX: 2, positionY: 2, type: CalculateButtonType.number),
  six(icon: "6", symbol: "6", positionX: 3, positionY: 2, type: CalculateButtonType.number),
  seven(icon: "7", symbol: "7", positionX: 1, positionY: 3, type: CalculateButtonType.number),
  eight(icon: "8", symbol: "8", positionX: 2, positionY: 3, type: CalculateButtonType.number),
  nine(icon: "9", symbol: "9", positionX: 3, positionY: 3, type: CalculateButtonType.number),
  negate(icon: "-/+", symbol: "-", positionX: 1, positionY: 0, type: CalculateButtonType.number),
  decimalPoint(icon: ".", symbol: ".", positionX: 3, positionY: 0, type: CalculateButtonType.number),
  // endregion <- Values:数字 ->

  // region <- Values:基础符号 ->
  add(icon: "+", symbol: "+", positionX: 4, positionY: 1, type: CalculateButtonType.operator),
  subtract(icon: "-", symbol: "-", positionX: 4, positionY: 2, type: CalculateButtonType.operator),
  multiply(icon: "×", symbol: "×", positionX: 4, positionY: 3, type: CalculateButtonType.operator),
  divide(icon: "÷", symbol: "÷", positionX: 4, positionY: 4, type: CalculateButtonType.operator),
  // endregion <- Values:基础符号 ->

  // region <- Values:乘方 ->
  power(icon: "Xⁿ", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  squarePower(icon: "X²", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  cubePower(icon: "X³", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  // endregion <- Values:乘方 ->

  // region <- Values:开方 ->
  root(icon: "ⁿ√", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  squareRoot(icon: "ⁿ√²", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  cubeRoot(icon: "ⁿ√³", symbol: "", positionX: -1, positionY: -1, type: CalculateButtonType.operator),
  // endregion <- Values:开方 ->

  // region <- Values:进制转换 ->
  base2(icon: "2#", symbol: "", positionX: 0, positionY: 0, type: CalculateButtonType.operator),
  base8(icon: "8#", symbol: "", positionX: 0, positionY: 1, type: CalculateButtonType.operator),
  base10(icon: "10#", symbol: "", positionX: 0, positionY: 2, type: CalculateButtonType.operator),
  base16(icon: "16#", symbol: "", positionX: 0, positionY: 3, type: CalculateButtonType.operator),
  base32(icon: "32#", symbol: "", positionX: 0, positionY: 4, type: CalculateButtonType.operator),
  base64(icon: "64#", symbol: "", positionX: 0, positionY: 5, type: CalculateButtonType.operator),

  // endregion <- Values:进制转换 ->

  save(
    icon: "保存",
    symbol: "",
    positionX: 0,
    positionY: 6,
    backGroundColor: Colors.green,
    fontColor: Colors.white,
    type: CalculateButtonType.other,
  ),
  clean(
    icon: "清空",
    symbol: "",
    positionX: 4,
    positionY: 6,
    backGroundColor: Colors.red,
    fontColor: Colors.white,
    type: CalculateButtonType.other,
  ),
  backspace(
    icon: "←",
    symbol: "",
    positionX: 4,
    positionY: 5,
    backGroundColor: Colors.blueAccent,
    fontColor: Colors.white,
    type: CalculateButtonType.other,
  ),
  equalTo(
    icon: "=",
    symbol: "=",
    positionX: 4,
    positionY: 0,
    backGroundColor: Colors.blueAccent,
    fontColor: Colors.white,
    type: CalculateButtonType.operator,
  );

  // 构造方法需要用const修饰
  const CalculateButton({
    required this.icon,
    required this.symbol,
    required this.positionX,
    required this.positionY,
    this.backGroundColor = Colors.white,
    this.fontColor = Colors.black,
    required this.type,
  });

  static List<CalculateButton> get operatorList =>
      CalculateButton.values.where((item) {
        return item.type == CalculateButtonType.operator;
      }).toList();

  // 通过两个属性获取枚举值（静态方法）
  static CalculateButton fromPosition({required int positionX, required int positionY}) {
    for (final item in CalculateButton.values) {
      if (item.positionX == positionX && item.positionY == positionY) {
        return item;
      }
    }
    return CalculateButton.space;
  }

  // 属性是不可变的，需要使用final修饰
  final String icon;
  final String symbol;
  final int positionX;
  final int positionY;
  final Color fontColor;
  final Color backGroundColor;
  final CalculateButtonType type;
}

enum CalculateButtonType { number(), operator(), other() }
