import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superraion/core/viewmodel/navbar_viewmodel.dart';
import 'package:superraion/features/auth/view/login.dart';
import 'package:superraion/features/auth/view/registrasi.dart';
import 'package:superraion/features/home/view/homepage.dart';
import 'package:superraion/features/home/viewmodel/home_viewmodel.dart';
import 'package:superraion/features/log/view/log.dart';
import 'package:superraion/features/profil/view/profil_page.dart';
import 'package:superraion/features/profil/viewmodel/profil_view_model.dart';
import 'package:superraion/features/weekly_report/view/weekly_report_page.dart';
import 'package:superraion/features/weekly_report/viewmodel/weekly_report.dart';
import 'core/constants/app_color.dart';
import 'features/auth/viewmodel/auth_view_model.dart';
import 'features/log/viewmodel/log_viewmodel.dart';
import 'features/onboarding/view/onboarding.dart';
import 'features/onboarding/viewmodel/onboarding_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await initializeDateFormatting('id_ID', '');
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
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => NavbarViewModel()),
        ChangeNotifierProvider(create: (_) => RecentLogViewModel()),
        ChangeNotifierProvider(create: (_) => WeeklySummaryViewModel()),
        ChangeNotifierProvider(create: (_) => BodyInsightViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => WeeklySummaryViewModel()),
        ChangeNotifierProvider(create: (_) => InsightViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => WeeklyAnalysisViewModel()),
        ChangeNotifierProvider(create: (_) => WeeklyReportViewModel()),
        ChangeNotifierProvider(create: (_) => MedicalNoteViewModel()),
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
            ),
            initialRoute: '/profil',

            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/log': (context) => Log(),
              '/home': (context) => HomeView(),
              '/weekly': (context) => WeeklyReportPage(),
              '/profil': (context) => ProfileView(),
            },
          );
        },
      ),
    );
  }
}