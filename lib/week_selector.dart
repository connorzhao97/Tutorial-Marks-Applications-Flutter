import 'package:assignment4/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Flutter native widget and modify by myself
//https://api.flutter.dev/flutter/material/SimpleDialog-class.html

enum Week {
  week1,
  week2,
  week3,
  week4,
  week5,
  week6,
  week7,
  week8,
  week9,
  week10,
  week11,
  week12
}

class WeekSelector extends StatefulWidget {
  const WeekSelector({Key? key}) : super(key: key);

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  Future<void> _askedToShow(StudentModel studentModel) async {
    switch (await showDialog<Week>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Week'),
            children: <Widget>[
              DialogOption(weekText: "week1", week: Week.week1),
              DialogOption(weekText: "week2", week: Week.week2),
              DialogOption(weekText: "week3", week: Week.week3),
              DialogOption(weekText: "week4", week: Week.week4),
              DialogOption(weekText: "week5", week: Week.week5),
              DialogOption(weekText: "week6", week: Week.week6),
              DialogOption(weekText: "week7", week: Week.week7),
              DialogOption(weekText: "week8", week: Week.week8),
              DialogOption(weekText: "week9", week: Week.week9),
              DialogOption(weekText: "week10", week: Week.week10),
              DialogOption(weekText: "week11", week: Week.week11),
              DialogOption(weekText: "week12", week: Week.week12),
            ],
          );
        })) {
      case Week.week1:
        studentModel.updateSelectedWeek("week1");
        break;
      case Week.week2:
        studentModel.updateSelectedWeek("week2");
        break;
      case Week.week3:
        studentModel.updateSelectedWeek("week3");
        break;
      case Week.week4:
        studentModel.updateSelectedWeek("week4");
        break;
      case Week.week5:
        studentModel.updateSelectedWeek("week5");
        break;
      case Week.week6:
        studentModel.updateSelectedWeek("week6");
        break;
      case Week.week7:
        studentModel.updateSelectedWeek("week7");
        break;
      case Week.week8:
        studentModel.updateSelectedWeek("week8");
        break;
      case Week.week9:
        studentModel.updateSelectedWeek("week9");
        break;
      case Week.week10:
        studentModel.updateSelectedWeek("week10");
        break;
      case Week.week11:
        studentModel.updateSelectedWeek("week11");
        break;
      case Week.week12:
        studentModel.updateSelectedWeek("week12");
        break;
      case null:
        break;
    }
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
          child: Text(studentModel.selectedWeek)),
    );
  }
}

class DialogOption extends StatelessWidget {
  const DialogOption({
    Key? key,
    required this.weekText,
    required this.week,
  }) : super(key: key);
  final String weekText;
  final Week week;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: Text(weekText),
      onPressed: () {
        Navigator.pop(context, week);
      },
    );
  }
}
