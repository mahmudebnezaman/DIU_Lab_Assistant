// ignore_for_file: avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:starterapp/const/consts.dart';
class SemesterController extends GetxController {
  final RxBool isloading = false.obs;
  final semesterNameController = ''.obs;
  var courseNameController = TextEditingController();
  var studentIdController = TextEditingController();

  var week1LabController = TextEditingController();
  var week2LabController = TextEditingController();
  var week3LabController = TextEditingController();
  var week4LabController = TextEditingController();
  var week5LabController = TextEditingController();
  var assignmentController = TextEditingController();
  var projectController = TextEditingController();
  var labFinalController = TextEditingController();
  var pdfLink1 = '';
  var pdfLink2 = '';
  var pdfLink3 = '';
  var pdfLink4 = '';
  var pdfLink5 = '';

  Future<void> createNewSemester(String selectedOption1, DateTime? selectedOption2) async {
    try {
      isloading.value = true;
      final semesterName = '$selectedOption1 ${DateFormat('yyyy').format(selectedOption2!)}';
      await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
      .collection('semesters')
      .doc()
      .set({
        'semester_name': semesterName,
        // Add more fields as needed
      });
      isloading.value = false;
    } catch (e) {
      print('Error creating new semester: $e');
      isloading.value = false;
    }
  }

  Future<void> createNewCourse(String docId) async {
    try {
      await firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('semesters')
      .doc(docId)
      .collection('course')
      .add({
        'course_title': courseNameController.text,
        // Add more fields as needed
      });
      isloading.value = false;
    } catch (e) {
      print('Error creating new course: $e');
      isloading.value = false;
    }
  }

  Future<void> registerNewStudent(String docId, String courseId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('semesters')
          .doc(docId)
          .collection('course')
          .doc(courseId)
          .collection('students')
          .add({
            'id': studentIdController.text,
            'week_one_lp': '0',
            'week_two_lp': '0',
            'week_three_lp': '0',
            'week_four_lp': '0',
            'week_five_lp': '0',
            'assignment': '0',
            'project': '0',
            'lab_final': '0',
            'lab_report1': '',
            'lab_report2': '',
            'lab_report3': '',
            'lab_report4':'',
            'lab_report5': '',
            'week1_attendance': '0',
            'week2_attendance': '0',
            'week3_attendance': '0',
            'week4_attendance': '0',
            'week5_attendance': '0',
          });
      isloading.value = false;
    } catch (e) {
      print('Error registering new student: $e');
      isloading(false);
    }
  }

Future<void> editStudentResult(String docId, String courseId, String studentId) async {
    // print('Inside update mark method');
  try {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('semesters')
        .doc(docId)
        .collection('course')
        .doc(courseId)
        .collection('students')
        .doc(studentId)
        .set({
          'week_one_lp': week1LabController.text,
          'week_two_lp': week2LabController.text,
          'week_three_lp': week3LabController.text,
          'week_four_lp': week4LabController.text,
          'week_five_lp': week5LabController.text,
          'assignment': assignmentController.text,
          'project': projectController.text,
          'lab_final': labFinalController.text,
          'lab_report1': pdfLink1,
          'lab_report2': pdfLink2,
          'lab_report3': pdfLink3,
          'lab_report4': pdfLink4,
          'lab_report5': pdfLink5,
        }, SetOptions(merge: true));
    isloading.value = false;
  } catch (e) {
    print('Error registering new student: $e');
    isloading.value = false;
  }
}

Future<void> editStudentAttendance(String docId, String courseId, String studentId,weekName, attendance) async {
    // print('Inside update mark method');
  try {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('semesters')
        .doc(docId)
        .collection('course')
        .doc(courseId)
        .collection('students')
        .doc(studentId)
        .set({
          weekName: attendance,
        }, SetOptions(merge: true));
    isloading.value = false;
  } catch (e) {
    print('Error registering new student: $e');
    isloading.value = false;
  }
}
 

}
