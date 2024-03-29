import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Design.dart';
import 'DesignListProvider.dart';

class PixelArtPage extends StatelessWidget {
  final ThemeData theme;

  PixelArtPage({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final designListProvider = Provider.of<DesignListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: theme.primaryColorDark),
        centerTitle: true,
        title: Text('Pixel Art Design', style: theme.textTheme.displaySmall),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0), // Adjust the top padding as needed
            child: Center(
              child: Container(
                width: 300, // Adjust width as needed
                height: 50, // Adjust height as needed
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  image: const DecorationImage(
                    image: AssetImage("assets/bracelet.png"), //NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    width: 4,
                    color: theme.primaryColorDark
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Pattern Preview', // Your text goes here
              style: theme.textTheme.bodyMedium, // Adjust font size as needed
            ),
          ),
          Divider(color: theme.primaryColor, height: 2, endIndent: 0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 70.0, bottom: 20.0), // Adjust the top padding as needed
                child: Center(
                  child: Container(
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    decoration: BoxDecoration(
                      color: theme.primaryColorLight,
                      image: const DecorationImage(
                        image: AssetImage("assets/bracelet.png"), //NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 4,
                        color: theme.primaryColorDark
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Container(
                  width: 50, // Adjust width as needed
                  height: 320, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: theme.primaryColorLight,
                    border: Border.all(
                      color: theme.primaryColorDark,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.select_all, color: theme.primaryColorDark),
                        tooltip: 'Select',
                        onPressed: () {
                        },
                      ),
                      Divider(color: theme.primaryColor),
                      IconButton(
                        icon: Icon(Icons.border_color, color: theme.primaryColorDark),
                        tooltip: 'Colour Pen',
                        onPressed: () {
                        },
                      ),
                      Divider(color: theme.primaryColor),
                      IconButton(
                        icon: Icon(Icons.texture, color: theme.primaryColorDark),
                        tooltip: 'Eraser',
                        onPressed: () {
                        },
                      ),
                      Divider(color: theme.primaryColor),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: theme.primaryColorDark),
                        tooltip: 'Save',
                        onPressed: () {
                          // Create a new Design object
                          Design newDesign = Design(
                            previewPath: AssetImage("assets/bracelet.png"),
                            pixelPath: AssetImage("assets/bracelet.png"),
                            knotPath: AssetImage("assets/pattern.png"),
                          );

                          /// Add the new design to the provider list
                          designListProvider.addDesign(newDesign);

                          /// Notify the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New design saved'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: theme.primaryColorDark),
                        tooltip: 'Exit',
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Divider(color: theme.primaryColor, height: 1),
          Container(
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 22), // Adjust the top padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.primaryColorLight,
                        border: Border.all(
                          width: 2,
                          color: theme.primaryColorDark
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.upload, color: theme.primaryColorDark),
                        tooltip: 'upload',
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}