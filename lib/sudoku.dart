import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:sudoku/sudoku_gen.dart';

import 'main.dart';

class SudokuPage extends StatefulWidget {
  final int i;
  final String title;

  SudokuPage({required this.i, required this.title});

  @override
  _SudokuPageState createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  final List<int> dropdownItems = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  late List matrix;
  late List newList;
  late List newList2;
  var dropdownvalues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  @override
  void initState() {
    final Random random = Random();
    matrix = SudokuGenerator().createSudoku();
    newList = SudokuGenerator().createSudoku();
    newList2 = newList;
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    _controller.play();
    var count = 0;
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (random.nextInt(100) >= widget.i * 20) {
          newList[i][j] = List.from(matrix)[i][j];
          count++;
        } else {
          newList[i][j] = 0;
        }
      }
    }

    super.initState();
    setState(() {
      matrix;
    });
  }

  late ConfettiController _controller;
  @override
  Widget build(BuildContext context) {
    List selectedValue = List.filled(81, 0);
    final List<int> dropdownItems = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                newList = matrix;
                setState(() {
                  newList;
                });
              },
              child: Text('Çözümü gör'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                newList = newList2;
                setState(() {
                  newList;
                });
              },
              child: Text('Sıfırla'),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.height / 1.5,
                child: GridView.count(
                  shrinkWrap: false,
                  crossAxisCount: 9,
                  children: List.generate(81, (index) {
                    selectedValue[index] = 0;
                    final row = index ~/ 9;
                    final col = index % 9;
                    final value = newList[row][col];
                    final isGiven = value != 0;
                    final borderSide =
                        BorderSide(width: 3, color: Colors.black);
                    final borderSide2 =
                        BorderSide(width: 1, color: Colors.black);
                    final topBorder = row % 3 == 0 ? borderSide : borderSide2;
                    final bottomBorder =
                        row % 3 == 2 ? borderSide : borderSide2;
                    final leftBorder = col % 3 == 0 ? borderSide : borderSide2;
                    final rightBorder = col % 3 == 2 ? borderSide : borderSide2;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: topBorder,
                          bottom: bottomBorder,
                          left: leftBorder,
                          right: rightBorder,
                        ),
                        color: isGiven
                            ? Color.fromARGB(255, 161, 159, 159)
                            : Color.fromARGB(255, 223, 222, 222),
                      ),
                      child: Center(
                          child: isGiven
                              ? Text(
                                  value.toString(),
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black),
                                )
                              : DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  items: dropdownItems
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    if (checkrow(row, col, newValue) == true) {
                                      setState(() {
                                        newList[row][col] = newValue!;
                                        chckfinish();
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(
                                                Duration(milliseconds: 1200),
                                                () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return const AlertDialog(
                                              title: Text(
                                                  'Bu rakam buraya yazılamaz !'),
                                            );
                                          });
                                    }
                                  },
                                )),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  chckfinish() {
    bool areEqual = true;

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] != newList[i][j]) {
          areEqual = false;
          break;
        }
      }
    }

    if (areEqual) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Congratulations, you won the game!'),
              content: Container(
                  child: ConfettiWidget(
                numberOfParticles: 50,
                confettiController: _controller,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              )),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    child: const Text("Tekrar Oyna")),
                ElevatedButton(
                  child: Text('Kapat'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      return false;
    }
  }

  checkrow(row, col, int? newValue) {
    if (newValue == matrix[row][col]) {
      return true;
    } else {
      false;
      for (var i = 0; i < newList.length; i++) {
        for (var j = 0; j < 9; j++) {
          if (newValue == newList[i][j]) {
            break;
          }
        }
      }
    }
  }
}
