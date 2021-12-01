import 'package:assignment4/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Score extends StatefulWidget {
  const Score(
      {Key? key,
      required this.student,
      required this.grade,
      required this.studentModel})
      : super(key: key);
  final Student student;
  final num grade;
  final StudentModel studentModel;

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  final _formKey = GlobalKey<FormState>();
  final scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    scoreController.text = widget.student.grades[widget.studentModel.selectedWeek].toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            "${widget.student.grades[widget.studentModel.selectedWeek].toString()} / 100.0",
            style: TextStyle(fontWeight: FontWeight.bold)),
        ElevatedButton(
            onPressed: () {
              //https://api.flutter.dev/flutter/material/AlertDialog-class.html#material.AlertDialog.2
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text("Student's Score"),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Score"),
                            keyboardType: TextInputType.number,
                            controller: scoreController,
                            validator: (value) {
                              //https://flutter.dev/docs/cookbook/forms/validation#2-add-a-textformfield-with-validation-logic
                              if (value == null || value.isEmpty) {
                                return "Please enter score";
                              } else if (double.parse(value) < 0.0 ||
                                  double.parse(value) > 100.0) {
                                return "Score out of range";
                              }
                              return null;
                            },
                            inputFormatters: [
                              //https://stackoverflow.com/questions/50123742/how-to-use-inputformatter-on-flutter-textfield
                              FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context, 'Cancel');
                                widget.student.grades[widget.studentModel.selectedWeek] = double.parse(scoreController.text);
                                Provider.of<StudentModel>(context,listen: false).update(widget.student.id!, widget.student);
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ));
            },
            child: Text("Update"))
      ],
    );
  }
}
