import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/hive_service.dart';
import 'services/shared_preferences_service.dart';

void main() async {
  HiveService hiveService = HiveService();
  await hiveService.initHive();

  SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();
  bool isLoggedIn = await sharedPreferencesService.isLoggedIn();

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn
          ? HomeScreen(
              username: '',
            )
          : const SplashScreen(),
    );
  }
}
