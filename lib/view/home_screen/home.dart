import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/home_screen/semester.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption1 = 'Spring'; // Track the selected value for the first dropdown
  DateTime? selectedOption2; // Track the selected value for the second dropdown

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SemesterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Divider(),
            const Text(
              'Semesters',
              style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                          '${data[index]['semester_name']}'.text.semiBold.size(20).white.make()
                        ],
                      ).box.roundedSM.shadow.color(primary).make().onTap(() {
                        Get.to(()=> SemesterScreen(data: data[index], semesterData: data[index].id,));
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
