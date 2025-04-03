import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../blocs/employee_bloc/employee_bloc.dart';
import '../blocs/employee_bloc/employee_event.dart';
import '../data/models/employee.dart';
import '../utils/extensions.dart';
import '../utils/theme.dart';
import '../widgets/action_buttons.dart';
import '../utils/responsive_layout.dart';
import '../widgets/responsive_wrapper.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({this.employee, super.key});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<String> _positions = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _startDate = widget.employee?.startDate;
    _endDate = widget.employee?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _showPositionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _positions.map((String position) {
              return InkWell(
                onTap: () {
                  setState(() => _positionController.text = position);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      position,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    _selectedDay = isStartDate ? _startDate : _endDate;
    _focusedDay = _selectedDay ?? DateTime.now();

    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.isMobile(context) ? 16.w : ResponsiveLayout.getDialogWidth(context) / 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveLayout.getDialogWidth(context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isStartDate) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            _buildQuickDateButton(
                              'Today',
                              DateTime.now(),
                              isSelected: isSameDay(_selectedDay, DateTime.now()),
                              onTap: () => setDialogState(() {
                                _selectedDay = DateTime.now();
                                _focusedDay = DateTime.now();
                              }),
                            ),
                            SizedBox(width: 8.w),
                            _buildQuickDateButton(
                              'Next Monday',
                              _getNextWeekday(DateTime.monday),
                              isSelected: isSameDay(_selectedDay, _getNextWeekday(DateTime.monday)),
                              onTap: () => setDialogState(() {
                                _selectedDay = _getNextWeekday(DateTime.monday);
                                _focusedDay = _getNextWeekday(DateTime.monday);
                              }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            _buildQuickDateButton(
                              'Next Tuesday',
                              _getNextWeekday(DateTime.tuesday),
                              isSelected: isSameDay(_selectedDay, _getNextWeekday(DateTime.tuesday)),
                              onTap: () => setDialogState(() {
                                _selectedDay = _getNextWeekday(DateTime.tuesday);
                                _focusedDay = _getNextWeekday(DateTime.tuesday);
                              }),
                            ),
                            SizedBox(width: 8.w),
                            _buildQuickDateButton(
                              'After 1 week',
                              DateTime.now().add(const Duration(days: 7)),
                              isSelected: isSameDay(
                                _selectedDay,
                                DateTime.now().add(const Duration(days: 7)),
                              ),
                              onTap: () => setDialogState(() {
                                _selectedDay = DateTime.now().add(const Duration(days: 7));
                                _focusedDay = DateTime.now().add(const Duration(days: 7));
                              }),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            _buildQuickDateButton(
                              'Today',
                              DateTime.now(),
                              isSelected: isSameDay(_selectedDay, DateTime.now()),
                              onTap: () => setDialogState(() {
                                _selectedDay = DateTime.now();
                                _focusedDay = DateTime.now();
                              }),
                            ),
                            SizedBox(width: 8.w),
                            _buildQuickDateButton(
                              'No date',
                              DateTime.now(),
                              isSelected: _selectedDay == null,
                              onTap: () => setDialogState(() {
                                _selectedDay = null;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Container(
                      color: Colors.white,
                      child: TableCalendar(
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        currentDay: DateTime.now(),
                        calendarFormat: CalendarFormat.month,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey[600], size: 24.w),
                          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey[600], size: 24.w),
                          titleTextStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(fontSize: 14.sp),
                          weekendTextStyle: TextStyle(fontSize: 14.sp),
                          outsideTextStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                          selectedDecoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryColor, width: 1),
                          ),
                          todayTextStyle: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14.sp,
                          ),
                          rowDecoration: BoxDecoration(color: Colors.white),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setDialogState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.blue[400], size: 20.w),
                              SizedBox(width: 12.w),
                              Text(
                                _selectedDay?.formatDate() ?? 'No date',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
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
                              SizedBox(width: 8.w),
                              TextButton(
                                onPressed: () {
                                  if (_selectedDay != null || !isStartDate) {
                                    Navigator.pop(context, _selectedDay);
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null || !isStartDate) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  DateTime _getNextWeekday(int weekday) {
    DateTime date = DateTime.now();
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  Widget _buildQuickDateButton(
    String label,
    DateTime date, {
    bool isHighlighted = false,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final backgroundColor = isHighlighted || isSelected
        ? AppTheme.primaryColor
        : Colors.grey[50];
    final textColor = isHighlighted || isSelected ? Colors.white : Colors.black87;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _startDate != null) {
      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        position: _positionController.text,
        startDate: _startDate!,
        endDate: _endDate,
      );

      if (widget.employee == null) {
        context.read<EmployeeBloc>().add(AddEmployee(employee));
      } else {
        context.read<EmployeeBloc>().add(UpdateEmployee(employee));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.employee == null ? 'Add Employee Details' : 'Edit Employee Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(
                  icon: Icons.person_outline,
                  controller: _nameController,
                  hint: 'Full Name',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                _buildPositionField(),
                Row(
                  children: [
                    _buildDateField(
                      date: _startDate,
                      hint: 'Start Date',
                      onTap: () => _selectDate(true),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.blue[400], size: 20.w),
                    _buildDateField(
                      date: _endDate,
                      hint: 'No date',
                      onTap: () => _selectDate(false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ActionButtons(
        onCancel: () => Navigator.pop(context),
        onSave: _submitForm,
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.blue[400], size: 20.w),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 13.sp,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildPositionField() {
    return GestureDetector(
      onTap: _showPositionPicker,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.work_outline, color: Colors.blue[400], size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _positionController.text.isEmpty ? 'Select role' : _positionController.text,
                style: TextStyle(
                  color: _positionController.text.isEmpty ? Colors.grey[400] : Colors.black87,
                  fontSize: 13.sp,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[400], size: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue[400], size: 20.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  date?.formatDate() ?? hint,
                  style: TextStyle(
                    color: date == null ? Colors.grey[400] : Colors.black87,
                    fontSize: 13.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
