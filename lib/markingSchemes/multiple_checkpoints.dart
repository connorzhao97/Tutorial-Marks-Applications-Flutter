import 'dart:core';

import 'package:assignment4/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleCheckpoints extends StatefulWidget {
  const MultipleCheckpoints(
      {Key? key,
      required this.student,
      required this.grade,
      required this.studentModel})
      : super(key: key);
  final Student student;
  final num grade;
  final StudentModel studentModel;

  @override
  _MultipleCheckpointsState createState() => _MultipleCheckpointsState();
}

class _MultipleCheckpointsState extends State<MultipleCheckpoints> {
  bool _checkpoint1 = true;
  bool _checkpoint2 = true;

  @override
  Widget build(BuildContext context) {
    if (widget.grade == 100) {
      _checkpoint1 = true;
      _checkpoint2 = true;
    } else if (widget.grade == 50) {
      _checkpoint1 = true;
      _checkpoint2 = false;
    } else if (widget.grade == 0) {
      _checkpoint1 = false;
      _checkpoint2 = false;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Checkpoint 1"),
        Checkbox(
            value: _checkpoint1,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              if (value != null) {
                if (value) {
                  widget.student.grades[widget.studentModel.selectedWeek] = 50.0;
                } else {
                  widget.student.grades[widget.studentModel.selectedWeek] = 0.0;
                }
                Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
              }
            }),
        if (widget.grade == 50 || widget.grade == 100)
          Text("Checkpoint 2")
        else if (widget.grade == 0)
          Text("Checkpoint 2", style: TextStyle(color: Colors.grey)),
        if (widget.grade == 50 || widget.grade == 100)
          Checkbox(
              value: _checkpoint2,
              activeColor: Colors.green,
              onChanged: (bool? value) {
                if (value != null) {
                  if (value) {
                    widget.student.grades[widget.studentModel.selectedWeek] = 100.0;
                  } else {
                    widget.student.grades[widget.studentModel.selectedWeek] = 50.0;
                  }
                  Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
                }
              })
        else if (widget.grade == 0)
          Checkbox(
              value: false,
              activeColor: Colors.green,
              onChanged: null)
      ],
    );
  }
}
