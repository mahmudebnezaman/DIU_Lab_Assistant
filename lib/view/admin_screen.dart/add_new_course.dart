import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/home_screen/course_details.dart';
import 'package:starterapp/view/home_screen/semester.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';
import 'package:intl/intl.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  String selectedOption1 = 'Spring'; // Track the selected value for the first dropdown
  DateTime? selectedOption2; // Track the selected value for the second dropdown

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SemesterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Course', style: TextStyle(fontWeight: FontWeight.bold)),
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
                Column(
                  children: [
                    const Text(
                      'Add a new semester',
                      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: context.screenWidth * 0.3,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              underline: null,
                              style: const TextStyle(fontSize: 20, color: highEmphasis, fontWeight: FontWeight.w500),
                              value: selectedOption1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption1 = newValue!;
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 'Spring',
                                  child: Text('Spring'),
                                ),
                                DropdownMenuItem(
                                  value: 'Fall',
                                  child: Text('Fall'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.screenWidth * 0.4,
                          child: InkWell(
                            onTap: () {
                              _showYearPicker();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedOption2 != null ? DateFormat('yyyy').format(selectedOption2!) : 'Select Year',
                                  style: const TextStyle(fontSize: 20, color: highEmphasis, fontWeight: FontWeight.w500),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        Obx(() => controller.isloading.value ?  loadingIndicator() : Image.asset(icCheck, height: 30).onTap(() {
                            controller.isloading(true);
                            controller.createNewSemester(selectedOption1, selectedOption2);
                              VxToast.show(context, msg: 'New Semester Added');
                          }),
                        ),
                      ],
                    ),
                  ],
                ).box.color(lightGolden).rounded.padding(const EdgeInsets.all(8.0)).make(),
                const Divider(),
                10.heightBox,
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 0, crossAxisSpacing: 0, mainAxisExtent: 50),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: semesterData.length,
                        itemBuilder: (context, semesterIndex){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              '${semesterData[semesterIndex]['semester_name']}'.text.semiBold.size(20).color(primary).make().box.roundedSM.make().onTap(() {
                                Get.to(()=> SemesterScreen(data: semesterData[semesterIndex], semesterData: semesterData[semesterIndex].id,));
                              }),
                             const Divider()
                            ],
                          );
                          // 
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

  Future<void> _showYearPicker() async {
    final DateTime? pickedYear = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDate: selectedOption2 ?? DateTime.now(),
              selectedDate: selectedOption2 ?? DateTime.now(),
              onChanged: (DateTime newDate) {
                setState(() {
                  selectedOption2 = newDate;
                });
                Navigator.of(context).pop(newDate);
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null) {
      setState(() {
        selectedOption2 = pickedYear;
      });
    }
  }
}
