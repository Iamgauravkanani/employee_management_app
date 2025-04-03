import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/extensions.dart';
import '../utils/theme.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String title;

  const CustomDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickDateButtons(),
          _buildCalendar(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildQuickDateButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              _QuickDateButton(
                label: 'Today',
                onPressed: () => _updateSelectedDate(DateTime.now()),
                isSelected: _isSameDay(_selectedDate, DateTime.now()),
              ),
              SizedBox(width: 8.w),
              _QuickDateButton(
                label: 'Next Monday',
                onPressed: () => _updateSelectedDate(_getNextWeekday(DateTime.monday)),
                isSelected: _isSameDay(_selectedDate, _getNextWeekday(DateTime.monday)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _QuickDateButton(
                label: 'Next Tuesday',
                onPressed: () => _updateSelectedDate(_getNextWeekday(DateTime.tuesday)),
                isSelected: _isSameDay(_selectedDate, _getNextWeekday(DateTime.tuesday)),
              ),
              SizedBox(width: 8.w),
              _QuickDateButton(
                label: 'After week',
                onPressed: () => _updateSelectedDate(DateTime.now().add(Duration(days: 7))),
                isSelected: _isSameDay(_selectedDate, DateTime.now().add(Duration(days: 7))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryColor,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        currentDate: DateTime.now(),
        onDateChanged: _updateSelectedDate,
        selectableDayPredicate: (date) => true,
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedDate.formatDate(),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: () {
                  widget.onDateSelected(_selectedDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateSelectedDate(DateTime date) {
    setState(() => _selectedDate = date);
  }

  DateTime _getNextWeekday(int targetDay) {
    DateTime date = DateTime.now();
    while (date.weekday != targetDay) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const _QuickDateButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? AppTheme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 