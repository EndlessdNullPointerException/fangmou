import './base_screen_template_enum.dart';
import 'base_screen_template_screen.dart';
import '../../model/template_common_state.dart';

mixin SourceViewmodel on TemplateCommonState<BaseScreenTemplateScreen, Params, Results> {
  String get sourceViewmodel => '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './${paramMap[Params.fileName]}_screen_state.dart';
part '${paramMap[Params.fileName]}_screen_viewmodel.g.dart';

@riverpod
class ${paramMap[Params.screenName]}ScreenViewmodel extends _\$${paramMap[Params.screenName]}ScreenViewmodel{
${paramMap[Params.viewModelCurrentState]}
    @override
    ${paramMap[Params.viewmodelBuildReturnType]} build(${paramMap[Params.familyProvider]}) ${paramMap[Params.asyncProviderState]} {
      return  ${paramMap[Params.screenName]}ScreenState.initiate();
    }
}''';
}
