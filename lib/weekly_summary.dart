import 'package:assignment4/student.dart';
import 'package:assignment4/week_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeeklySummary extends StatefulWidget {
  const WeeklySummary({Key? key}) : super(key: key);

  @override
  _WeeklySummaryState createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    // Calculate the summary grade
    num summaryGrade = 0;
    if (studentModel.students.length!=0){
      //https://api.flutter.dev/flutter/dart-core/Map/forEach.html
      studentModel.students.forEach((student) {
        summaryGrade += student.grades[studentModel.selectedWeek]!;
      });
      summaryGrade = summaryGrade / studentModel.students.length;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Summary"),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Summary Grade",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(summaryGrade.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(width: 200, child: WeekSelector()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          studentModel.markingSchemes
                              .schemes[studentModel.selectedWeek]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (_, index) {
                        var student = studentModel.students[index];
                        return Card(
                          child: ListTile(
                            title: Text(student.studentName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(student.studentID.toString()),
                            trailing: Text(
                              student.grades[studentModel.selectedWeek]!
                                  .toStringAsFixed(2),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      },
                      itemCount: studentModel.students.length,
                    ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
