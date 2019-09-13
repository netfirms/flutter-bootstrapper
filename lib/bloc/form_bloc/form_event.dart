import 'package:bloc_updated_tutorial/model/form_demo.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class FormDemoEvent extends Equatable {
  FormDemoEvent([List props = const []]) : super(props);
}

class UpdateForm extends FormDemoEvent {
  final FormDemo formDemo;

  UpdateForm(this.formDemo) : super([formDemo]);

  @override
  String toString() => 'UpdateTodo { updatedForm: $formDemo }';
}
