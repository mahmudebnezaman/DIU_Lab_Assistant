import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/home_screen/course_details.dart';
import 'package:starterapp/view/home_screen/home.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';

class SemesterScreen extends StatefulWidget {

  final dynamic data;
  final dynamic semesterData;

  const SemesterScreen({super.key, required this.data, required this.semesterData});

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  String selectedOption1 = 'Spring'; // Track the selected value for the first dropdown
  DateTime? selectedOption2; // Track the selected value for the second dropdown

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SemesterController());

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['semester_name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: Image.asset(icApplogo).onTap(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }),
      ),
      endDrawer: drawerWidget(context.screenWidth),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Add a new course',
              style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: context.screenWidth * 0.8,
                  child: TextFormField(
                    controller: controller.courseNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter course title. e.g. CSE112',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      controller.isloading(true);
                      controller.createNewCourse(widget.data.id);
                      VxToast.show(context, msg: 'New Course Added');
                    },
                  ),
                ),
                Obx(() => controller.isloading.value ?  loadingIndicator() : Image.asset(icCheck, height: 30).onTap(() {
                    controller.isloading(true);
                    controller.createNewCourse(widget.data.id);
                      VxToast.show(context, msg: 'New Course Added');
                  }),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Courses',
              style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            10.heightBox,
            StreamBuilder(
              stream: FireStoreServices.getCourse(widget.data.id),
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
                        Get.to(()=> CourseDetailsScreen(data: data[index], parentData: widget.semesterData,));
                      });
                    }
                  
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
