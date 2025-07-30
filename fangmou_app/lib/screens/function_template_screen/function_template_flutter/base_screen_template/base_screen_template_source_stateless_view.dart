import './base_screen_template_enum.dart';

final String baseScreenTemplateSourceStatelessView = '''
class ${Params.screenName.token} extends ConsumerWidget {
  const ${Params.screenName.token}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(functionTemplateScreenViewmodelProvider${Params.familyProvider.token});
    final screenViewmodel = ref.watch(functionTemplateScreenViewmodelProvider${Params.familyProvider.token}.notifier);
    return ${Params.buildReturn.token};
  }
}  
''';
String x = '''screenState.when(
      data: (screenState) => layout(screenState, screenViewmodel),
      error: whenError,
      loading: whenLoading,
    )''';
