import './base_screen_template_enum.dart';
import 'base_screen_template_screen.dart';
import '../../model/template_common_state.dart';

mixin SourceStatelessView on TemplateCommonState<BaseScreenTemplateScreen, Params, Results>  {
  String get sourceStatelessView => '''
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../${paramMap[Params.fileName]}_screen_viewmodel.dart';

class ${paramMap[Params.screenName]}Screen extends ConsumerWidget {
  const ${paramMap[Params.screenName]}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(${paramMap[Params.lowerScreenName]}ScreenViewmodelProvider${paramMap[Params.familyProvider]});
    final screenViewmodel = ref.watch(${paramMap[Params.lowerScreenName]}ScreenViewmodelProvider${paramMap[Params.familyProvider]}.notifier);
    return ${paramMap[Params.viewBuildReturnValue]};
  }
}  
''';
}
