import 'package:starterapp/const/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  @override
  void onInit() {
    // Initialize your controller here
    super.onInit();
  }

  var isloading = false.obs;

  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<UserCredential?> loginMethod({context, profileController}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      update();
    } on FirebaseAuthException {
      VxToast.show(context, msg: "Please use valid email & password!");
    }
    isloading(false);
    return userCredential;
  }

  Future<UserCredential?> signupMethod(
      {required email, required password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data method

  storeUserData({required name, required password, required email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(auth.currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': auth.currentUser!.uid,
    });
  }

  //Email varification
  Future<void> sendEmailVarification(context) async{
    try {
      await auth.currentUser?.sendEmailVerification();
    }on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
      emailController.clear(); // clear the email controller
      passwordController.clear(); // clear the password controller
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
