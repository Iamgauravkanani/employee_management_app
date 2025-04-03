import 'package:employee_management/utils/assets.dart';
import 'package:employee_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/employee_bloc/employee_bloc.dart';
import '../blocs/employee_bloc/employee_event.dart';
import '../blocs/employee_bloc/employee_state.dart';
import '../data/models/employee.dart';
import '../widgets/employee_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/responsive_wrapper.dart';
import 'add_edit_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          'Employee List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ResponsiveWrapper(
        backgroundColor: Colors.grey[100],
        child: BlocConsumer<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is EmployeeOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<EmployeeBloc>().add(LoadEmployees());
            }
          },
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const LoadingIndicator();
            } else if (state is EmployeeLoaded) {
              return _buildEmployeeList(context, state.employees);
            } else if (state is EmployeeError) {
              return Center(child: Text(state.error));
            }
            return const LoadingIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        elevation: 2,
        child: Icon(Icons.add, size: 24.w, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<EmployeeBloc>(context),
              child: const AddEditEmployeeScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAddEdit(BuildContext context, [Employee? employee]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<EmployeeBloc>(context),
          child: AddEditEmployeeScreen(employee: employee),
        ),
      ),
    );
    if (context.mounted) {
      context.read<EmployeeBloc>().add(LoadEmployees());
    }
  }

  Widget _buildEmployeeList(BuildContext context, List<Employee> employees) {
    if (employees.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.noDataAsset),
          Center(
            child: Text(
              'No employee records found',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      );
    }

    final currentEmployees = employees.where((e) => e.endDate == null).toList();
    final previousEmployees = employees.where((e) => e.endDate != null).toList();

    return ListView(
      padding: EdgeInsets.only(bottom: 80.h),
      children: [
        if (currentEmployees.isNotEmpty) ...[
          _buildSectionHeader('Current employees'),
          ...currentEmployees.map((employee) => _buildEmployeeCard(context, employee)),
        ],
        if (previousEmployees.isNotEmpty) ...[
          _buildSectionHeader('Previous employees'),
          ...previousEmployees.map((employee) => _buildEmployeeCard(context, employee)),
        ],
        if (currentEmployees.isNotEmpty || previousEmployees.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'Swipe left to edit or delete',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.blue[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    return EmployeeCard(
      employee: employee,
      onEdit: () => _navigateToAddEdit(context, employee),
      onDelete: () => context.read<EmployeeBloc>().add(DeleteEmployee(employee.id)),
    );
  }
}
