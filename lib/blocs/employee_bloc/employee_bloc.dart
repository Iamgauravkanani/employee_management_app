import 'dart:async';
import 'package:bloc/bloc.dart' show Bloc, Emitter;
import '../../data/local/employee_dao.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeDao _employeeDao;

  EmployeeBloc(this._employeeDao) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final employees = await _employeeDao.getAllEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to load employees'));
    }
  }

  Future<void> _onAddEmployee(AddEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await _employeeDao.addEmployee(event.employee);
      final employees = await _employeeDao.getAllEmployees();
      emit(EmployeeLoaded(employees));
      emit(EmployeeOperationSuccess('Employee added successfully'));
    } catch (e) {
      emit(EmployeeError('Failed to add employee'));
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await _employeeDao.updateEmployee(event.employee);
      final employees = await _employeeDao.getAllEmployees();
      emit(EmployeeLoaded(employees));
      emit(EmployeeOperationSuccess('Employee updated successfully'));
    } catch (e) {
      emit(EmployeeError('Failed to update employee'));
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await _employeeDao.deleteEmployee(event.id);
      final employees = await _employeeDao.getAllEmployees();
      emit(EmployeeLoaded(employees));
      emit(EmployeeOperationSuccess('Employee deleted successfully'));
    } catch (e) {
      emit(EmployeeError('Failed to delete employee'));
    }
  }
}
