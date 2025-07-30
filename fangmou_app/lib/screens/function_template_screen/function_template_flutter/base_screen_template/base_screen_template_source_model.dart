import './base_screen_template_enum.dart';

final String baseScreenTemplateSourceModel = '''
class ${Params.screenName.token}State{
  ${Params.screenName.token}State();
  ${Params.screenName.token}State.initiate();
  ${Params.screenName.token}State copyWith(){
      return ${Params.screenName.token}State();
  }
}''';
