// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uno/dog.dart';
import 'dbHelper.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Dbhelper _databaseService = Dbhelper();

  Future<List<Dog>> _getDogs() async {
    return await _databaseService.dogs();
  }

  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDogs(),
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
                      print("log---" + entry.name);

                      return Text("${entry.id}---${entry.name}");
                    })),
              ),
              persistentFooterButtons: <Widget>[
                IconButton(icon: Icon(Icons.add), onPressed: _createDialog),
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    }),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _databaseService.deleteAllDog();
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
              body: const Center(child: Text("Bo Wow!!!")),
              persistentFooterButtons: <Widget>[
                IconButton(icon: Icon(Icons.add), onPressed: _createDialog),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {});
                    }),
              ],
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
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Text(
              'Add a dog',
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                    'Position',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
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
          actions: <Widget>[
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
                  Dog tempDog = new Dog(
                      id: int.parse(descriptionController.text),
                      name: tagController.text ?? '',
                      age: 5);
                  _databaseService.insertDog(tempDog);

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('Add'),
              ),
            ),
            const SizedBox(height: 15),
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
                  descriptionController.clear();
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

  getDBResults() {}
}
