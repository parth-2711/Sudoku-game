//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'sudoku_provider.dart';
//import 'sudoku_game.dart';
//
//class DifficultySelectionScreen extends StatelessWidget {
//  const DifficultySelectionScreen({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//    // Access the SudokuProvider to set the difficulty.
//    final provider = Provider.of<SudokuProvider>(context, listen: false);
//
//    return Scaffold(
//      backgroundColor: Colors.purple.shade100, // Consistent background color
//      appBar: AppBar(
//        backgroundColor: Colors.purple.shade100,
//        title: const Text(
//          'Select Difficulty',
//          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
//        ),
//        centerTitle: true,
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            const Text(
//              'Choose your challenge:',
//              style: TextStyle(
//                fontSize: 24,
//                fontWeight: FontWeight.w600,
//                color: Colors.deepPurple,
//              ),
//            ),
//            const SizedBox(height: 40),
//            // Button for Easy difficulty
//            _buildDifficultyButton(
//              context,
//              provider,
//              //SudokuDifficulty.easy,
//              'Easy',
//              //Colors.green.shade700,
//              // You can adjust these values for size
//              horizontalPadding: 60.0, // Increased horizontal padding
//              verticalPadding: 25.0,   // Increased vertical padding
//              fontSize: 26.0,          // Increased font size
//            ),
//            const SizedBox(height: 20),
//            // Button for Medium difficulty
//            _buildDifficultyButton(
//              //context,
//              //provider,
//              ////SudokuDifficulty.medium,
//              //'Medium',
//              //Colors.green.shade700,
//              // You can adjust these values for size
//              //horizontalPadding: 40.0, // Increased horizontal padding
//              //verticalPadding: 25.0,   // Increased vertical padding
//              //fontSize: 26.0,          // Increased font size
//            //),
//            const SizedBox(height: 20),
//            // Button for Hard difficulty
//            _buildDifficultyButton(
//              context,
//              provider,
//              SudokuDifficulty.hard,
//              'Hard',
//              Colors.red.shade700,
//              horizontalPadding: 60.0,
//              verticalPadding: 25.0,
//              fontSize: 26.0,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  // Helper method to build a consistent difficulty button.
//  Widget _buildDifficultyButton(
//      BuildContext context,
//      SudokuProvider provider,
//      SudokuDifficulty difficulty,
//      String text,
//      Color color, {
//        double horizontalPadding = 50.0, // Default horizontal padding
//        double verticalPadding = 20.0,   // Default vertical padding
//        double fontSize = 22.0,          // Default font size
//      }) {
//    return ElevatedButton(
//      onPressed: () {
//        // Set the selected difficulty in the provider.
//        provider.setDifficulty(difficulty);
//        // Navigate to the Sudoku game screen, replacing the current screen.
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(builder: (context) => const SudokuGame()),
//        );
//      },
//      style: ElevatedButton.styleFrom(
//        backgroundColor: color,
//        foregroundColor: Colors.white,
//        padding: EdgeInsets.symmetric(
//            horizontal: horizontalPadding,
//            vertical: verticalPadding
//        ),
//        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(150),
//        ),
//        elevation: 5,
//      ),
//      child: Text(text),
//    );
//  }
//}
//