import 'package:hive/hive.dart';
part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String position;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
  final DateTime? endDate;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.startDate,
    this.endDate,
  });

  Employee copyWith({
    String? id,
    String? name,
    String? position,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
