import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
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
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late List<ItemModel> items;
  late List<ItemModel> items2;
  int score = 0;
  int startLength = 0;
  bool gameOver = false;
  double adjTop = 40;

  get children => null;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    score = 0;
    adjTop = 20;
    gameOver = false;
    // items = [
    //   ItemModel(icon: Icons.search, name: 'Google', value: "google"), // Search icon
    //   ItemModel(icon: Icons.account_circle, name: 'Facebook', value: "facebook"),
    //   ItemModel(icon: Icons.message, name: 'Twitter', value: "twitter"),
    //   // ItemModel(icon: Icons.link, name: 'Linked In', value: "linkedin"),
    //   // ItemModel(icon: Icons.camera, name: 'Instagram', value: "instagram"),
    //   // ItemModel(icon: Icons.videocam, name: 'Youtube', value: "youtube"),
    //   // ItemModel(icon: Icons.chat, name: 'Snapchat', value: "snapchat"),
    //   // ItemModel(icon: Icons.help, name: 'Quora', value: "quora"),
    //   // ItemModel(icon: Icons.home, name: 'Airbnb', value: "airbnb"),
    //   // ItemModel(icon: Icons.reddit, name: 'Reddit', value: "reddit"),
    //   // ItemModel(icon: Icons.computer, name: 'Linux', value: "linux"),
    //   //ItemModel(icon: Icons.windows, name: 'Windows', value: "windows"),
    // ];
    items = [
      ItemModel(icon: FontAwesomeIcons.google, name: 'Google', value: "google"),
      ItemModel(
          icon: FontAwesomeIcons.facebook, name: 'Facebook', value: "facebook"),
      ItemModel(
          icon: FontAwesomeIcons.twitter, name: 'Twitter', value: "twitter"),
      ItemModel(icon: FontAwesomeIcons.linkedin,
          name: 'Linked In',
          value: "linkedin"),
      ItemModel(icon: FontAwesomeIcons.instagram,
          name: 'Instagram',
          value: "instagram"),
      ItemModel(
          icon: FontAwesomeIcons.youtube, name: 'Youtube', value: "youtube"),
      ItemModel(
          icon: FontAwesomeIcons.snapchat, name: 'Snapchat', value: "snapchat"),
      ItemModel(icon: FontAwesomeIcons.quora, name: 'Quora', value: "quora"),
      ItemModel(icon: FontAwesomeIcons.airbnb, name: 'Airbnb', value: "airbnb"),
      ItemModel(icon: FontAwesomeIcons.reddit, name: 'Reddit', value: "reddit"),
      ItemModel(icon: FontAwesomeIcons.linux, name: 'Linux', value: "linux"),
      ItemModel(
          icon: FontAwesomeIcons.windows, name: 'Windows', value: "windows"),
    ];
    items.shuffle();
    items2 = List<ItemModel>.from(items);
    items2.shuffle();
    startLength = items.length;
  }

//  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag & Drop Game'),
      ),
      body: Center(
        child: Column(
          children: [
            // Display the score
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Score: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 223, 130),
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    TextSpan(
                      text: "$score",
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Use Flexible instead of Expanded to avoid conflicts with the scroll view
            Flexible(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(), // Allow scrolling
                itemCount: items.length * 3, // Each item spans 3 columns
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  mainAxisSpacing: 0, // Vertical spacing removed, we'll handle this with borders
                  crossAxisSpacing: 0, // Horizontal spacing between items
                  childAspectRatio: 6.4, // Control height/width ratio

                ),
                itemBuilder: (context, index) {
                  final adjustedIndex = index ~/ 3; // Determine item for grouping
                  final columnPosition = index % 3; // Determine column (0=Icon, 1=Spacer, 2=Text)
                  // Wrap each item with a Container that adds a border (top and bottom)
                  return Container(
                    //height: 18,
                    //width: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2, color: Colors.greenAccent), // Top border (grid line)
                        //bottom: BorderSide(width: 5, color: Colors.greenAccent), // Bottom border (grid line)
                      ),
                    ),
                    child: _buildGridItem(adjustedIndex, columnPosition), // Build the grid item
                  );
                },
              ),
            ),

            // Game Over text when items2 are empty
            Visibility(
              visible: items2.isEmpty,
              child: const Text(
                "Game Over",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Start New Game button
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {
                  initGame();
                  setState(() {});
                },
                child: const Text(
                  "Start New Game",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper function to build each item in the grid
  Widget _buildGridItem(int adjustedIndex, int columnPosition) {
    if (columnPosition == 0) {
      // Column 1: Build the icon (Draggable Item)
      return _buildDraggableItem(items[adjustedIndex]);
    } else if (columnPosition == 1) {
      // Column 2: Spacer taking 60% of the grid width
      return const SizedBox(width: 20);
    } else {
      // Column 3: Build the iconText (DragTarget Item)
      return _buildDragTargetItem(items2[adjustedIndex]);
    }
  }

  Widget _buildDraggableItem(ItemModel item) {
    return Draggable<ItemModel>(
      data: item,
      childWhenDragging: Icon(
        item.icon,
        size: 18,
        color: Colors.grey,
      ),
      feedback: Icon(
        item.icon,
        size: 18,
        color: Colors.red,
      ),
      child: Icon(
        item.icon,
        size: 18,
        color: const Color.fromARGB(255, 204, 125, 7),
      ),
    );
  }

  Widget _buildDragTargetItem(ItemModel item) {
    return DragTarget<ItemModel>(
      onAcceptWithDetails: (itemDrag) {
        if (item.value == itemDrag.data.value) {
          setState(() {
            items.remove(itemDrag.data);
            items2.remove(item);
            item.accepting = false;
            score += 10;
          });
        } else {
          setState(() {
            score -= 5;
            item.accepting = false;
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
            : const Color.fromARGB(255, 11, 154, 206),
        height: 10,
        width: 20,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8.0),
        child: Text(
          item.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
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
class MyDecoLine extends BoxDecoration {
  final int itemIndex;
  const MyDecoLine({required this.itemIndex }) ;
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
}

class ItemModel {
  final String name;
  final String value;
  final IconData icon;
  // ignore: prefer_typing_uninitialized_variables
  var accepting;
  ItemModel(
      {required this.icon,
      required this.name,
      required this.value,
      this.accepting = false});
}
