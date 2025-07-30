import 'package:fangmou_app/screens/function_template_screen/model/param_type.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_source.dart';
import 'package:highlight/highlight.dart';

abstract class TemplatesFormat {
  TemplateSource get source;
}

///
/// 参数分为四类
/// 1.输入后，直接用于模板替换的参数，大多数需要输入的参数都属于这种，ParamType 为 input
/// 2.通过条件判断，选择特定的代码块进行替换的的参数，比如 SQL 的数据类型，ParamType 为 condition
/// 3.对类型一进行修改（首字母小写，格式转换等）得到的参数,比如大小写类名等，ParamType 为 transfer
/// 4.需要输入，但是不会直接用于模板替换的参数，例如部分模板的文件名，此类参数的 templates 属性是空的，ParamType 和第一类同样为 input
mixin ParamsFormat {
  ParamType get type;
  String get token => TemplateSource.placeHolderConstructor(toString());
}

abstract class ResultsFormat {
  String get name;
  Mode get language;
}
