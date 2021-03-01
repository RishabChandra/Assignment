import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Assignment/helpers/databaseHelper.dart';
import 'package:Assignment/screens/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "first";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime from;
  DateTime to;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> list1 = [];
  List<Map<String, dynamic>> toExport = [];

  List<Map<String, dynamic>> list = [];
  void _query() async {
    list1 = [];
    list = [];
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) {
      Map<String, dynamic> temp = row;
      String image = temp['image'];
      list1.add(temp);
      list.add(temp);
    });
    print(list1);
    setState(() {});
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _doThis() {
    list1.forEach((val) {
      DateTime tempVar = DateTime.parse(val['date']);
      if (tempVar.isAfter(from) && tempVar.isBefore(to)) {
        toExport.add(val);
      }
      // print(toExport);
      _createCSV();
    });
  }

  _createCSV() async {
    List temp;
    List<List<dynamic>> finalListofLists = [];
    toExport.forEach((val) {
      temp = [
        val["name"],
        val['mobile'],
        val["amount"],
        val["date"],
        val['amountType'],
        val["productType"],
        val["image"]
      ];
      finalListofLists.add(temp);
    });
    // print(yourListofLists);
    String csv = const ListToCsvConverter().convert(finalListofLists);
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/myCsvFile5.csv";
    File file = File(pathOfTheFileToWrite);
    file.writeAsString(csv);
    print("CSV created at " + pathOfTheFileToWrite.toString());
    from = null;
    to = null;
  }

  var formatter = DateFormat('EEE, dd/MM/y');
  _openCsv() async {
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/myCsvFile5.csv";
    final input = File(pathOfTheFileToWrite).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    print("CSV path: " + pathOfTheFileToWrite.toString());
    print("From csv " + fields.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: FloatingActionButton(
                    heroTag: "1",
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      _query();
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: FloatingActionButton(
                    heroTag: "2",
                    child: Text("Get"),
                    onPressed: () {
                      _query();
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: FloatingActionButton(
                    heroTag: "3",
                    child: Icon(Icons.delete),
                    onPressed: () {
                      _delete();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: FloatingActionButton(
                    heroTag: "11",
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(FormScreen.routeName);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: FloatingActionButton(
                    heroTag: "22",
                    child: Text("Export"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 6, sigmaY: 6),
                                      child: AlertDialog(
                                        title: Text('Export'),
                                        content: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("From"),
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.calendar_today),
                                                  onPressed: () async {
                                                    from = await showDatePicker(
                                                        context: context,
                                                        firstDate: DateTime(
                                                            2020, 1, 1),
                                                        lastDate:
                                                            DateTime.now(),
                                                        initialDate:
                                                            DateTime.now());
                                                    setState(() {});
                                                  },
                                                ),
                                                Text(from != null
                                                    ? formatter
                                                        .format(from)
                                                        .toString()
                                                    : "Not selected")
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("To"),
                                                IconButton(
                                                    icon: Icon(
                                                        Icons.calendar_today),
                                                    onPressed: () async {
                                                      to = await showDatePicker(
                                                          context: context,
                                                          firstDate: DateTime(
                                                              2020, 1, 1),
                                                          lastDate:
                                                              DateTime.now(),
                                                          initialDate:
                                                              DateTime.now());
                                                      setState(() {});
                                                    }),
                                                Text(to != null
                                                    ? formatter
                                                        .format(to)
                                                        .toString()
                                                    : "Not selected"),
                                              ],
                                            )
                                          ],
                                        ),
                                        actions: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              _doThis();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Submit"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: FloatingActionButton(
                    heroTag: "33",
                    child: Text("GetCSV"),
                    onPressed: () {
                      _openCsv();
                    },
                  ),
                ),
              ],
            ),
          ])),
      appBar: AppBar(
        title: Text("Assignment"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, i) {
          return ListTile(
              trailing: Text("₹ " + list[i]['amount'].toString()),
              leading: CircleAvatar(
                backgroundImage: FileImage(File(list[i]['image'])),
              ),
              title:
                  Text(list[i]['name'] + " - " + list[i]["mobile"].toString()),
              // subtitle: Text(list[i]['date'].toString()),
              subtitle: Text(formatter
                  .format(DateTime.parse(list[i]['date'].toString()))));
        },
      ),
    );
  }
}
