// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/auth_screen/login_screen.dart';
import 'package:starterapp/view/profile_screen/change_password.dart';
import 'package:starterapp/view/profile_screen/edit_profile.dart';

import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';

import 'package:starterapp/widgets-common/my_button.dart';

import 'package:starterapp/controller/auth_controller.dart';
import 'package:starterapp/controller/profile_controller.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Profile'.text.bold.make()),
      endDrawer: drawerWidget(context.screenWidth),
      body: StreamBuilder(
        stream: FireStoreServices.getUser(auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
              return Center(child: loadingIndicator());
            } else {
      
              var data = snapshot.data!.docs[0];
              return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                data['imageUrl'] == '' ? Image.asset(icUser,fit: BoxFit.cover,height: 250,width: 250, color: fontGrey,).box.height(150).width(150).clip(Clip.antiAlias).roundedFull.white.shadow3xl.make() 
                : Image.network(data['imageUrl'],fit: BoxFit.cover,height: 250,width: 250).box.height(150).width(150).clip(Clip.antiAlias).roundedFull.white.shadow3xl.make(),
                10.heightBox,
                "${data['name']}".text.size(30).bold.color(highEmphasis).make(),
                "${data['email']}".text.size(18).fontFamily(regular).color(fontGrey).make(),
                20.heightBox,
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Edit Profile".text.color(highEmphasis).size(18).fontFamily(bold).make(),
                    Image.asset(icRight, height: 18, color: lightGrey,)
                  ],
                ).onTap(() {Get.to(()=> EditProfileInfo(data: data,));}),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Change Password".text.color(highEmphasis).size(18).fontFamily(bold).make(),
                    Image.asset(icRight, height: 18, color: lightGrey,)
                  ],
                ).onTap(() {
                  Get.to(()=> ChangePassword(data: data,));
                }),
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
            ).box.border(color: primary, width: 2).roundedSM.width(context.screenWidth).make(),
              ]),
          );
          }

        },
      ),
    );
  }
}
