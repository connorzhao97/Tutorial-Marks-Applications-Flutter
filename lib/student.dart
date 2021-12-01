import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Student {
  String? id;
  String studentName;
  int studentID;
  String avatar;

  //https://dart.dev/guides/language/language-tour#maps
  var grades = Map<String, num>();

  Student(
      {required this.studentName,
      required this.studentID,
      required this.grades,
      required this.avatar});

  Student.fromJson(QueryDocumentSnapshot<Object?> json)
      : studentName = json['studentName'],
        studentID = json['studentID'],
        avatar = json['avatar'],
        grades = Map<String, num>.from(json['grades']); //https://stackoverflow.com/questions/57845333/dart-how-internallinkedhashmapstring-dynamic-convert-to-mapstring-dynami

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'studentID': studentID,
        'grades': grades,
        'avatar': avatar
      };
}

class MarkingScheme {
  String? id;

  //https://dart.dev/guides/language/language-tour#maps
  var schemes = Map<String, String>();

  MarkingScheme({required this.schemes});

  MarkingScheme.fromJson(QueryDocumentSnapshot<Object?> json)
      : schemes = Map<String, String>.from(json['schemes']);

  Map<String, dynamic> toJson() => {
        'schemes': schemes,
      };
}

class StudentModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Student> students = [];
  // Filtered students
  List<Student> searchedStudents = [];

  //https://dart.dev/tools/diagnostic-messages#implicit_this_reference_in_initializer
  static get schemes => {
        "week1": "Attendance",
        "week2": "Attendance",
        "week3": "Attendance",
        "week4": "Attendance",
        "week5": "Attendance",
        "week6": "Attendance",
        "week7": "Attendance",
        "week8": "Attendance",
        "week9": "Attendance",
        "week10": "Attendance",
        "week11": "Attendance",
        "week12": "Attendance"
      };

  MarkingScheme markingSchemes = MarkingScheme(schemes: schemes);
  String selectedWeek = "week1";

  //Firebase student collection
  CollectionReference studentsCollection = FirebaseFirestore.instance.collection('flutter_students');
  CollectionReference markingSchemesCollection = FirebaseFirestore.instance.collection('flutter_schemes');

  //added this
  bool loading = false;

  StudentModel() {
    fetch();
    getMarkingSchemes();
  }

  /* Student Part */
  void fetch() async {
    //clear any existing data we have gotten previously, to avoid duplicate data
    students.clear();
    searchedStudents.clear();
    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all students
    var querySnapshot = await studentsCollection.orderBy("studentID").get();

    //iterate over the students and add them to the list
    querySnapshot.docs.forEach((doc) {
      //note not using the add(Student item) function, because we don't want to add them to the db

      var student = Student.fromJson(doc);
      student.id = doc.id; //add this line
      students.add(student);
    });
    searchedStudents.addAll(students);
    //we're done, no longer loading
    loading = false;
    notifyListeners();
  }

  void add(Student item) async {
    loading = true;
    notifyListeners();

    await studentsCollection.add(item.toJson());

    fetch();
  }

  void update(String id, Student item) async {
    loading = true;
    notifyListeners();

    await studentsCollection.doc(id).set(item.toJson());

    fetch();
  }

  void delete(String id) async {
    loading = true;
    notifyListeners();

    await studentsCollection.doc(id).delete();

    fetch();
  }

  Student? get(String id) {
    return students.firstWhere((student) => student.id == id);
  }
  // Get searched student list
  List<Student>? getSearchedStudent(String value) {
    //https://api.flutter.dev/flutter/dart-core/Iterable/where.html
    //https://riptutorial.com/dart/example/31185/filter-a-list
    var tempStudents = students.where((student) => (student.studentName.toLowerCase().contains(value.toLowerCase()) || student.studentID.toString().contains(value))).toList();
    searchedStudents.clear();
    searchedStudents.addAll(tempStudents);
    notifyListeners();
  }

  /* MarkingScheme Part */
  void getMarkingSchemes() async {
    loading = true;
    notifyListeners();
    var markingSchemeQuerySnapshot = await markingSchemesCollection.get();
    markingSchemeQuerySnapshot.docs.forEach((doc) {
      //note not using the add(Student item) function, because we don't want to add them to the db
      var markingScheme = MarkingScheme.fromJson(doc);
      markingScheme.id = doc.id; //add this line
      markingSchemes = markingScheme;
    });
    loading = false;
    notifyListeners();
  }

  // Update selected week and refresh page
  void updateSelectedWeek(String week) {
    selectedWeek = week;
    notifyListeners();
  }

  void updateMarkingScheme(String scheme) async {
    loading = true;
    notifyListeners();

    markingSchemes.schemes[selectedWeek] = scheme;

    await markingSchemesCollection
        .doc(markingSchemes.id)
        .set(markingSchemes.toJson());

    // Clear existing student scores
    //https://firebase.flutter.dev/docs/firestore/usage#batch-write
    batchUpdate();
    fetch();
    getMarkingSchemes();
  }

  Future<void> batchUpdate() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    //https://medium.com/flutter-community/quick-tip-firestore-multiple-operations-in-flutter-23ddb08d1581
    students.forEach((student) {
      batch.update(
          studentsCollection.doc(student.id), {"grades.$selectedWeek": 0});
    });
    batch.commit();
  }
}
