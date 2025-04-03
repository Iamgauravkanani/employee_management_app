import '../../data/local/employee_dao.dart';
import '../../data/models/employee.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getAllEmployees();
  Future<void> addEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String id);
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDao _employeeDao;

  EmployeeRepositoryImpl(this._employeeDao);

  @override
  Future<List<Employee>> getAllEmployees() => _employeeDao.getAllEmployees();

  @override
  Future<void> addEmployee(Employee employee) => _employeeDao.addEmployee(employee);

  @override
  Future<void> updateEmployee(Employee employee) => _employeeDao.updateEmployee(employee);

  @override
  Future<void> deleteEmployee(String id) => _employeeDao.deleteEmployee(id);
}
