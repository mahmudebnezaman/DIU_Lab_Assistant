import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/view/home_screen/home_screen.dart';
import 'package:starterapp/widgets-common/custom_textfeild.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';
import 'package:starterapp/widgets-common/my_button.dart';

class WeekThree extends StatefulWidget {
  final dynamic data;
  final dynamic semesteID;
  final dynamic courseID;

  const WeekThree({Key? key, required this.data, required this.semesteID, required this.courseID}) : super(key: key);

  @override
  State<WeekThree> createState() => _WeekThreeState();
}

class _WeekThreeState extends State<WeekThree> {
  var controller = Get.put(SemesterController());

  @override
  void initState() {
    super.initState();
    controller.week1LabController.text = widget.data['week_one_lp'];
    controller.week2LabController.text = widget.data['week_two_lp'];
    controller.week3LabController.text = widget.data['week_three_lp'];
    controller.week4LabController.text = widget.data['week_four_lp'];
    controller.week5LabController.text = widget.data['week_five_lp'];
    controller.projectController.text = widget.data['project'];
    controller.assignmentController.text = widget.data['assignment'];
    controller.labFinalController.text = widget.data['lab_final'];
  }

  @override
  Widget build(BuildContext context) {

    void validator(){
      if (int.parse(controller.week1LabController.text) > 5 || int.parse(controller.week2LabController.text) > 5 || int.parse(controller.week3LabController.text) > 5 || int.parse(controller.week4LabController.text) > 5 || int.parse(controller.week5LabController.text) > 5){
        VxToast.show(context, msg: 'max Lab Performance mark is 5');
      }else if(int.parse(controller.assignmentController.text) > 10 ){
        VxToast.show(context, msg: 'max Assignment mark is 10');
      }else if(int.parse(controller.projectController.text) > 25 ){
        VxToast.show(context, msg: 'max Project mark is 25');
      }else if(int.parse(controller.labFinalController.text) > 30 ){
        VxToast.show(context, msg: 'max Lab Final mark is 30');
      }else{
        controller.editStudentResult(widget.semesteID, widget.courseID, widget.data.id);
        VxToast.show(context, msg: 'Result Updated');
        Get.back();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.data['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Image.asset(icApplogo).onTap(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
        }),
      ),
      endDrawer: drawerWidget(context.screenWidth),
      body: 
      Stack(
      children: [
        Image.asset(icAppbg, fit: BoxFit.fill, height: context.screenHeight,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      'Edit Result Sheet'.text.color(Colors.green).semiBold.size(20).make(),
                      10.heightBox,
                      customTextFeild(title: 'Week3 Lab Perfomance: ', hint: 'out of 5', keytype: TextInputType.number, prefixIcon: const Icon(Icons.task), controller: controller.week3LabController),
                      'out of 5'.text.color(fontGrey).make(),
                    ],
                  ).box.white.rounded.make(),
                  Obx(() => controller.isloading.value
                    ? loadingIndicator()
                    : myButton(
                      buttonSize: 20.0,
                      color: Colors.green,
                      textColor: whiteColor,
                      title: 'Save',
                      onPress: (){
                        validator();
                      }
                    )
                  ),
                  10.heightBox
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
