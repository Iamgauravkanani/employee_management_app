import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String formatDate() {
    return DateFormat('MMM dd, yyyy').format(this);
  }
}

extension StringExtension on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}
