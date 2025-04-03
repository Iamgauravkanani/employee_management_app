import 'package:hive/hive.dart';
import '../models/employee.dart';

class EmployeeDao {
  static const _boxName = 'employees';

  Future<Box<Employee>> get _box async {
    return await Hive.openBox<Employee>(_boxName);
  }

  Future<void> addEmployee(Employee employee) async {
    final box = await _box;
    await box.put(employee.id, employee);
  }

  Future<void> updateEmployee(Employee employee) async {
    final box = await _box;
    await box.put(employee.id, employee);
  }

  Future<void> deleteEmployee(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<List<Employee>> getAllEmployees() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<Employee?> getEmployee(String id) async {
    final box = await _box;
    return box.get(id);
  }
}
