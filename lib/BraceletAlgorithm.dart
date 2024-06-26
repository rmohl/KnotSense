import 'package:flutter/material.dart';
import 'Design.dart';

class PixelToPattern {
  final List<int> pattern;
  PixelToPattern({required this.pattern});

  // CONSTANTS

  static const int LEFT = 0;
  static const int RIGHT = 1;

  // FUNCTIONS:

  List<int> findBiggestRowLessThanN(List<List<int>> pixelArt, int colour, int n) {
    int val = 0;
    List<int> rows = [];

    // finding max value
    for (int i = 0; i < pixelArt.length-1; i++) {
      int count = pixelArt[i].where((element) => element == colour).length;
      if (count > val) {
        val = count;
      }
    }

    // finding rows with max value
    for (int i = 0; i < pixelArt.length-1; i++) {
      int count = pixelArt[i].where((element) => element == colour).length;
      if (count == val) {
        rows.add(i);
      }
    }

    return rows;
  }

  bool colourAfter(List<List<int>> pattern, int row1Index, int row2Index, int colour) {
    // check all rows after row 2
    if (row1Index < row2Index) {
      for (int i = 0; i < pattern.length-1; i++) {
        if (i > row2Index) {
          if (pattern[i].contains(colour)) {
            return true;
          }
        }
      }
    } else {
      // check all rows before row 1
      for (int i = 0; i < pattern.length-1; i++) {
        if (i < row1Index) {
          if (pattern[i].contains(colour)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  List<List<int>> connectRows(List<List<int>> pattern, int row1Index, int row2Index, int colour) {
    List<int> row1 = pattern[row1Index];
    List<int> row2 = pattern[row2Index];
    List<List<int>> connections = List.generate(row1.length, (_) => [0, 0]);

    // if row2 has more coloured knots than row1:
    if (row2.where((element) => element == colour).length > row1.where((element) => element == colour).length) {
      List<List<int>> backwardsConnections = connectRows(pattern, row2Index, row1Index, colour);

      // reformat connections
      if (row1.length > row2.length) {
        for (int i = 0; i < connections.length-1; i++) {
          if (i != 0) {
            connections[i][LEFT] = backwardsConnections[i - 1][RIGHT];
          }
          if (i != connections.length - 1) {
            connections[i][RIGHT] = backwardsConnections[i][LEFT];
          }
        }
      } else {
        for (int i = 0; i < connections.length-1; i++) {
          connections[i][LEFT] = backwardsConnections[i][RIGHT];
          connections[i][RIGHT] = backwardsConnections[i + 1][LEFT];
        }
      }
    } else {
      // if row1 has more coloured knots than row2:
      if (row1.length > row2.length) {
        for (int i = 0; i < row1.length-1; i++) {
          if (row1[i] == colour) {
            if (i == 0) {
              connections[i][RIGHT] = colour;
              if (row2[i] == colour) {
                row2[i] = -1;
              }
            } else if (i == row1.length - 1) {
              connections[i][LEFT] = colour;
              if (row2[i - 1] == colour) {
                row2[i - 1] = -1;
              }
            } else {
              if (row2[i - 1] == colour) {
                connections[i][LEFT] = colour;
                row2[i - 1] = -1;
              } else if (row2[i] == colour) {
                connections[i][RIGHT] = colour;
                row2[i] = -1;
              } else if (colourAfter(pattern, row1Index, row2Index, colour)) {
                connections[i][LEFT] = colour;
              }
            }
          }
        }
      } else { // smaller row to bigger row connection
        for (int i = 0; i < row1.length-1; i++) {
          if (row1[i] == colour) {
            if (row2[i] == colour) {
              connections[i][LEFT] = colour;
              row2[i] = -1;
            } else if (row2[i + 1] == colour) {
              connections[i][RIGHT] = colour;
              row2[i + 1] = -1;
            } else if (colourAfter(pattern, row1Index, row2Index, colour)) {
              connections[i][LEFT] = colour;
            }
          }
        }
      }
    }

    return connections;
  }

  List<List<List<int>>> completeStringPaths(List<List<int>> row1, List<List<int>> row2, int colour) {
    for (int knotIndex = 0; knotIndex < row1.length-1; knotIndex++) {
      List<int> row1knot = row1[knotIndex];
      if (row1.length > row2.length) { // row1 is longer than row2
        if (knotIndex != 0 && row1knot[LEFT] == colour) {
          if (row2[knotIndex - 1][RIGHT] != colour) {
            row2[knotIndex - 1][RIGHT] = colour;
          }
        }
        if (knotIndex != row1.length - 1 && row1knot[RIGHT] == colour) {
          if (row2[knotIndex][LEFT] != colour) {
            row2[knotIndex][LEFT] = colour;
          }
        }
      } else { // row1 is shorter than or equal to row2
        if (row1knot[LEFT] == colour) {
          if (row2[knotIndex][RIGHT] != colour) {
            row2[knotIndex][RIGHT] = colour;
          }
        }
        if (row1knot[RIGHT] == colour) {
          if (row2[knotIndex + 1][LEFT] != colour) {
            row2[knotIndex + 1][LEFT] = colour;
          }
        }
      }
    }
    return [row1, row2];
  }

  void determineKnotTypes(List<List<int>> pattern, List<List<String>> knots, List<List<List<int>>> connectionMatrix, int colour) {
    for (int rowIndex = 0; rowIndex < knots.length-1; rowIndex++) {
      List<List<int>> currRow = connectionMatrix[rowIndex];
      for (int knotIndex = 0; knotIndex < knots[rowIndex].length-1; knotIndex++) {
        List<int> currKnot = currRow[knotIndex];
        if (rowIndex == 0) { // first row
          if ((currKnot[LEFT] == colour && currKnot[RIGHT] == colour) || (currKnot[LEFT] != colour && currKnot[RIGHT] != colour)) {
            knots[rowIndex][knotIndex] = "f";
          } else if (currKnot[LEFT] == colour && currKnot[RIGHT] != colour) {
            if (pattern[rowIndex][knotIndex] == colour) {
              knots[rowIndex][knotIndex] = "b";
            } else {
              knots[rowIndex][knotIndex] = "f";
            }
          } else if (currKnot[LEFT] != colour && currKnot[RIGHT] == colour) {
            if (pattern[rowIndex][knotIndex] == colour) {
              knots[rowIndex][knotIndex] = "f";
            } else {
              knots[rowIndex][knotIndex] = "b";
            }
          }
        } else { // in-between rows and last row
          List<List<int>> prevRow = connectionMatrix[rowIndex - 1];
          int preLeftColour, preRightColour, postLeftColour, postRightColour;

          if (knots[rowIndex].length == 3) {
            preLeftColour = prevRow[knotIndex][RIGHT];
            preRightColour = prevRow[knotIndex + 1][LEFT];
            postLeftColour = currKnot[LEFT];
            postRightColour = currKnot[RIGHT];
          } else {
            List<List<int>> prevPrevRow = connectionMatrix[rowIndex - 2];
            if (knotIndex == 0) {
              preLeftColour = prevPrevRow[knotIndex][LEFT];
              preRightColour = prevRow[knotIndex][LEFT];
              postLeftColour = currKnot[LEFT];
              postRightColour = currKnot[RIGHT];
            } else if (knotIndex == knots[rowIndex].length - 1) {
              preLeftColour = prevRow[knotIndex - 1][RIGHT];
              preRightColour = prevPrevRow[knotIndex][RIGHT];
              postLeftColour = currKnot[LEFT];
              postRightColour = currKnot[RIGHT];
            } else {
              preLeftColour = prevRow[knotIndex - 1][RIGHT];
              preRightColour = prevRow[knotIndex][LEFT];
              postLeftColour = currKnot[LEFT];
              postRightColour = currKnot[RIGHT];
            }
          }
          if (pattern[rowIndex][knotIndex] == colour) {
            if (preLeftColour == colour && postRightColour == colour) {
              knots[rowIndex][knotIndex] = "f";
            } else if (preRightColour == colour && postLeftColour == colour) {
              knots[rowIndex][knotIndex] = "b";
            } else if (preLeftColour == colour && postLeftColour == colour) {
              knots[rowIndex][knotIndex] = "fb";
            } else if (preRightColour == colour && postRightColour == colour) {
              knots[rowIndex][knotIndex] = "bf";
            }
          } else {
            if (preLeftColour != colour && postRightColour != colour) {
              knots[rowIndex][knotIndex] = "f";
            } else if (preRightColour != colour && postLeftColour != colour) {
              knots[rowIndex][knotIndex] = "b";
            } else if (preLeftColour != colour && postLeftColour != colour) {
              knots[rowIndex][knotIndex] = "fb";
            } else if (preRightColour != colour && postRightColour != colour) {
              knots[rowIndex][knotIndex] = "bf";
            }
          }
        }
      }
    }
  }

  void finalizeConnectionMatrix(List<List<List<int>>> connectionMatrix, int startRowIndex, int colour) {
    //row and up:
    if (startRowIndex > 0) {
      for (int rowNum = startRowIndex; rowNum > 0; rowNum--) {
        List<List<List<int>>> resultRows = completeStringPaths(connectionMatrix[rowNum], connectionMatrix[rowNum - 1], colour);
        connectionMatrix[rowNum] = resultRows[0];
        connectionMatrix[rowNum-1] = resultRows[1];
      }
    }

    // row and down:
    if (startRowIndex < connectionMatrix.length - 1) {
      for (int rowNum = startRowIndex; rowNum < connectionMatrix.length-1; rowNum++) {
        print(rowNum);
        List<List<List<int>>> resultRows = completeStringPaths(connectionMatrix[rowNum], connectionMatrix[rowNum + 1], colour);
        connectionMatrix[rowNum] = resultRows[0];
        connectionMatrix[rowNum+1] = resultRows[1];
      }
    }
  }

  List<String> getKnotInfo() {
    int colour = 1;

    List<List<List<int>>> connectionMatrix = [    // start w/ everything is background colour
      [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0]
      ],
      [
        [0, 0],
        [0, 0],
        [0, 0]
      ],
      [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0]
      ],
      [
        [0, 0],
        [0, 0],
        [0, 0]
      ],
      [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0]
      ]
    ];
    List<List<String>> guessMatrix = [
      ["0", "0", "0", "0"],
      ["0", "0", "0"],
      ["0", "0", "0", "0"],
      ["0", "0", "0"],
      ["0", "0", "0", "0"]
    ];

    // 1 convert to this format:
    List<List<int>> formattedPattern = [
      [pattern[0], pattern[1], pattern[2], pattern[3]],
      [pattern[4], pattern[5], pattern[6]],
      [pattern[7], pattern[8], pattern[9], pattern[10]],
      [pattern[11], pattern[12], pattern[13]],
      [pattern[14], pattern[15], pattern[16], pattern[17]]
    ];
    List<List<int>> formattedPatternCopy = [
      [pattern[0], pattern[1], pattern[2], pattern[3]],
      [pattern[4], pattern[5], pattern[6]],
      [pattern[7], pattern[8], pattern[9], pattern[10]],
      [pattern[11], pattern[12], pattern[13]],
      [pattern[14], pattern[15], pattern[16], pattern[17]]
    ];

    List<int> startingRows = findBiggestRowLessThanN(formattedPatternCopy, colour, 1);
    // print(startingRows);

    for (int i = 0; i < formattedPatternCopy.length - 1; i++) {
      connectionMatrix[i] = connectRows(formattedPatternCopy, i, i + 1, colour);
    }

    finalizeConnectionMatrix(connectionMatrix, startingRows[0], colour);

    determineKnotTypes(formattedPattern, guessMatrix, connectionMatrix, colour);

    return [...guessMatrix[0], ...guessMatrix[1], ...guessMatrix[2], ...guessMatrix[3], ...guessMatrix[4]];
  }
}