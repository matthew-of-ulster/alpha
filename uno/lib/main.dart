// ignore_for_file: avoid_print

import 'dart:ui';

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
  final formKey = GlobalKey<FormState>();

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
                        title: Column(
                          children: [
                            Text("Title:${entry.title}"),
                            Text("Description:${entry.description}"),
                            Row(children: [
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent)),
                                child: Text(
                                    "Created:@${entry.createdDate.day}@${entry.createdDate.hour}:${entry.createdDate.minute}\nTarget:@${entry.targetDate.day}@${entry.targetDate.hour}:${entry.targetDate.minute}"),
                              ),
                              Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: Text(
                                      "Put It Off Total\n${entry.putOffCount}")),
                            ]),
                          ],
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  child: Text("Change"),
                                  onPressed: () async {
                                    entry.putOffCount = 19;
                                    await _databaseService.updateMemo(entry);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ))
                          ],
                        ),
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
            padding: const EdgeInsets.only(top: 25),
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
                            color: Colors.black87,
                          )),
                      Text(
                        'Please fill out the form below to continue.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
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
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // spacing
                    const SizedBox(height: 10),
              
                    // task tag text field
                    SizedBox(
                      height: 80,
                      child: TextFormField(
                        controller: titleController,
                        expands: true,
                        maxLines: null,
                        cursorColor: Colors.grey,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Enter Title...',
                          labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 20,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xFFE5E5E5),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xFFE5E5E5),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title for the task';
                          } else {
                            return null;
                          }
                        }
                      ),
                    ),
              
                    //spacing
                    const SizedBox(height: 15),
              
                    // task notes text field
                    TextFormField(
                      controller: descriptionController,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 9,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Enter Description...',
                        labelStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 10,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E5E5),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E5E5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // dialog actions parameter
          actions: <Widget>[
            // add task entry button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
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
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
