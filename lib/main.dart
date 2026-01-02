import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:splitteretv/controllers/expense_controller.dart';
import 'package:splitteretv/controllers/group_controller.dart';
import 'package:splitteretv/controllers/user_controller.dart';
import 'package:splitteretv/controllers/auth_controller.dart';
import 'package:splitteretv/screens/splash_screen.dart';
import 'package:splitteretv/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://nrvykkckjbxftydwdzmk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ydnlra2NramJ4ZnR5ZHdkem1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczMjc0MjEsImV4cCI6MjA4MjkwMzQyMX0.DjFyJkSXHBYvMPp-41Tpm51efVYSw3P4QjeSqmFwcNE',
  );
  
  runApp(const SplitteretVApp());
}

class SplitteretVApp extends StatelessWidget {
  const SplitteretVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ExpenseController()),
        ChangeNotifierProvider(create: (_) => GroupController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: MaterialApp(
        title: 'SplitteretV',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(
            AppColors.primary.value,
            {
              50: const Color(0xFFE8F8E8),
              100: const Color(0xFFC5EDC5),
              200: const Color(0xFF9FE19F),
              300: const Color(0xFF79D479),
              400: const Color(0xFF5CCA5C),
              500: AppColors.primary,
              600: const Color(0xFF04AA00),
              700: const Color(0xFF039A00),
              800: const Color(0xFF038A00),
              900: const Color(0xFF027200),
            },
          ),
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textDark),
            titleTextStyle: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}