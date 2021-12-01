import 'package:assignment4/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Flutter native widget and modify by myself
//https://api.flutter.dev/flutter/material/SimpleDialog-class.html

enum MarkingScheme {
  Attendance,
  GradeLevelHD,
  GradeLevelA,
  MultipleCheckpoints,
  ScoreOutOf100
}

class MarkingSchemeSelector extends StatefulWidget {
  const MarkingSchemeSelector({Key? key}) : super(key: key);

  @override
  _MarkingSchemeSelectorState createState() => _MarkingSchemeSelectorState();
}

class _MarkingSchemeSelectorState extends State<MarkingSchemeSelector> {
  Future<void> _askedToShow(StudentModel studentModel) async {
    switch (await showDialog<MarkingScheme>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Marking Scheme'),
            children: <Widget>[
              DialogOption(
                  markingSchemeText: "Attendance",
                  markingScheme: MarkingScheme.Attendance),
              DialogOption(
                  markingSchemeText: "Multiple Checkpoints",
                  markingScheme: MarkingScheme.MultipleCheckpoints),
              DialogOption(
                  markingSchemeText: "Score Out of 100",
                  markingScheme: MarkingScheme.ScoreOutOf100),
              DialogOption(
                  markingSchemeText: "Grade Level (HD)",
                  markingScheme: MarkingScheme.GradeLevelHD),
              DialogOption(
                  markingSchemeText: "Grade Level (A)",
                  markingScheme: MarkingScheme.GradeLevelA)
            ],
          );
        })) {
      case MarkingScheme.Attendance:
        //https://api.flutter.dev/flutter/material/AlertDialog-class.html
        if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] != "Attendance") {
          showChangeDialog(context, studentModel, "Attendance");
        }
        break;
      case MarkingScheme.GradeLevelHD:
        if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] != "Grade Level (HD)") {
          showChangeDialog(context, studentModel, "Grade Level (HD)");
        }
        break;
      case MarkingScheme.GradeLevelA:
        if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] != "Grade Level (A)") {
          showChangeDialog(context, studentModel, "Grade Level (A)");
        }
        break;
      case MarkingScheme.MultipleCheckpoints:
        if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] != "Multiple Checkpoints") {
          showChangeDialog(context, studentModel, "Multiple Checkpoints");
        }
        break;
      case MarkingScheme.ScoreOutOf100:
        if (studentModel.markingSchemes.schemes[studentModel.selectedWeek] != "Score Out of 100") {
          showChangeDialog(context, studentModel, "Score Out of 100");
        }
        break;
      case null:
        break;
    }
  }

  // Show dialog determine change marking scheme or not
  Future<String?> showChangeDialog(BuildContext context, StudentModel studentModel, String scheme) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Alert"),
              content: const Text(
                  "Change to another marking scheme will lose all existing data for the week!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("Change",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      studentModel.updateMarkingScheme(scheme);
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(builder: buildContainer);
  }

  Container buildContainer(BuildContext context, StudentModel studentModel, _) {
    return Container(
        child: ElevatedButton(
      onPressed: () {
        _askedToShow(studentModel);
      },
      child:
          Text(studentModel.markingSchemes.schemes[studentModel.selectedWeek]!),
    ));
  }
}

class DialogOption extends StatelessWidget {
  const DialogOption({
    Key? key,
    required this.markingSchemeText,
    required this.markingScheme,
  }) : super(key: key);
  final String markingSchemeText;
  final MarkingScheme markingScheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: Text(markingSchemeText),
      onPressed: () {
        Navigator.pop(context, markingScheme);
      },
    );
  }
}
