// sudoku_game.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sudoku_provider.dart';

class SudokuGame extends StatelessWidget {
  const SudokuGame({super.key});

  Border _getCellBorder(int row, int col) {
    return Border(
      top: BorderSide(
        color: Colors.black,
        width: row == 0 ? 2 : (row % 3 == 0 ? 1.5 : 0.5),
      ),
      bottom: BorderSide(
        color: Colors.black,
        width: row == 8 ? 2 : ((row + 1) % 3 == 0 ? 1.5 : 0.5),
      ),
      left: BorderSide(
        color: Colors.black,
        width: col == 0 ? 2 : (col % 3 == 0 ? 1.5 : 0.5),
      ),
      right: BorderSide(
        color: Colors.black,
        width: col == 8 ? 2 : ((col + 1) % 3 == 0 ? 1.5 : 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SudokuProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text(
          'Sudoku Game',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: 81,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 9;
                int col = index % 9;
                bool isFixed = provider.isFixed(row, col);
                bool isSelected = provider.isSelected(row, col);
                int value = provider.getValue(row, col);

                return GestureDetector(
                  onTap: () => provider.selectCell(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: _getCellBorder(row, col),
                      color: isSelected
                          ? Colors.purple.shade100
                          : provider.isUserEntered(row, col)
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        value != 0 ? value.toString() : '',
                        style: TextStyle(
                          fontWeight:
                          isFixed ? FontWeight.bold : FontWeight.normal,
                          fontSize: 24,
                          color: isFixed
                              ? Colors.deepPurple
                              : const Color.fromARGB(255, 221, 22, 237),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: provider.undo,
                icon: const Icon(Icons.undo),
                label: const Text("Undo"),
              ),
              ElevatedButton.icon(
                onPressed: provider.eraseCell,
                icon: const Icon(Icons.delete),
                label: const Text("Erase"),
              ),
              ElevatedButton.icon(
                onPressed: provider.restartGame,
                icon: const Icon(Icons.restart_alt),
                label: const Text("Restart"),
              ),
            ],
          ),
          SizedBox(height: 20),

          //const Divider(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: List.generate(9, (index) {
              int number = index + 1;
              return ElevatedButton(
                onPressed: () => provider.enterValue(number),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(10, 60),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: const Color.fromARGB(100, 190, 34, 214),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(number.toString()),
              );
            }),
          ),

          const SizedBox(height: 70),
        ],
      ),
    );
  }
}