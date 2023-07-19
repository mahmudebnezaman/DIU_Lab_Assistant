import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/auth_controller.dart';
import 'package:starterapp/widgets-common/custom_passwordfeild.dart';
import 'package:starterapp/widgets-common/custom_textfeild.dart';
import 'package:starterapp/widgets-common/my_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"])*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

class _SignUpState extends State<SignUp> {

  
  var nameIcon = const Icon(Icons.account_circle_outlined, size: 25,);
  var emailIcon = const Icon(Icons.email_outlined, size: 25,);

  bool? isCheck = true;
  bool? isValid = false;

  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();

  void vaildation() async {
    if (nameController.text.isEmpty && emailController.text.isEmpty && passwordController.text.isEmpty && retypePasswordController.text.isEmpty) {
      VxToast.show(context, msg: "Please fill the signup form");
    } else {
      if (emailController.text.isEmpty) {
      VxToast.show(context, msg: "Email feild is Empty");
    } else if (!regExp.hasMatch(emailController.text)) {
      VxToast.show(context, msg: "Please Try Vaild Email");
    } else if (passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Password feild is Empty");
    } else if (passwordController.text.length < 8) {
      VxToast.show(context, msg: "Minimum password length is 8");
    } else if (passwordController.text != retypePasswordController.text) {
      VxToast.show(context, msg: "Password not matched");
    } else {
      signUpButtonPress();
    }
    }
  }

  signUpButtonPress () async {
    if (isCheck != false){
      controller.isloading(true);
      try{
        await controller.signupMethod(context: context, email: emailController.text, password: passwordController.text).then((value){
          return controller.storeUserData(
            email: emailController.text,
            name: nameController.text,
            password: passwordController.text,
          );
          }).then((value) {
            VxToast.show(context, msg: 'Account Created');
            controller.isloading(false);
            Get.to(()=> const Home());
         });
      } catch(e){
        controller.isloading(false);
        auth.signOut();
      }
    }
  }

  bool isPass = true;
  bool isConfirmPass = true;

  void togglePasswordView() {
    setState(() {
      isPass = !isPass;
    });
  }
  void toggleConfirmPasswordView() {
    setState(() {
      isConfirmPass = !isConfirmPass;
    });
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    // resizeToAvoidBottomInset: false,
    backgroundColor: whiteColor,
    body: Stack(
      children: [
        Image.asset(icAppbg, fit: BoxFit.fill, height: context.screenHeight,),
        Padding(
          padding: const EdgeInsets.all(24),
          child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(icApplogo, width: 150,),
                  5.heightBox,
                  'Sign Up'.text.fontFamily(bold).size(35).color(highEmphasis).make(),
                  //textfeild
                  25.heightBox,
                  customTextFeild(title: 'Name', hint: 'ex: Md. Sazzad Hossain', controller: nameController, prefixIcon: nameIcon),
                  10.heightBox,
                  customTextFeild(hint: 'example@email.com', title: 'Email', prefixIcon: emailIcon, controller: emailController),
                  10.heightBox,
                  customPasswordFeild(hint: 'xxxxxx', title: 'Password', obsText: isPass, suffixIcon: InkWell(
                  onTap: togglePasswordView,
                  child: Icon(
                    isPass 
                      ? Icons.visibility 
                      : Icons.visibility_off,
                  )), controller: passwordController),
                  10.heightBox,
                  customPasswordFeild(hint: 'xxxxxx', title: 'Confirm Password', obsText: isConfirmPass, suffixIcon: InkWell(
                  onTap: toggleConfirmPasswordView,
                  child: Icon(
                    isConfirmPass 
                      ? Icons.visibility 
                      : Icons.visibility_off,
                  )), controller: retypePasswordController),
                  5.heightBox,
                  controller.isloading.value ? loadingIndicator() : myButton(
                    color: isCheck == true ? primary : lightGrey,
                    title: 'Sign Up',
                    textColor: isCheck == true ? whiteColor : fontGrey,
                    onPress: (){
                      vaildation();
                    },
                    buttonSize: 20.0,
                  ).box.width(context.screenWidth).make(),
                  10.heightBox,
                  'or'.text.color(fontGrey).size(16).fontFamily(semibold).make(),
                  10.heightBox,
                  'Sign in here'.text.color(primary).size(20).semiBold.make().onTap((){
                     Get.back();
                  }),
                ],
              ).box.white.roundedLg.padding(const EdgeInsets.all(12.0)).shadowLg.make(),
            ),
          ),
      ],
    ),
    );
  }
}