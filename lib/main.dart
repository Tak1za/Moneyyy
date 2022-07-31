import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/expenses_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _navigationOptions = [
    const ExpensesScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(
            color: Colors.black,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 17,
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
          labelSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(
            color: Colors.white,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
          ),
          backgroundColor: Colors.black,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 17,
        ),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: _navigationOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
