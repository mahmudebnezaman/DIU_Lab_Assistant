import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/admin_screen.dart/add_student.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';

class RegisterNewStudent extends StatefulWidget {
  const RegisterNewStudent({Key? key}) : super(key: key);

  @override
  State<RegisterNewStudent> createState() => _RegisterNewStudentState();
}

class _RegisterNewStudentState extends State<RegisterNewStudent> {
  String selectedOption1 = 'Spring'; // Track the selected value for the first dropdown
  DateTime? selectedOption2; // Track the selected value for the second dropdown

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Student', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Image.asset(icApplogo).onTap(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
        }),
      ),
      endDrawer: drawerWidget(context.screenWidth),
      body: Stack(
      children: [
        Image.asset(icAppbg, fit: BoxFit.fill, height: context.screenHeight,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                StreamBuilder(
                  stream: FireStoreServices.getSemester(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (!snapshot.hasData){
                      return Center(
                        child: loadingIndicator(),
                      );
                    }else if (snapshot.data!.docs.isEmpty){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          'No semesters added yet!'.text.size(20).makeCentered()
                        ],
                      );
                    }else{
                      var semesterData = snapshot.data!.docs;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 0, crossAxisSpacing: 0, mainAxisExtent: 145),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: semesterData.length,
                        itemBuilder: (context, semesterIndex){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              '${semesterData[semesterIndex]['semester_name']}'.text.semiBold.size(20).color(primary).make(),
                              10.heightBox,
                              StreamBuilder(
                                stream: FireStoreServices.getCourse(semesterData[semesterIndex].id),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if (!snapshot.hasData){
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  }else if (snapshot.data!.docs.isEmpty){
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        'No course added yet!'.text.size(20).makeCentered()
                                      ],
                                    );
                                  }else{
                                    var data = snapshot.data!.docs;
                                    return GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 50),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index){
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            '${data[index]['course_title']}'.text.semiBold.size(20).white.make()
                                          ],
                                        ).box.roundedSM.shadow.color(primary).make().onTap(() {
                                          Get.to(()=> AddStudent(data: data[index], parentData: semesterData[semesterIndex].id,));
                                        });
                                      }
                                    
                                    );
                                  }
                                },
                              )
                            ],
                          );
                          // .box.roundedSM.shadow.color(primary).make().onTap(() {
                          //   Get.to(()=> SemesterScreen(data: data[index], semesterData: data[index].id,));
                          // });
                        }
                      
                      );
                    }
                  },
                ).box.white.roundedLg.padding(const EdgeInsets.all(20.0)).shadowLg.make()
              ],
            ),
          ),
        ],
      ),
    );
  }

}
