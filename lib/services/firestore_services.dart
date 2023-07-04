import 'package:starterapp/const/consts.dart';
class FireStoreServices{
  static getUser(uid){
    return firestore.collection(usersCollection).where('id',isEqualTo: uid).snapshots();
  }
  static getSemester(){
    return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection(semesterCollection)
          .snapshots();
  }
  static getCourse(docId){
    return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('semesters')
          .doc(docId)
          .collection('course')
          .snapshots();
  }
  static getStudents(docId, courseId){
    return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('semesters')
          .doc(docId)
          .collection('course')
          .doc(courseId)
          .collection('students')
          .snapshots();
  }
  static getStudentDetails(docId, courseId, studentId){
    return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('semesters')
          .doc(docId)
          .collection('course')
          .doc(courseId)
          .collection('students')
          .doc(studentId)
          .snapshots();
  }
}
