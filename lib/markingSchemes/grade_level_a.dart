import 'package:assignment4/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//https://api.flutter.dev/flutter/material/Radio-class.html
enum GradeLevel { A, B, C, D, F }

class GradeLevelA extends StatefulWidget {
  const GradeLevelA(
      {Key? key,
      required this.student,
      required this.grade,
      required this.studentModel})
      : super(key: key);
  final Student student;
  final num grade;
  final StudentModel studentModel;

  @override
  _GradeLevelAState createState() => _GradeLevelAState();
}

class _GradeLevelAState extends State<GradeLevelA> {
  GradeLevel? _gradeLevel = GradeLevel.A;

  @override
  Widget build(BuildContext context) {
    if (widget.grade == 100) {
      _gradeLevel = GradeLevel.A;
    } else if (widget.grade == 80) {
      _gradeLevel = GradeLevel.B;
    } else if (widget.grade == 70) {
      _gradeLevel = GradeLevel.C;
    } else if (widget.grade == 60) {
      _gradeLevel = GradeLevel.D;
    } else if (widget.grade == 0) {
      _gradeLevel = GradeLevel.F;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.A,
          groupValue: _gradeLevel!,
          label: 'A',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 100.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.B,
          groupValue: _gradeLevel!,
          label: 'B',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 80.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.C,
          groupValue: _gradeLevel!,
          label: 'C',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 70.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.D,
          groupValue: _gradeLevel!,
          label: 'D',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 60.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.F,
          groupValue: _gradeLevel!,
          label: 'F',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 0.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
      ],
    );
  }
}

//https://api.flutter.dev/flutter/material/RadioListTile-class.html#material.RadioListTile.3
// The original radio button have large gap between radio button and text, so use the custom radio button
class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final GradeLevel groupValue;
  final GradeLevel value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 24,
              child: Radio<GradeLevel>(
                groupValue: groupValue,
                value: value,
                onChanged: (GradeLevel? newValue) {
                  onChanged(newValue);
                },
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
