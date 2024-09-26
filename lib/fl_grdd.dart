import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Drag and Drop Example')),
        body: const DragDropDemo(),
      ),
    );
  }
}

class DragDropDemo extends StatefulWidget {
  const DragDropDemo({Key? key}) : super(key: key);

  @override
  _DragDropDemoState createState() => _DragDropDemoState();
}

class _DragDropDemoState extends State<DragDropDemo> {
  final List<String> leftItems = ["Happy", "Hot", "High", "Sad", "Glad"];
  final List<String> rightItems = ['coffee', 'News', 'port', 'time', 'tone'];
  late List<String> randomizedRightItems;
  String droppedItem = '';

  @override
  void initState() {
    super.initState();
    randomizedRightItems = List.from(rightItems)..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Vertical scrolling for long lists
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
          children: [
            // Grid with top and bottom grid lines
            GridView.count(
              physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
              shrinkWrap: true, // Wrap content based on grid items
              crossAxisCount: 3, // Three columns in the grid
              childAspectRatio: 3.0, // Adjust width-to-height ratio as needed
              children: [
                for (int i = 0; i < leftItems.length; i++) ...[
                  // Left draggable item
                  Draggable<String>(
                    data: leftItems[i],
                    child: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(leftItems[i], style: const TextStyle(color: Colors.white)),
                    ),
                    feedback: Material(
                      child: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.all(20),
                        child: Text(leftItems[i], style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    childWhenDragging: Container(
                      color: Colors.grey,
                      padding: const EdgeInsets.all(20),
                      child: const Text('Dragging...', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  // Spacer between draggable and droppable columns
                  const SizedBox(width: 20),
                  // Right droppable item
                  DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        droppedItem = '${leftItems[i]} -> ${randomizedRightItems[i]}';
                        print(droppedItem); // Print the drag-and-drop result
                      });
                    },
                    onWillAcceptWithDetails: (details) {
                      return true;
                    },
                    onLeave: (data) {
                      // Handle item leaving the target if necessary
                    },
                    builder: (context, acceptedItems, rejectedItems) {
                      return Container(
                        width: 100,
                        height: 50,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: acceptedItems.isEmpty ? Colors.green : Colors.orange,
                        alignment: Alignment.center,
                        child: Text(
                          randomizedRightItems[i].isNotEmpty ? randomizedRightItems[i] : 'Drop Here',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            // Divider (optional)
            const Divider(thickness: 2, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
class MyLine extends StatelessWidget {
  final int itemIndex; // Store the item index
  const MyLine({required this.itemIndex, Key? key  }):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: itemIndex % 2 == 0
          ? const Color.fromRGBO(64, 74, 255, 1.0)
          : const Color.fromARGB(255, 151, 221, 124),
      height: 3,
      width: MediaQuery.of(context).size.width,
      //width: 40,
    );
  }
}