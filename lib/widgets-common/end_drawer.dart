import 'package:path/path.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/controller/auth_controller.dart';
import 'package:starterapp/view/auth_screen/login_screen.dart';
import 'package:starterapp/view/home_screen/home.dart';
import 'package:starterapp/view/profile_screen/profile_screen.dart';
import 'package:starterapp/widgets-common/my_button.dart';

Widget drawerWidget(width){
  return Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: const Icon(Icons.arrow_back,).onTap(() {Get.back();})),
                10.heightBox,
                'Dashboard'.text.center.semiBold.size(20).make().box.padding(const EdgeInsets.all(12)).white.width(width).roundedSM.shadow.make().onTap(() {Get.to(()=> const HomeScreen());}),
                10.heightBox,
                'Profile'.text.center.semiBold.size(20).make().box.padding(const EdgeInsets.all(12)).white.width(width).roundedSM.shadow.make().onTap(() {Get.to(()=> const ProfileScreen());}),
                const Spacer(),
                myButton(
                  buttonSize: 20.0,
                  color: whiteColor,
                  textColor: primary,
                  title: 'Sign Out',
                  onPress:  () async {
                    await Get.put(AuthController()).signoutMethod(context);
                    Get.offAll( ()=> const LoginScreen());
                  },
                ).box.border(color: primary, width: 2).roundedSM.width(width).make(),
                20.heightBox
              ],
            ),
          ),
        ),
      );
}