import 'package:employee_management/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/employee_bloc/employee_bloc.dart';
import 'blocs/employee_bloc/employee_event.dart';
import 'blocs/employee_bloc/employee_repository.dart';
import 'data/local/employee_dao.dart';
import 'data/models/employee.dart';
import 'utils/theme.dart';
import 'views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<EmployeeDao>(create: (context) => EmployeeDao()),
        RepositoryProvider<EmployeeRepository>(
          create: (context) => EmployeeRepositoryImpl(RepositoryProvider.of<EmployeeDao>(context)),
        ),
      ],
      child: BlocProvider(
        create: (context) => EmployeeBloc(RepositoryProvider.of<EmployeeDao>(context))..add(LoadEmployees()),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Employee Management',
              theme: AppTheme.lightTheme,
              home: const SplashScreen(),
              builder: (context, child) {
                // Initialize ScreenUtil for responsive sizing
                ScreenUtil.init(
                  context,
                  designSize: MediaQuery.of(context).size.width > 600
                      ? const Size(1200, 800)
                      : const Size(375, 812),
                );
                
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
