import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data_source/local/sql_lite/template_local.dart';
import 'function_template_screen_state.dart';
import 'model/function_template_screen_item.dart';
import 'model/tabs.dart';

part 'function_template_screen_viewmodel.g.dart';

@riverpod
class FunctionTemplateScreenViewmodel extends _$FunctionTemplateScreenViewmodel {
  final templateLocal = GetIt.I.get<TemplateLocal>();

  FunctionTemplateScreenState get currentState => switch (state) {
    AsyncData(value: final value) => value,
    AsyncError() => throw Exception("FunctionTemplateScreenViewmodel 获取异步状态出现错误"),
    _ => FunctionTemplateScreenState.initiate([]),
  };

  @override
  Future<FunctionTemplateScreenState> build() async {
    List<FunctionTemplateScreenItem> items = await getItems();

    for (var item in items) {
      if (item.templateType.title == TemplateTypes.values[0].title) item.visible = true;
    }
    return FunctionTemplateScreenState.initiate(items);
  }

  Future<List<FunctionTemplateScreenItem>> getItems() async {
    List<FunctionTemplateScreenItem> result = [];
    for (TemplateRoutes templateRoute in TemplateRoutes.values) {
      Map<String, Object?> map = await templateLocal.queryAndDataComplete(templateRoute.id);
      int times = map["times"] as int;
      DateTime last = DateTime.parse(map["last"] as String);

      FunctionTemplateScreenItem functionTemplateScreenItem = FunctionTemplateScreenItem(
        times: times,
        last: last,
        route: templateRoute,
        templateType: templateRoute.templateType,
      );
      result.add(functionTemplateScreenItem);
    }
    return result;
  }

  searchTemplate(int currentIndex) {
    for (var item in currentState.items) {
      item.visible =
          item.templateType.title == TemplateTypes.values[currentIndex].title &&
          item.route.name.contains(currentState.search.text);
    }
    state = AsyncData(currentState);
  }

  searchInitiate(int currentIndex) {
    for (var item in currentState.items) {
      item.visible = item.templateType.title == TemplateTypes.values[currentIndex].title;
    }
    currentState.search.text = "";
    state = AsyncData(currentState);
  }
}
