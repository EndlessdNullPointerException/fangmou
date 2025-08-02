import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/constants/constants.dart';

/// 一个动态的状态追踪器。
///
/// 它可以接收任意结构的 Map 作为初始状态，
/// 并提供状态修改、重置和变更检查的功能。
class ParamMap {
  // region <- Values: 私有变量，用于存储各个字段的值->
  final Map<ParamsFormat, dynamic> _currentState;

  // endregion <- Values: 私有变量，用于存储各个字段->

  // region <- Values: 私有变量，用于存储各个字段的【初始值】的只读备份->
  final Map<ParamsFormat, dynamic> _initialState;
  // endregion <- Values: 私有变量，用于存储各个字段的【初始值】的只读备份->

  /// 构造函数，接收一个 Map 作为初始状态。
  ParamMap(Map<ParamsFormat, dynamic> initialValues)
    : _initialState = Map.unmodifiable(initialValues), // 创建一个不可修改的备份
      _currentState = Map.from(initialValues); // 创建一个可修改的当前状态副本

  /// 提供一个只读的 key 列表
  Iterable<ParamsFormat> get keys => _initialState.keys;

  /// 检查当前状态是否与初始状态不同
  bool get isModified {
    // 遍历所有的 key，只要有一个值不同，就认为已修改
    for (final key in keys) {
      if (_currentState[key] != _initialState[key]) {
        return true;
      }
    }
    return false;
  }

  /// 将所有字段的值重置回它们的初始状态
  void reset() {
    for (final key in keys) {
      _currentState[key] = _initialState[key];
    }
    logger.d('--- 状态已重置 ---');
  }

  // 获取值
  dynamic operator [](ParamsFormat key) {
    // 检查 key 是否存在
    if (!keys.contains(key)) {
      throw ArgumentError('Key "$key" 不存在。');
    }
    final value = _currentState[key];
    if (value is TextEditingController) {
      return value.text;
    } else if (value is Function) {
      return value();
    }
    return value;
  }

  TextEditingController getController(ParamsFormat key) {
    // 检查 key 是否存在
    if (!keys.contains(key)) {
      throw ArgumentError('Key "$key" 不存在。');
    }
    final value = _currentState[key];
    if (value is TextEditingController) {
      return value;
    }
    throw '类型错误: 当前 Param($key) 对应的值的类型不是 TextEditingController';
  }

  /// 设置一个字段的值
  void operator []=(ParamsFormat key, dynamic value) {
    // 检查 key 是否存在，防止添加新的 key
    if (!keys.contains(key)) {
      throw ArgumentError('无法设置值：Key "$key" 在初始状态中不存在，不允许添加新 Key。');
    }
    final initialValue = _initialState[key];
    logger.d('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
    logger.d(key);
    logger.d(value);
    logger.d(initialValue.runtimeType);
    logger.d('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');

    // 修改 TextEditingController 类型的 value
    // 实际上controller不允许被修改，只能修改其对应的 controller.text 的值
    if (initialValue is TextEditingController) {
      if (value is String) {
        initialValue.text = value;
        return;
      } else {
        throw "$key 的值是 TextEditController 类型，不能赋值为 ${value.runtimeType} 类型";
      }
    }

    // 修改 Function 类型的 value
    // Function 类型不允许修改
    if (initialValue is Function) {
      throw "$key 的值是 Function 类型，不允许修改";
    }

    // 修改其他类型的 value
    // 修改前后，value 的数据类型必须一致
    if (initialValue != null && value.runtimeType != initialValue.runtimeType) {
      throw '错误: 不能将 $key 的值类型从 ${initialValue.runtimeType} 改变为 ${value.runtimeType}';
    }
    _currentState[key] = value;
  }
}
