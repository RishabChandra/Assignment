import 'dart:io';

import 'package:Assignment/helpers/databaseHelper.dart';
import 'package:Assignment/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  static const routeName = "/form";
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController forName = TextEditingController();
  TextEditingController forNumber = TextEditingController();
  TextEditingController forAmount = TextEditingController();
  var valid;
  var selectedVal1;
  var selectedVal2;
  DateTime pickedDate;
  final dbHelper = DatabaseHelper.instance;
  File _finalImage;
  final _form = GlobalKey<FormState>();
  final List<Map<String, dynamic>> formList = [];
  List<Map<String, dynamic>> list = [];

  var productType;
  var amountType;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate() async {
    pickedDate = await showDatePicker(
      initialDate: selectedDate,
      context: context,
      firstDate: DateTime(2020, 1, 10),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
      print(selectedDate.toString());
    }
    setState(() {});
  }

  var formatter = DateFormat('EEE, dd/MM/y');

  Future<void> imgPicker(bool isCam) async {
    if (isCam) {
      final pickedImage = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _finalImage = pickedImage;
      });
    } else {
      final pickedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );

      setState(() {
        _finalImage = pickedImage;
      });
    }
  }

  void _trySubmitting() {
    valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    formList.add({
      "name": forName.text,
      "mobile": forNumber.text,
      "amount": forAmount.text,
      "productType": productType,
      "amountType": amountType,
      "date": selectedDate.toString(),
      "image": _finalImage.toString()
    });
    _insert();
    _query();
    print(formList.toString());
    _form.currentState.reset();
    selectedVal1 = null;
    selectedVal2 = null;
    pickedDate = null;
    _finalImage = null;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Form submitted successfully"),
            actions: [
              FlatButton(
                child: Text("ok"),
                onPressed: () {
                  Navigator.of(context).pushNamed(HomeScreen.routeName);
                },
              )
            ],
          );
        });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    forName.clear();
    forNumber.clear();
    forAmount.clear();
  }

  void _insert() async {
    String _stringimage =
        _finalImage.toString().substring(8, _finalImage.toString().length - 1);
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.name: forName.text,
      DatabaseHelper.mobile: forNumber.text,
      DatabaseHelper.amount: forAmount.text,
      DatabaseHelper.amountType: selectedVal1,
      DatabaseHelper.productType: selectedVal2,
      DatabaseHelper.date: selectedDate.toIso8601String(),
      DatabaseHelper.image: _stringimage
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _runquery() async {
    final allRows = await dbHelper.fetch();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    allRows.forEach((row) => list = [
          {"name": row['name']}
        ]);
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _form,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 300,
                child: TextFormField(
                  controller: forName,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "This cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Name"),
                ),
              ),
            ),
            Container(
              width: 300,
              child: TextFormField(
                controller: forNumber,
                validator: (val) {
                  if (val.isEmpty) {
                    return "This cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Mobile Number"),
              ),
            ),
            Container(
              width: 300,
              child: TextFormField(
                controller: forAmount,
                validator: (val) {
                  if (val.isEmpty) {
                    return "This cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Amount"),
              ),
            ),
            Divider(),
            Container(
                width: 300,
                child: Column(
                  children: [
                    Text("Amount type"),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: "cash",
                          groupValue: selectedVal1,
                          onChanged: (val) {
                            setState(() {
                              selectedVal1 = val;
                            });
                            amountType = val;

                            print(amountType);
                          },
                        ),
                        Text("Cash"),
                        Radio(
                            activeColor: Colors.black,
                            value: "online",
                            groupValue: selectedVal1,
                            onChanged: (val) {
                              setState(() {
                                selectedVal1 = val;
                              });
                              amountType = val;
                              print(amountType);
                            }),
                        Text("Online"),
                        Radio(
                            activeColor: Colors.black,
                            value: "gpay",
                            groupValue: selectedVal1,
                            onChanged: (val) {
                              setState(() {
                                selectedVal1 = val;
                              });
                              amountType = val;
                              print(amountType);
                            }),
                        Text("Gpay"),
                      ],
                    )
                  ],
                )),
            Divider(),
            Container(
              width: 300,
              child: Column(
                children: [
                  Text("Product Type"),
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.black,
                        toggleable: true,
                        value: "product",
                        groupValue: selectedVal2,
                        onChanged: (val) {
                          setState(() {
                            selectedVal2 = val;
                          });
                          productType = val;
                          print(productType);
                        },
                      ),
                      Text("Product"),
                      SizedBox(
                        width: 60,
                      ),
                      Radio(
                        activeColor: Colors.black,
                        value: "service",
                        groupValue: selectedVal2,
                        onChanged: (val) {
                          setState(() {
                            selectedVal2 = val;
                          });
                          productType = val;
                          print(productType);
                        },
                      ),
                      Text("Service")
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            Container(
                width: 300,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate();
                      },
                    ),
                    Text("Date"),
                    Text(pickedDate != null
                        ? formatter.format(pickedDate).toString()
                        : "Nor selected")
                  ],
                )),
            Container(
              width: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.photo,
                        ),
                        onPressed: () {
                          imgPicker(false);
                        },
                      ),
                      Text("Pick an image from gallery")
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.camera,
                        ),
                        onPressed: () {
                          imgPicker(true);
                        },
                      ),
                      Text("Pick an image from camera")
                    ],
                  ),
                  if (_finalImage != null)
                    CircleAvatar(
                      backgroundImage: FileImage(_finalImage),
                      radius: 50,
                    )
                ],
              ),
            ),
            Divider(),
            Container(
              child: CupertinoButton(
                child: Text("Submit"),
                onPressed: () {
                  _trySubmitting();
                },
              ),
            ),
            Divider(),
          ],
        ),
      )),
    );
  }
}
