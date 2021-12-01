import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../student.dart';

class AttendanceCheck extends StatefulWidget {
  const AttendanceCheck(
      {Key? key,
      required this.studentModel,
      required this.student,
      required this.grade})
      : super(key: key);
  final Student student;
  final num grade;
  final StudentModel studentModel;

  @override
  _AttendanceCheckState createState() => _AttendanceCheckState();
}

class _AttendanceCheckState extends State<AttendanceCheck> {
  bool _checkboxSelected = true;

  @override
  Widget build(BuildContext context) {
    if (widget.grade == 100.0) {
      _checkboxSelected = true;
    } else {
      _checkboxSelected = false;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Attendance"),
        Checkbox(
          value: _checkboxSelected,
          activeColor: Colors.green,
          onChanged: (bool? value) {
            if (value != null) {
              if (value) {
                widget.student.grades[widget.studentModel.selectedWeek] = 100.0;
              } else {
                widget.student.grades[widget.studentModel.selectedWeek] = 0.0;
              }
            }
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )
      ],
    );
  }
}
