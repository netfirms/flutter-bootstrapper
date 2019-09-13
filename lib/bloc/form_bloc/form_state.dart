import 'package:bloc_updated_tutorial/model/form_demo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FormDemoState extends Equatable {
  FormDemoState([List props = const []]) : super(props);
}

class InitialFormState extends FormDemoState {}

class FormDemoLoading extends FormDemoState {}

class FormDemoLoaded extends FormDemoState {
  final FormDemo formDemo;

  FormDemoLoaded(this.formDemo) : super([formDemo]);
}
