import 'dart:convert';
import 'dart:io';

import 'package:assignment4/studentList/take_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../student.dart';

class StudentDetails extends StatefulWidget {
  final String id;

  const StudentDetails({Key? key, required this.id}) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _formKey = GlobalKey<FormState>();
  final studentNameController = TextEditingController();
  final studentIDController = TextEditingController();
  var bytesImage;
  bool updateImage = false;

  @override
  Widget build(BuildContext context) {
    var student =
        Provider.of<StudentModel>(context, listen: false).get(widget.id);

    num grade = 0;
    num summaryGrade = 0;
    if (student != null) {
      //https://api.flutter.dev/flutter/dart-core/Map/forEach.html
      student.grades.forEach((string, value) {
        grade += value;
      });
      summaryGrade = grade / 12.0;
      studentNameController.text = student.studentName;
      studentIDController.text = student.studentID.toString();
      //avatar
      if (!updateImage) {
        if (student.avatar != "") {
          setState(() {
            //https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter
            bytesImage = base64.decode(student.avatar);
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Details"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              "Are you sure want to delete the student?"),
                          content: const Text("This action cannot be undo."),
                          actions: <Widget>[
                            TextButton(
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Provider.of<StudentModel>(context,listen: false).delete(widget.id);
                                  //https://stackoverflow.com/questions/56725216/flutter-how-do-i-pop-two-screens-without-using-named-routing
                                  var nav = Navigator.of(context);
                                  nav.pop();
                                  nav.pop();
                                }),
                            TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ));
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (student != null) {
                var content = """
Student Name : ${student.studentName},
Student ID: ${student.studentID},
Week1: ${student.grades["week1"]},
Week2: ${student.grades["week2"]},
Week3: ${student.grades["week3"]},
Week4: ${student.grades["week4"]},
Week5: ${student.grades["week5"]},
Week6: ${student.grades["week6"]},
Week7: ${student.grades["week7"]},
Week8: ${student.grades["week8"]},
Week9: ${student.grades["week9"]},
Week10: ${student.grades["week10"]},
Week11: ${student.grades["week11"]},
Week12: ${student.grades["week12"]},
Summary Grade: ${grade.toStringAsFixed(2)} / 1200 (${summaryGrade.toStringAsFixed(2)}%).""";
                Share.share(content);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (student != null) {
                  student.studentName = studentNameController.text;
                  student.studentID = int.parse(studentIDController.text);
                  //avatar
                  //https://bezkoder.com/dart-base64-image/
                  if (bytesImage != null) {
                    String base64Encode = base64.encode(bytesImage);
                    student.avatar = base64Encode;
                  }

                  Provider.of<StudentModel>(context, listen: false).update(widget.id, student);
                }
                Navigator.pop(context, "refresh");
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (bytesImage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                //https://api.flutter.dev/flutter/painting/BoxFit-class.html
                //Resize image
                child: Image.memory(bytesImage, width: 128, height: 128, fit: BoxFit.cover),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                //https://api.flutter.dev/flutter/painting/BoxFit-class.html
                //Resize image
                child: Image.asset("images/user.png", width: 128, height: 128, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                      bytesImage = picture.readAsBytesSync();
                      updateImage = true;
                    });
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Take A Picture")),
            ),
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
                            //https://flutter.dev/docs/cookbook/forms/validation#2-add-a-textformfield-with-validation-logic
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
                          decoration: InputDecoration(labelText: "Student ID"),
                          keyboardType: TextInputType.number,
                          controller: studentIDController,
                          inputFormatters: [
                            //https://stackoverflow.com/questions/50123742/how-to-use-inputformatter-on-flutter-textfield
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          validator: (value) {
                            //https://flutter.dev/docs/cookbook/forms/validation#2-add-a-textformfield-with-validation-logic
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter student ID";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Summary Grade:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${grade.toStringAsFixed(2)} / 1200 (${summaryGrade.toStringAsFixed(2)}%)",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  individualSummaryGrade("week1", student!),
                  individualSummaryGrade("week2", student),
                  individualSummaryGrade("week3", student),
                  individualSummaryGrade("week4", student),
                  individualSummaryGrade("week5", student),
                  individualSummaryGrade("week6", student),
                  individualSummaryGrade("week7", student),
                  individualSummaryGrade("week8", student),
                  individualSummaryGrade("week9", student),
                  individualSummaryGrade("week10", student),
                  individualSummaryGrade("week11", student),
                  individualSummaryGrade("week12", student),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column individualSummaryGrade(String week, Student student) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                child: Text("$week: ", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                child: Text(student.grades[week]!.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              )
            ],
          ),
        ),
        //https://api.flutter.dev/flutter/material/Divider-class.html
        const Divider(
          height: 10,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        )
      ],
    );
  }
}
