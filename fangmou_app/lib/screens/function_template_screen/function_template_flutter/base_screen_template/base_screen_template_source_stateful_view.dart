import 'base_screen_template_screen.dart';
import '../../model/template_common_state.dart';

import './base_screen_template_enum.dart';

mixin SourceStatefulView on TemplateCommonState<BaseScreenTemplateScreen, Params, Results>   {
  String get sourceStatefulView => '''
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './${paramMap[Params.fileName]}_screen_viewmodel.dart';

class ${paramMap[Params.screenName]}Screen extends ConsumerStatefulWidget {
  const ${paramMap[Params.screenName]}Screen({super.key});

  @override
  ConsumerState<${paramMap[Params.screenName]}Screen> createState() => _${paramMap[Params.screenName]}ScreenState();
}

class _${paramMap[Params.screenName]}ScreenState extends ConsumerState<${paramMap[Params.screenName]}Screen> {


  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(${paramMap[Params.lowerScreenName]}ScreenViewmodelProvider${paramMap[Params.familyProvider]});
    final screenViewmodel = ref.watch(${paramMap[Params.lowerScreenName]}ScreenViewmodelProvider${paramMap[Params.familyProvider]}.notifier);
    return ${paramMap[Params.viewBuildReturnValue]};
  }
}
''';
}
