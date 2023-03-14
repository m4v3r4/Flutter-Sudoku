import 'dart:math';

class SudokuGenerator {
  bool hata = false;
  List<List<int>> createSudoku() {
    var rng = new Random();
    var sudoku = List.generate(9, (_) => List.filled(9, 0));

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        var possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];

        // remove values in same row and column
        for (var k = 0; k < 9; k++) {
          if (sudoku[i][k] != 0) {
            possibleValues.remove(sudoku[i][k]);
          }
          if (sudoku[k][j] != 0) {
            possibleValues.remove(sudoku[k][j]);
          }
        }

        // remove values in same 3x3 box
        var boxRow = (i ~/ 3) * 3;
        var boxCol = (j ~/ 3) * 3;
        for (var m = boxRow; m < boxRow + 3; m++) {
          for (var n = boxCol; n < boxCol + 3; n++) {
            if (sudoku[m][n] != 0) {
              possibleValues.remove(sudoku[m][n]);
            }
          }
        }

        // set value randomly from possible values
        if (possibleValues.isNotEmpty) {
          sudoku[i][j] = possibleValues[rng.nextInt(possibleValues.length)];
        } else {
          hata = true;
        }
      }
    }

    bool hasZero(List<List<int>> matrix) {
      for (var row in matrix) {
        if (row.contains(0)) {
          return true;
        }
      }
      return false;
    }

    if (hasZero(sudoku)) {
      return SudokuGenerator().createSudoku();
    } else {
      return sudoku;
    }
  }
}
