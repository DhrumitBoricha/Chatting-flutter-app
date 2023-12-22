
import 'package:Chat.On/Splesh.dart';
import 'package:Chat.On/home.dart';
import 'package:Chat.On/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abcd.dart';
import 'login-signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true;
  @override
  void initState() {
    super.initState();
    _checkFirstTimeLaunch();
  }
  Future<void> _checkFirstTimeLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    setState(() {
      _showSplashScreen = isFirstTime;
    });

    // Update the isFirstTime flag
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _showSplashScreen ? SplashScreen() : ProductListScreen(),
    );
  }
}
