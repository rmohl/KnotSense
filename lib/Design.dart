import 'package:flutter/material.dart';

class Design {
  final String designName;
  final AssetImage previewPath;
  final AssetImage pixelPath;
  final AssetImage knotPath;
  bool isFavourite;
  List<PixelInfo> pixelGrid; // Array of PixelInfo objects

  Design({
    this.designName = "",
    required this.previewPath,
    required this.pixelPath,
    required this.knotPath,
    this.isFavourite = false,
    List<PixelInfo>? pixelGrid, // Nullable list
  }) : pixelGrid = List<PixelInfo>.generate(
    defaultSize,
        (index) => PixelInfo(color: Colors.white),
  );

// Default size for the pixelGrid list
  static const int defaultSize = 18;

  // Method to check if any single PixelInfo color in pixelGrid is blank
  bool hasBlank() {
    for (final pixelInfo in pixelGrid) {
      if (pixelInfo.color == Colors.white) {
        return true; // Return true if any pixel is blank
      }
    }
    return false; // Return false if all pixels have colors
  }

  // Method to fill the pixelGrid with the specified color
  void fillGrid(Color color) {
    for (int i = 0; i < pixelGrid.length; i++) {
      pixelGrid[i] = PixelInfo(color: color);
    }
  }

  List<int> colorsToNums() {
    // Map the colors to integers: 0 for color1, 1 for color2
    List<int> numList = pixelGrid.map((pixelInfo) {
      if (pixelInfo.color == Color(0xFF7395D9)) {
        return 0;
      } else {
        return 1;
      }
    }).toList();
    return numList;
  }

  List<Color> colorsToList() {
    // Map the colors to integers: 0 for color1, 1 for color2
    List<Color> colorList = pixelGrid.map((pixelInfo) {
      if (pixelInfo.color == Color(0xFF7395D9)) {
        return Color(0xFF7395D9);
      } else {
        return Color(0xFFC498EE);;
      }
    }).toList();
    return colorList;
  }
}

class PixelInfo {
  Color color;

  PixelInfo({
    required this.color,
  });
}