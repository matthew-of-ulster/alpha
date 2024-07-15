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
  List<TodoItem> allItems = await database.select(database.todoItems).get();

  return allItems;
}

void addDBResult(String title) async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  if (title.length < 6) {
    title = "${title}:(was too short)";
  }

  await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
        title: title,
        content: 'null content',
      ));
}

void clearDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase().delete(AppDatabase().todoItems);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tagController = TextEditingController();
  TextEditingController notesController = TextEditingController();

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

                      return Text("${index + 1}---${entry.title}");
                    })),
              ),
              persistentFooterButtons: <Widget>[
                IconButton(icon: Icon(Icons.add), onPressed: _createDialog),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      clearDB();
                      setState(() {});
                    }),
              ], // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: const Center(child: Text("No Entries!!!")),
              // This trailing comma makes auto-formatting nicer for build methods.
            );
          }
        });
  }

  _createDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          //padding
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          // dialog title parameter    
          title: const Padding(

            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Text('Add a task',),
          ),

          // dialog content parameter
          content: SizedBox(

            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter a title',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(height: 10),

                // task tag text field
                TextFormField(
                  controller: tagController,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add some notes',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                // spacing
                const SizedBox(height: 10),

                // task notes text field
                TextFormField(
                  controller: notesController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          // dialog actions parameter
          actions: <Widget>[

            // add task entry button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(350, 60),
                ),
                onPressed: () {
                  addDBResult(tagController.text);
                  tagController.clear();
                  notesController.clear();
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ),
            
            // spacing
            const SizedBox(height: 15),

            // close dialog button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(350, 60),
                ),
                onPressed: () {
                  tagController.clear();
                  notesController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ),
          ],
        );
      },
    );
  }
}
