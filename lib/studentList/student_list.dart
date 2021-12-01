import 'dart:convert';

import 'package:assignment4/studentList/student_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../student.dart';
import 'add_student.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  bool search = false;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Add Student",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddStudent();
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "Share Grades",
            onPressed: () {
              if (studentModel.students.length>0){
                var content = "";
                //https://api.flutter.dev/flutter/dart-core/Map/forEach.html
                studentModel.students.forEach((student) {
                  num grade = 0;
                  num summaryGrade = 0;
                  student.grades.forEach((string, value) {
                    grade += value;
                  });
                  summaryGrade = grade / 12.0;

                  content += """
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
Summary Grade: ${grade.toStringAsFixed(2)} / 1200 (${summaryGrade.toStringAsFixed(2)}%).

""";
                });
                Share.share(content);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No student to share")));
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (studentModel.loading)
              CircularProgressIndicator()
            else
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Student Name or ID",
                                suffixIcon: Icon(Icons.search)),
                            controller: searchController,
                            onChanged: (String value) {
                              if (value.isNotEmpty) {
                                if (value != "") {
                                  setState(() {
                                    studentModel.getSearchedStudent(value);
                                    search = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  search = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (search)
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          var student = studentModel.searchedStudents[index];
                          return Card(
                            child: ListTile(
                              //https://api.flutter.dev/flutter/painting/BoxFit-class.html
                              //https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter
                              //Resize image
                              leading: student.avatar != ""
                                  ? Image.memory(
                                      base64.decode(student.avatar),
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover)
                                  : Image.asset("images/user.png",
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover),
                              title: Text(student.studentName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(student.studentID.toString()),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return StudentDetails(id: student.id!);
                                }));
                                //https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                                //Lose keyboard focus
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                setState(() {
                                  searchController.clear();
                                  search = false;
                                });
                              },
                            ),
                          );
                        },
                        itemCount: studentModel.searchedStudents.length,
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          var student = studentModel.students[index];
                          return Card(
                            child: ListTile(
                              //https://api.flutter.dev/flutter/painting/BoxFit-class.html
                              //https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter
                              //Resize image
                              leading: student.avatar != ""
                                  ? Image.memory(
                                      base64.decode(student.avatar),
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover)
                                  : Image.asset("images/user.png",
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover),
                              title: Text(student.studentName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(student.studentID.toString()),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return StudentDetails(id: student.id!);
                                }));
                                //https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                                //Lose keyboard focus
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                setState(() {
                                  searchController.clear();
                                  search = false;
                                });
                              },
                            ),
                          );
                        },
                        itemCount: studentModel.students.length,
                      ),
                    )
                ],
              ))
          ],
        ),
      ),
    );
  }
}
