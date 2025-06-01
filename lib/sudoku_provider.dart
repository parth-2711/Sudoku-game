import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'db_helper.dart'; // ✅ Make sure db_helper.dart is created as shown

class SudokuProvider extends ChangeNotifier {
  late List<List<int>> _puzzle;
  late List<List<int>> _solution;
  late List<List<bool>> _fixed;
  late List<List<bool>> _userEntered;

  int? selectedRow, selectedCol;

  final List<List<List<int>>> _history = [];
  final List<List<List<int>>> _redoStack = [];

  SudokuProvider() {
    _loadGame(); // ✅ Load game from DB on start
  }

  // --- Accessors ---
  int getValue(int row, int col) => _solution[row][col];
  bool isFixed(int row, int col) => _fixed[row][col];
  bool isUserEntered(int row, int col) => _userEntered[row][col];
  bool isSelected(int row, int col) => selectedRow == row && selectedCol == col;

  // --- Select cell ---
  void selectCell(int row, int col) {
    if (_fixed[row][col]) return;
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }

  // --- Enter number ---
  void enterValue(int value) {
    if (selectedRow == null || selectedCol == null) return;
    if (_fixed[selectedRow!][selectedCol!]) return;

    if (isValid(selectedRow!, selectedCol!, value)) {
      _saveState();
      _solution[selectedRow!][selectedCol!] = value;
      _userEntered[selectedRow!][selectedCol!] = true;
      notifyListeners();
      _saveGame();
    }
  }

  // --- Erase selected cell ---
  void eraseCell() {
    if (selectedRow == null || selectedCol == null) return;
    if (_fixed[selectedRow!][selectedCol!]) return;

    if (_solution[selectedRow!][selectedCol!] != 0) {
      _saveState();
      _solution[selectedRow!][selectedCol!] = 0;
      _userEntered[selectedRow!][selectedCol!] = false;
      notifyListeners();
      _saveGame();
    }
  }

  // --- Undo/Redo system ---
  void _saveState() {
    _history.add(_cloneBoard(_solution));
    if (_history.length > 100) _history.removeAt(0);
    _redoStack.clear();
  }

  void undo() {
    if (_history.length <= 1) return;
    _redoStack.add(_cloneBoard(_solution));
    _solution = _cloneBoard(_history.removeLast());
    notifyListeners();
    _saveGame();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _solution = _cloneBoard(_redoStack.removeLast());
    _history.add(_cloneBoard(_solution));
    notifyListeners();
    _saveGame();
  }

  List<List<int>> _cloneBoard(List<List<int>> board) =>
      board.map((row) => [...row]).toList();

  // --- Restart ---
  void restartGame() {
    List<List<int>> fullBoard = _generateFullSolution();
    _puzzle = _createPuzzle(fullBoard, 40);
    _solution = _puzzle.map((row) => [...row]).toList();
    _fixed = _puzzle.map((row) => row.map((v) => v != 0).toList()).toList();
    _userEntered = List.generate(9, (_) => List.generate(9, (_) => false));
    selectedRow = null;
    selectedCol = null;
    _history.clear();
    _redoStack.clear();
    _saveState();
    notifyListeners();
    _saveGame();
  }

  // --- Load from DB or generate new ---
  Future<void> _loadGame() async {
    final data = await DBHelper.loadGame();
    if (data != null) {
      _puzzle = (jsonDecode(data['puzzle']) as List)
          .map((e) => (e as List).map((x) => x as int).toList())
          .toList();
      _solution = (jsonDecode(data['solution']) as List)
          .map((e) => (e as List).map((x) => x as int).toList())
          .toList();
      _userEntered = (jsonDecode(data['userEntered']) as List)
          .map((e) => (e as List).map((x) => x as bool).toList())
          .toList();
      _fixed = _puzzle.map((row) => row.map((val) => val != 0).toList()).toList();
    } else {
      restartGame(); // generate new game
    }
    notifyListeners();
  }

  Future<void> _saveGame() async {
    await DBHelper.saveGame(
      puzzle: _puzzle,
      solution: _solution,
      userEntered: _userEntered,
    );
  }

  // --- Validity check ---
  bool isValid(int row, int col, int value) {
    for (int i = 0; i < 9; i++) {
      if (_solution[row][i] == value || _solution[i][col] == value) return false;
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_solution[startRow + i][startCol + j] == value) return false;
      }
    }
    return true;
  }

  bool isCompleted() => !_solution.any((row) => row.contains(0));

  // --- Puzzle generation ---
  List<List<int>> _generateFullSolution() {
    List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonalBoxes(board);
    _solveBoard(board);
    return board;
  }

  void _fillDiagonalBoxes(List<List<int>> board) {
    for (int i = 0; i < 9; i += 3) {
      _fillBox(board, i, i);
    }
  }

  void _fillBox(List<List<int>> board, int rowStart, int colStart) {
    var rng = Random();
    List<int> nums = List.generate(9, (i) => i + 1)..shuffle(rng);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        board[rowStart + i][colStart + j] = nums.removeLast();
      }
    }
  }

  bool _solveBoard(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isSafe(board, row, col, num)) {
              board[row][col] = num;
              if (_solveBoard(board)) return true;
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isSafe(List<List<int>> board, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) return false;
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) return false;
      }
    }
    return true;
  }

  List<List<int>> _createPuzzle(List<List<int>> board, int clues) {
    var rng = Random();
    List<List<int>> puzzle = board.map((row) => [...row]).toList();
    int cellsToRemove = 81 - clues;

    while (cellsToRemove > 0) {
      int row = rng.nextInt(9);
      int col = rng.nextInt(9);
      if (puzzle[row][col] != 0) {
        puzzle[row][col] = 0;
        cellsToRemove--;
      }
    }

    return puzzle;
  }
}