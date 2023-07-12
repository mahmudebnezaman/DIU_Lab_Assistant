import 'package:path/path.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/controller/auth_controller.dart';
import 'package:starterapp/view/admin_screen.dart/add_new_course.dart';
import 'package:starterapp/view/admin_screen.dart/registration_screen.dart';
import 'package:starterapp/view/auth_screen/login_screen.dart';
import 'package:starterapp/view/home_screen/home_screen.dart';
import 'package:starterapp/view/profile_screen/profile_screen.dart';
import 'package:starterapp/widgets-common/my_button.dart';

Widget drawerWidget(width){
  return Drawer(
    backgroundColor: Colors.lightGreenAccent,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: const Icon(Icons.arrow_back,).onTap(() {Get.back();})),
            10.heightBox,
            'Add New Course'.text.center.semiBold.size(20).make().box.padding(const EdgeInsets.all(12)).white.width(width).roundedSM.shadow.make().onTap(() {Get.to(()=> const AddNewCourse());}),
            10.heightBox,
            'Register New Student'.text.center.semiBold.size(20).make().box.padding(const EdgeInsets.all(12)).white.width(width).roundedSM.shadow.make().onTap(() {Get.to(()=> const RegisterNewStudent());}),
            const Spacer(),
            myButton(
              buttonSize: 20.0,
              color: primary,
              textColor: highEmphasis,
              title: 'Log Out',
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