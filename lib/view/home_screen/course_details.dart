import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/home_screen/home.dart';
import 'package:starterapp/view/home_screen/student_details.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';

class CourseDetailsScreen extends StatefulWidget {
  final dynamic data;
  final dynamic parentData;

  const CourseDetailsScreen({Key? key, required this.data, required this.parentData}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  var controller = Get.put(SemesterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.data['course_title']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
              'Register new student',
              style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: context.screenWidth * 0.8,
                  child: TextFormField(
                    controller: controller.studentIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter student ID. e.g. 232-15-xxxxx ',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      controller.isloading(true);
                      controller.registerNewStudent(widget.parentData, widget.data.id);
                      VxToast.show(context, msg: 'New Student Registered');
                    },
                  ),
                ),
                Obx(() => controller.isloading.value
                    ? loadingIndicator()
                    : Image.asset(icCheck, height: 30).onTap(() {
                        controller.isloading(true);
                        controller.registerNewStudent(widget.parentData, widget.data.id);
                        VxToast.show(context, msg: 'New Student Registered');
                      })),
              ],
            ),
            const Divider(),
            const Text(
              'Students',
              style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            10.heightBox,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FireStoreServices.getStudents(widget.parentData, widget.data.id),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: loadingIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No students registered yet!', style: TextStyle(fontSize: 20)));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var student = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text('${student['id']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: highEmphasis)),
                        onTap: () {
                          Get.to(()=> StudentDetailsScreen(data: student, semesteID: widget.parentData, courseID: widget.data.id,));
                        },
                        trailing: Image.asset(icRight, color: fontGrey, height: 20,),
                      ).box.roundedSM.shadow.white.margin(const EdgeInsets.only(bottom: 4)).make();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
