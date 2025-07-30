import './base_screen_template_enum.dart';

final String baseScreenTemplateSourceViewmodel = '''
part '${Params.fileName.token}.g.dart';

@riverpod
class ${Params.screenName.token}ViewModel extends _\$${Params.screenName.token}ViewModel{
${Params.currentState.token}
    @override
    Future<${Params.screenName.token}State> build(${Params.familyProvider.token}) ${Params.asyncProviderState.token} {
      return  ${Params.screenName.token}State.initiate(items);
    }
}''';
