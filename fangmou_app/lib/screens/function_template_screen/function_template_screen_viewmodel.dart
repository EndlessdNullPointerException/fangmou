import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/constants/constants.dart';
import 'function_template_screen_state.dart';
import 'model/function_template_screen_item.dart';
import 'model/tabs.dart';

part 'function_template_screen_viewmodel.g.dart';

@riverpod
class FunctionTemplateScreenViewmodel extends _$FunctionTemplateScreenViewmodel {
  FunctionTemplateScreenState get currentState => switch (state) {
    AsyncData(value: final value) => value,
    AsyncError() => throw Exception("FunctionTemplateScreenViewmodel 获取异步状态出现错误"),
    _ => FunctionTemplateScreenState.initiate([]),
  };

  @override
  Future<FunctionTemplateScreenState> build() async {
    List<FunctionTemplateScreenItem> items = await getItems();

    for (var item in items) {
      logger.d(item.tab);

      if (item.tab == Tabs.values[0].title) item.visible = true;
    }
    return FunctionTemplateScreenState.initiate(items);
  }

  List<FunctionTemplateScreenItem> getItems() {
    return allTemplates;
  }

  searchTemplate(int currentIndex) {
    for (var item in currentState.items) {
      item.visible = item.tab == Tabs.values[currentIndex].title && item.route.name!.contains(currentState.search.text);
    }
    state = AsyncData(currentState);
  }

  searchInitiate(int currentIndex) {
    for (var item in currentState.items) {
      item.visible = item.tab == Tabs.values[currentIndex].title;
    }
    currentState.search.text = "";
    state = AsyncData(currentState);
  }
}
