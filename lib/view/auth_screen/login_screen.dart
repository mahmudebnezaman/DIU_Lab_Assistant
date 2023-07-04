import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:starterapp/controller/auth_controller.dart';

import 'package:starterapp/view/auth_screen/signup_screen.dart';
import 'package:starterapp/view/home_screen/home.dart';
import 'package:starterapp/widgets-common/custom_passwordfeild.dart';
import 'package:starterapp/widgets-common/custom_textfeild.dart';
import 'package:starterapp/widgets-common/my_button.dart';

class LoginScreen extends StatefulWidget {
  
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

class _LoginScreenState extends State<LoginScreen> {

void changeScreen() {
  auth.authStateChanges().listen((User? user) {
    if (user == null && mounted) {
      Get.offAll(() => const LoginScreen());
    } else if (user != null) {
       Get.offAll(() => const HomeScreen());
    }
  });
}


  bool? isCheck = false;
  var controller = Get.put(AuthController());

  void vaildation() async {
    if (controller.emailController.text.isEmpty && controller.passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Please fill the signin form");
    } else {
      if (controller.emailController.text.isEmpty) {
      VxToast.show(context, msg: "Email feild is Empty");
    } else if (!regExp.hasMatch(controller.emailController.text)) {
      VxToast.show(context, msg: "Please Try Vaild Email");
    }  else if (controller.passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Password feild is Empty");
    }else {
      signinButtonPress();
    }
    }
  }

  signinButtonPress() async {
    controller.isloading(true);
      await controller.loginMethod(context: context).then((value) {
        if(value != null){
          VxToast.show(context, msg: 'Signed in successfully');
          changeScreen();
        } else{
          controller.isloading(false);
        }
      });
  }
  
  bool isPass = true;

  void togglePasswordView() {
    setState(() {
      isPass = !isPass;
    });
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: whiteColor,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.heightBox,
              Image.asset(icApplogo, width: 150,),
              5.heightBox,
              'Sign In'.text.fontFamily(bold).size(35).color(highEmphasis).make(),
              25.heightBox,
              Obx(()=>
               Column(
                  children: [
                    customTextFeild(hint: 'example@email.com', title: 'Email', prefixIcon: const Icon(Icons.email_rounded), controller: controller.emailController),
                    10.heightBox,
                    customPasswordFeild(hint: 'xxxxxx', title: 'Password', obsText: isPass, suffixIcon: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        isPass 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      )), controller: controller.passwordController),
                    10.heightBox,
                    controller.isloading.value ?  loadingIndicator() : myButton(
                      color: primary,
                      onPress: () {
                        vaildation();
                      },
                      textColor: whiteColor,
                      title: 'Sign In',
                      buttonSize: 20.0,
                    ).box.width(context.screenWidth).make(),
                  ],
                ),
              ),
        
              10.heightBox,
              Align(
                alignment: Alignment.center,
                child: 'or'.text.color(fontGrey).size(16).fontFamily(semibold).make(),
              ),
        
              10.heightBox,
              'Create New Account'.text.color(primary).size(20).semiBold.make().onTap(() {
                Get.to(()=> const SignUp());
              })
            ],
          ),
        ),
      ),
    ),
   );
  }
}

Future<bool> checkUserExists(String userId) async {
  final snapshot = await firestore.collection(usersCollection).doc(userId).get();
  return snapshot.exists;
}