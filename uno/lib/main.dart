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
    title = "${title}aaaaaa";
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
  }

  _createDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 100),
          title: const Text('Dialog Title'),
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
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                addDBResult(tagController.text);
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
