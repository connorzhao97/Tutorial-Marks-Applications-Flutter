import 'dart:convert';

import 'package:assignment4/markingSchemes/grade_level_hd.dart';
import 'package:assignment4/markingSchemes/multiple_checkpoints.dart';
import 'package:assignment4/marking_scheme_selector.dart';
import 'package:assignment4/student.dart';
import 'package:assignment4/studentList/student_list.dart';
import 'package:assignment4/week_selector.dart';
import 'package:assignment4/weekly_summary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'markingSchemes/attendance_check.dart';
import 'markingSchemes/grade_level_a.dart';
import 'markingSchemes/score.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return FullScreenText(text: "Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
                create: (context) => StudentModel(),
                child: MaterialApp(
                  title: 'Tutorial Marks APP',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: Marking(title: 'Marking'),
                ));
          }
          return FullScreenText(text: "Loading");
        });
  }
}

class Marking extends StatefulWidget {
  Marking({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MarkingState createState() => _MarkingState();
}

class _MarkingState extends State<Marking> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.manage_accounts),
              tooltip: "Student List",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StudentList();
                }));
              }),
          IconButton(
              icon: const Icon(Icons.assessment_outlined),
              tooltip: "Summary",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WeeklySummary();
                }));
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (studentModel.loading)
              CircularProgressIndicator()
            else
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Week: ",style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Container(width: 200, child: WeekSelector()),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Marking Scheme: ",style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(width: 200, child: MarkingSchemeSelector()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        var student = studentModel.students[index];
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                  //https://api.flutter.dev/flutter/painting/BoxFit-class.html
                                  //https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter
                                  //Resize image
                                  leading:student.avatar != "" ? Image.memory(base64.decode(student.avatar),width: 48, height: 48, fit: BoxFit.cover): Image.asset("images/user.png",width: 48, height: 48, fit: BoxFit.cover),
                                  title: Text(student.studentName,style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(student.studentID.toString())
                              ),
                              if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] == "Attendance")
                                AttendanceCheck(studentModel: studentModel,student: student,grade: student.grades[studentModel.selectedWeek]!)
                              else if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] == "Multiple Checkpoints")
                                MultipleCheckpoints(studentModel: studentModel,student: student,grade: student.grades[studentModel.selectedWeek]!)
                              else if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] == "Score Out of 100")
                                Score(studentModel: studentModel,student: student,grade: student.grades[studentModel.selectedWeek]!)
                              else if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] == "Grade Level (HD)")
                                GradeLevelHD(studentModel: studentModel,student: student,grade: student.grades[studentModel.selectedWeek]!)
                              else if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] == "Grade Level (A)")
                                GradeLevelA(studentModel: studentModel,student: student,grade: student.grades[studentModel.selectedWeek]!)
                            ],
                          ),
                        );
                      },
                      itemCount: studentModel.students.length,
                    ),
                  ),
                ],
              ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [Expanded(child: Center(child: Text(text)))]));
  }
}


