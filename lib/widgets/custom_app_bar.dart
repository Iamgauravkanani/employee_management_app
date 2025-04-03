import 'package:employee_management/utils/constant.dart';
import 'package:employee_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      backgroundColor: AppTheme.primaryColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: AppConstants.medium,
          color: AppTheme.lightCardColor,
          fontSize: AppConstants.fontSize18,
        ),
      ),

      elevation: 0,
      scrolledUnderElevation: 4,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
