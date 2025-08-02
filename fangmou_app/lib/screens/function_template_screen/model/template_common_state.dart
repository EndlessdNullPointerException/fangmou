import 'package:fangmou_app/screens/function_template_screen/model/param_map.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/copyable_field.dart';
import '../widget/template_base_layout.dart';

abstract class TemplateCommonState<
  T extends TemplateCommonScreen,
  Params extends ParamsFormat,
  Results extends ResultsFormat
>
    extends ConsumerState<T> {
  late final ParamMap paramMap;
  late final Map<Results, CopyableFieldParams> resultMap;

  @override
  void initState() {
    super.initState();

    paramMapInitiate();
    resultMapInitiate();
  }

  void paramMapInitiate();

  void resultMapInitiate();

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(
      id: widget.id,
      paramField: paramField,
      resultField: resultField(),
      resetParams: resetParams,
      generate: generate,
      clearAll: clearAll,
      allExpandOrCollapseCallback: allExpandOrCollapse,
    );
  }

  /// 必须重写的方法
  Widget paramField(bool fileGenerate);
  Future<void> generate(bool fileGenerate, String directory);

  // region <- Functions:可以不重写的方法 ->

  allExpandOrCollapse(value) {
    setState(() {
      for (var item in resultMap.values) {
        item.expand = value;
      }
    });
  }

  Widget resultField() {
    return Column(children: resultMap.values.map((item) => CopyableField(copyableFieldParams: item)).toList());
  }

  void resetParams(formKey) {
    formKey.currentState!.reset();
    paramMap.reset();
  }

  void clearAll(formKey) {
    resetParams(formKey);
    for (var item in resultMap.values) {
      item.controller.text = "";
    }
  }

  // endregion <- Functions:可以不重写的方法 ->
}
