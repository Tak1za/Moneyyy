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
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: _navigationOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
