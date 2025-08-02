import 'package:riverpod_annotation/riverpod_annotation.dart';

import './function_value_screen_state.dart';
part 'function_value_screen_viewmodel.g.dart';

@riverpod
class FunctionValueScreenViewmodel extends _$FunctionValueScreenViewmodel{

    @override
    FunctionValueScreenState build()  {
      return  FunctionValueScreenState.initiate();
    }
}