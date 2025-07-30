import './base_screen_template_enum.dart';

final String baseScreenTemplateSourceStatefulView = '''
class ${Params.screenName.token} extends ConsumerStatefulWidget {
  const ${Params.screenName.token}({super.key});

  @override
  ConsumerState<${Params.screenName.token}> createState() => _${Params.screenName.token}State();
}

class _${Params.screenName.token} extends ConsumerState<${Params.screenName.token}> {


  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(functionTemplateScreenViewmodelProvider${Params.familyProvider.token});
    final screenViewmodel = ref.watch(functionTemplateScreenViewmodelProvider${Params.familyProvider.token}.notifier);
${Params.screenName.token}
  }
}
''';
