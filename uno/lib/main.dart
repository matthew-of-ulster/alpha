// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uno/memo.dart';
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

  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _databaseService.memos(),
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

                      return Card(
                          child: ListTile(
                        title: Text(
                            "${entry.title} --- ${entry.createdDate.toString()}"),
                        subtitle: Text(
                            "${entry.description} --- OffCount:${entry.putOffCount}"),
                      ));
                    })),
              ),
              persistentFooterButtons: <Widget>[
                IconButton(
                    icon: const Icon(Icons.add), onPressed: _createDialog),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    }),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _databaseService.deleteAllMemo();
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
                IconButton(
                    icon: const Icon(Icons.add), onPressed: _createDialog),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    }),
                IconButton(
                    icon: const Icon(Icons.delete),
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
          // padding
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          // dialog title parameter
          title: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Task',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF15161E),
                          )),
                      Text(
                        'Please fill out the form below to continue.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF606A85),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF15161E),
                        size: 24,
                      ),
                      onPressed: () {
                        titleController.clear();
                        descriptionController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),

          // dialog content parameter
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 1.0,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Descritption',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 10),

                  // task tag text field
                  TextFormField(
                    controller: descriptionController,
                    cursorColor: Colors.grey,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                    ),
                  ),

                  //spacing
                  const SizedBox(height: 10),

                  // notes title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 10),

                  // task notes text field
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.grey,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                      ),
                    ),
                  ),
                ],
              ),
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
                  Memo tempMemo = Memo(
                    title: titleController.text ?? '',
                    description: descriptionController.text ?? '',
                  );
                  _databaseService.insertMemo(tempMemo);
                  setState(() {});
                  descriptionController.clear();
                  titleController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ),

            // spacing
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  getDBResults() {}
}
