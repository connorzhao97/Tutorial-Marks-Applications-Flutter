import 'package:assignment4/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//https://api.flutter.dev/flutter/material/Radio-class.html

enum GradeLevel { HDP, HD, DN, CR, PP, NN }

class GradeLevelHD extends StatefulWidget {
  const GradeLevelHD(
      {Key? key,
      required this.student,
      required this.grade,
      required this.studentModel})
      : super(key: key);
  final Student student;
  final num grade;
  final StudentModel studentModel;

  @override
  _GradeLevelHDState createState() => _GradeLevelHDState();
}

class _GradeLevelHDState extends State<GradeLevelHD> {
  GradeLevel? _gradeLevel = GradeLevel.HDP;

  @override
  Widget build(BuildContext context) {
    if (widget.grade == 100) {
      _gradeLevel = GradeLevel.HDP;
    } else if (widget.grade == 80) {
      _gradeLevel = GradeLevel.HD;
    } else if (widget.grade == 70) {
      _gradeLevel = GradeLevel.DN;
    } else if (widget.grade == 60) {
      _gradeLevel = GradeLevel.CR;
    } else if (widget.grade == 50) {
      _gradeLevel = GradeLevel.PP;
    } else if (widget.grade == 0) {
      _gradeLevel = GradeLevel.NN;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.HDP,
          groupValue: _gradeLevel!,
          label: 'HD+',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 100.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.all(0),
          value: GradeLevel.HD,
          groupValue: _gradeLevel!,
          label: 'HD',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 80.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.DN,
          groupValue: _gradeLevel!,
          label: 'DN',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 70.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.CR,
          groupValue: _gradeLevel!,
          label: 'CR',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 60.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.PP,
          groupValue: _gradeLevel!,
          label: 'PP',
          onChanged: (GradeLevel? value) {
            widget.student.grades[widget.studentModel.selectedWeek] = 50.0;
            Provider.of<StudentModel>(context, listen: false).update(widget.student.id!, widget.student);
          },
        )),
        Expanded(
            child: LabeledRadio(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          value: GradeLevel.NN,
          groupValue: _gradeLevel!,
          label: 'NN',
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
