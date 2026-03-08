import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/habit_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/ai_coach_settings_screen.dart';
import 'services/habit_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HabitFlowApp());
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitService()),
      ],
      child: MaterialApp(
        title: 'HabitFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        routes: {
          '/add': (context) => const AddHabitScreen(),
          '/detail': (context) => const HabitDetailScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/ai-coach': (context) => const AICoachScreen(),
          '/ai-coach-settings': (context) => const AICoachSettingsScreen(),
        },
      ),
    );
  }
}
