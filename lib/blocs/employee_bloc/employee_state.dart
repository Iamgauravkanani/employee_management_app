import 'package:equatable/equatable.dart';
import '../../data/models/employee.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;

  const EmployeeLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;

  const EmployeeOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class EmployeeError extends EmployeeState {
  final String error;

  const EmployeeError(this.error);

  @override
  List<Object> get props => [error];
}
