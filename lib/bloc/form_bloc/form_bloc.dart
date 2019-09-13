import 'dart:async';
import 'package:bloc/bloc.dart';

import '../bloc.dart';

class FormDemoBloc extends Bloc<FormDemoEvent, FormDemoState> {
  @override
  FormDemoState get initialState => InitialFormState();

  @override
  Stream<FormDemoState> mapEventToState(FormDemoEvent event) async* {
    if (event is UpdateForm) {
      yield FormDemoLoading();
      print("FormLoad:");
      print(event);
      yield FormDemoLoaded(event.formDemo);
      print("FormLoaded:");
    }
  }
}
