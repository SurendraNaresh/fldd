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
  final List<String> rightItems = ['Coffee', 'News', 'Port', 'Time', 'Tone'];
  late List<String> randomizedRightItems;
  String droppedItem = '';
  late int dItem;
  @override
  void initState() {
    super.initState();
    randomizedRightItems = List.from(rightItems)..shuffle(Random());
    dItem = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
              ),
              itemCount: leftItems.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    DraggableItem(label: leftItems[i]),
                    const SizedBox(width: 10),
                    DragTargetItem(
                      onAccept: (data) {
                        setState(() {
                          dItem = leftItems.indexOf($data) ?? 0;
                          print('Dragged: $data <==> index: $dItem ');
                          droppedItem = '$data -> ${randomizedRightItems[i]}';
                          print(droppedItem);
                        });
                      },
                      dropLabel: randomizedRightItems[i],
                    ),
                    const Divider(thickness: 2, color: Colors.grey), // Grid line
                  ],
                );
              },
            ),
            const Divider(thickness: 2, color: Colors.grey), // Optional bottom line
          ],
        ),
      ),
    );
  }
}

class DraggableItem extends StatelessWidget {
  final String label;

  const DraggableItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: label,
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
      feedback: Material(
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(20),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        padding: const EdgeInsets.all(20),
        child: const Text('Dragging...', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class DragTargetItem extends StatelessWidget {
  final Function(String) onAccept;
  final String dropLabel;

  const DragTargetItem({Key? key, required this.onAccept, required this.dropLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: onAccept,
      onWillAccept: (data) => true,
      builder: (context, acceptedItems, rejectedItems) {
        return Container(
          width: 100,
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: acceptedItems.isEmpty ? Colors.green : Colors.orange,
          alignment: Alignment.center,
          child: Text(
            dropLabel.isNotEmpty ? dropLabel : 'Drop Here',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
