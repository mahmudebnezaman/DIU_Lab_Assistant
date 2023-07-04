import 'package:starterapp/const/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/controller/auth_controller.dart';
import 'package:starterapp/view/auth_screen/login_screen.dart';
import 'package:starterapp/view/home_screen/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

var authcontroller = Get.put(AuthController());

changeScreen(){
    Future.delayed(const Duration(seconds: 2),(){
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted){
          Get.offAll (()=>const LoginScreen());
        } else  {
          Get.offAll(()=>const HomeScreen());
        }
      });
    });
  }

  @override
  void initState(){
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icApplogo).box.size(220, 220).make(),
          ],
        ),
      ),
    );
  }
}