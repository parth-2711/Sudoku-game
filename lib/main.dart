import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sudoku_provider.dart';
import 'splash_screen.dart';
//import 'db_helper.dart'; // ✅ Required

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TEMP: Clear old corrupt data on first run
  //await DBHelper.clearGame();

  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SudokuProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}