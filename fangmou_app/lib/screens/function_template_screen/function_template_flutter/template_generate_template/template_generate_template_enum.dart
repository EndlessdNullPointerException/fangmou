import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';

import '../../model/param_type.dart';
import '../../model/template_common_enum.dart';

enum Params with ParamsFormat {
  templateName(type: ParamType.input),
  lowerTemplateName(type: ParamType.transfer),
  language(type: ParamType.condition),
  fileName(type: ParamType.input);

  const Params({required this.type});
  @override
  final ParamType type;
}

enum Results implements ResultsFormat {
  screenPart(name: "页面部分"),
  enumPart(name: "枚举部分"),
  sourcePart(name: "源部分");

  const Results({required this.name});

  @override
  final String name;

  @override
  Mode get language {
    switch (this) {
      case Results.screenPart:
        return dart;
      case Results.enumPart:
        return dart;
      case Results.sourcePart:
        return dart;
    }
  }
}
