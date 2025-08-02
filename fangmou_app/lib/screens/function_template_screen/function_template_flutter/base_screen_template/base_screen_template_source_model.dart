import '../../model/template_common_state.dart';
import './base_screen_template_enum.dart';
import 'base_screen_template_screen.dart';
mixin SourceModel on TemplateCommonState<BaseScreenTemplateScreen, Params, Results> {
  String get sourceModel => '''
class ${paramMap[Params.screenName]}ScreenState{
  ${paramMap[Params.screenName]}ScreenState();
  ${paramMap[Params.screenName]}ScreenState.initiate();
  ${paramMap[Params.screenName]}ScreenState copyWith(){
      return ${paramMap[Params.screenName]}ScreenState();
  }
}''';
}
