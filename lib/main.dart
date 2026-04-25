import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superraion/features/auth/view/login.dart';
import 'package:superraion/features/auth/view/registrasi.dart';
import 'package:superraion/features/log/view/log.dart';
import 'core/constants/app_color.dart';
import 'features/auth/viewmodel/auth_view_model.dart';
import 'features/log/viewmodel/log_viewmodel.dart';
import 'features/onboarding/view/onboarding.dart';
import 'features/onboarding/viewmodel/onboarding_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => LogViewModel()),
        ChangeNotifierProvider(create: (_) => FoodIntakeViewModel()),
        ChangeNotifierProvider(create: (_) => DailyHabitViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Auth Hackathon',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
               scaffoldBackgroundColor: AppColors.bg,
              // primaryColor: AppColors.primary,
            ),
            initialRoute: '/login',

            // daftar route
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/log': (context) => Log(),
            },
          );
        },
      ),
    );
  }
}