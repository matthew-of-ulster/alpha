// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uno/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future getDBResults() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

/*
  await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
        title: 'todo: another task',
        content: 'We can now write queries and define our own tables.',
      ));
      */
  List<TodoItem> allItems = await database.select(database.todoItems).get();

  return allItems;
}

void addDBResult(String title) async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  if (title.length < 6) {
    title = title + "aaaaaa";
  }

  await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
        title: title,
        content: 'null content',
      ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int _counter = 0;

/*
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + 2;
    });
  }
*/

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times!!!:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDialog,
        tooltip: 'Open Dialog',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
=======
    return FutureBuilder(
        future: getDBResults(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: Center(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) {
                      final entry = snapshot.data[index];

                      return Text((index + 1).toString() + "---" + entry.title);
                    })),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _createDialog,
                tooltip: 'Open Dialog',
                child: const Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: Center(child: Text("No Entries!!!")),
              floatingActionButton: FloatingActionButton(
                onPressed: _createDialog,
                tooltip: 'Open Dialog',
                child: const Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          }
        });
>>>>>>> 11ea30bc4e78d2eb37404ed66eba814fc044eca9
  }

  _createDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 100),
          title: const Text('Dialog Title'),
<<<<<<< HEAD
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Notes',
                  ),
                ),
              ],
=======
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter text to add',
>>>>>>> 11ea30bc4e78d2eb37404ed66eba814fc044eca9
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                addDBResult(taskController.text);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
