import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Drag and Drop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class ItemModel {
  final IconData icon;
  final String name;
  final String value;
  bool accepting = false;
  ItemModel({required this.icon, required this.name, required this.value});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<ItemModel> items;
  late List<ItemModel> items2;
  int score = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    score = 0;
    gameOver = false;
    items = [
      ItemModel(icon: FontAwesomeIcons.google, name: 'Google', value: "google"),
      ItemModel(icon: FontAwesomeIcons.facebook, name: 'Facebook', value: "facebook"),
      ItemModel(icon: FontAwesomeIcons.twitter, name: 'Twitter', value: "twitter"),
      ItemModel(icon: FontAwesomeIcons.linkedin, name: 'Linked In', value: "linkedin"),
      ItemModel(icon: FontAwesomeIcons.instagram, name: 'Instagram', value: "instagram"),
      ItemModel(icon: FontAwesomeIcons.youtube, name: 'Youtube', value: "youtube"),
      ItemModel(icon: FontAwesomeIcons.snapchat, name: 'Snapchat', value: "snapchat"),
      ItemModel(icon: FontAwesomeIcons.quora, name: 'Quora', value: "quora"),
      ItemModel(icon: FontAwesomeIcons.airbnb, name: 'Airbnb', value: "airbnb"),
      ItemModel(icon: FontAwesomeIcons.reddit, name: 'Reddit', value: "reddit"),
      ItemModel(icon: FontAwesomeIcons.linux, name: 'Linux', value: "linux"),
      ItemModel(icon: FontAwesomeIcons.windows, name: 'Windows', value: "windows"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final combinedItems = [...items.map((item) => {'item': item, 'isDraggable': true}),
      ...items2.map((item) => {'item': item, 'isDraggable': false})];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag & Drop Game'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text.rich(TextSpan(
                children: [
                  const TextSpan(
                      text: "Score: ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 138, 223, 130),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0)),
                  TextSpan(
                      text: "$score",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0))
                ],
              )),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: combinedItems.length,
                      itemBuilder: (context, index) {
                        final item = combinedItems[index]['item'] as ItemModel;
                        final isDraggable = combinedItems[index]['isDraggable'] as bool;

                        if (isDraggable) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Draggable<ItemModel>(
                              data: item,
                              childWhenDragging: Icon(item.icon, size: 24, color: Colors.grey),
                              feedback: Icon(item.icon, size: 24, color: Colors.red),
                              child: Icon(item.icon, size: 24, color: const Color.fromARGB(255, 204, 125, 7)),
                            ),
                          );
                        } else {
                          return DragTarget<ItemModel>(
                            onAcceptWithDetails: (itemDrag) {
                              if (item.value == itemDrag.data.value) {
                                setState(() {
                                  items.remove(itemDrag);
                                  items2.remove(item);
                                  score += 10;
                                });
                              } else {
                                setState(() {
                                  score -= 5;
                                });
                              }
                            },
                            onWillAcceptWithDetails: (itemDrag) {
                              setState(() {
                                item.accepting = true;
                              });
                              return true;
                            },
                            onLeave: (itemDrag) {
                              setState(() {
                                item.accepting = false;
                              });
                            },
                            builder: (context, acceptedItems, rejectedItems) => Container(
                              color: item.accepting
                                  ? const Color.fromRGBO(255, 215, 64, 1)
                                  : const Color.fromARGB(255, 124, 221, 213),
                              height: 24,
                              width: 90,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(8.0),
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: items2.isEmpty,
                child: const Text(
                  "Game Over",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    initGame();
                    setState(() {});
                  },
                  child: const Text(
                    "Start New Game",
                    style: TextStyle(fontSize: 20, backgroundColor: Colors.white, color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDecoLine extends StatelessWidget {
  final int itemIndex;
  const MyDecoLine({required this.itemIndex, Key? key}) : super(key: key);

  BoxDecoration get decoration => BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: itemIndex % 2 == 0
            ? const Color.fromRGBO(64, 74, 255, 1.0)
            : const Color.fromARGB(255, 151, 221, 124),
        width: 3,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    if (context?.size != 0 ) {
      return Container(
        // ...
      );
    } else {
      // Ensure a Widget is always returned, even in the else branch
      return Text('No data available');
    }
  }
}

// class ItemModel {
//   final String name;
//   final String value;
//   final IconData icon;
//   // ignore: prefer_typing_uninitialized_variables
//   var accepting;
//   ItemModel(
//       {required this.icon,
//       required this.name,
//       required this.value,
//       this.accepting = false});
// }
