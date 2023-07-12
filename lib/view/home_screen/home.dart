import 'package:starterapp/const/consts.dart';
import 'package:starterapp/controller/home_controller.dart';
import 'package:starterapp/view/home_screen/home_screen.dart';
import 'package:starterapp/view/profile_screen/profile_screen.dart';


class Home extends StatefulWidget {


  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime timeBackPressed =DateTime.now();

  @override
  Widget build(BuildContext context) {

     // home controller
    var controller = Get.put(HomeController());

    var navBarItem = [
      const BottomNavigationBarItem(icon: Icon(Icons.home_filled,), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 30,), label: 'Profile'),
    ];

    var navBody = [
      const HomeScreen(),
      const ProfileScreen()
    ]; 

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentNavIndex.value == 0) {
          var difference = DateTime.now().difference(timeBackPressed);
          var isExitWarning = difference>= const Duration(seconds: 2);
          timeBackPressed = DateTime.now();
          if (isExitWarning){
          VxToast.show(context, msg: 'Press again to Exit!');
          return false;
        }else{
          return true;
        }}
        else{
          setState((){
            controller.currentNavIndex.value = 0 ;
          });
          return false;
        }

      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(()=>
              Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value)
                ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(()=>
          BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: primary,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            items: navBarItem,
            onTap: (value){
              controller.currentNavIndex.value=value;
            },
            ),
        ),
      ),
    );
  }
}