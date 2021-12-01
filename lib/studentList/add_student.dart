import 'dart:convert';
import 'dart:io';

import 'package:assignment4/student.dart';
import 'package:assignment4/studentList/take_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final studentNameController = TextEditingController();
  final studentIDController = TextEditingController();
  var bytesImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add New Student")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (bytesImage == null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Image.asset("images/user.png", width: 128,height: 128, fit: BoxFit.fitWidth),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Image.memory(bytesImage, width: 128,height: 128, fit: BoxFit.fitWidth),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: ElevatedButton.icon(
                    onPressed: () async {
                      final cameras = await availableCameras();
                      // Get a specific camera from the list of available cameras.
                      final firstCamera = cameras.first;

                      File picture = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TakePictureScreen(camera: firstCamera);
                      }));
                      setState(() {
                        //https://bezkoder.com/dart-base64-image/
                        bytesImage = picture.readAsBytesSync();
                      });
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Take A Picture")),
              ),
              //https://flutter.dev/docs/cookbook/forms/validation
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Student Name"),
                            keyboardType: TextInputType.name,
                            controller: studentNameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter student name";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: "Student ID"),
                            keyboardType: TextInputType.number,
                            controller: studentIDController,
                            inputFormatters: [
                              //https://stackoverflow.com/questions/50123742/how-to-use-inputformatter-on-flutter-textfield
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter student ID";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    var studentName = studentNameController.text;
                                    var studentID = int.parse(studentIDController.text);
                                    var grades = Map<String, num>();
                                    grades["week1"] = 0.0;
                                    grades["week2"] = 0.0;
                                    grades["week3"] = 0.0;
                                    grades["week4"] = 0.0;
                                    grades["week5"] = 0.0;
                                    grades["week6"] = 0.0;
                                    grades["week7"] = 0.0;
                                    grades["week8"] = 0.0;
                                    grades["week9"] = 0.0;
                                    grades["week10"] = 0.0;
                                    grades["week11"] = 0.0;
                                    grades["week12"] = 0.0;
                                    var student = Student(
                                        studentName: studentName,
                                        studentID: studentID,
                                        grades: grades,
                                        avatar: "");

                                    //avatar
                                    //https://bezkoder.com/dart-base64-image/
                                    if(bytesImage != null){
                                      String base64Encode = base64.encode(bytesImage);
                                      student.avatar = base64Encode;
                                    }
                                    Provider.of<StudentModel>(context,listen: false).add(student);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text("Add")),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
