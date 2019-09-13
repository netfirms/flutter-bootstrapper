import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class FormDemo extends Equatable {
  final String name;
  final String lastName;

  FormDemo({
    @required this.name,
    @required this.lastName,
  }) : super([name, lastName]);
}
