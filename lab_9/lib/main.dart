import 'package:flutter/material.dart';
import 'screens/lab9_1_asset_screen.dart';
import 'screens/lab9_2_storage_screen.dart';
import 'screens/lab9_3_crud_screen.dart';

void main() {
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 – Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91AssetScreen(),
    Lab92StorageScreen(),
    Lab93CrudScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: '9.1 Assets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: '9.2 Storage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: '9.3 CRUD DB',
          ),
        ],
      ),
    );
  }
}
