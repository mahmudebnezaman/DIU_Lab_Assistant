import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/const/loading_indicator.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/widgets-common/custom_textfeild.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';
import 'package:starterapp/widgets-common/my_button.dart';
import 'package:url_launcher/url_launcher.dart';


_launchURL(link) async {
   final Uri url = Uri.parse('$link');
   if (!await launchUrl(url, mode:  LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
    }
}
class WeekThree extends StatefulWidget {
  final dynamic data;
  final dynamic semesteID;
  final dynamic courseID;

  const WeekThree({Key? key, required this.data, required this.semesteID, required this.courseID}) : super(key: key);

  @override
  State<WeekThree> createState() => _WeekThreeState();
}

class _WeekThreeState extends State<WeekThree> {
  UploadTask? task;
  File? file;
  
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
    controller.pdfLink1 = widget.data['lab_report1'];
    controller.pdfLink2 = widget.data['lab_report2'];
    controller.pdfLink3 = widget.data['lab_report3'];
    controller.pdfLink4 = widget.data['lab_report4'];
    controller.pdfLink5 = widget.data['lab_report5'];
  }

  void validator(context) {
    if (int.parse(controller.week1LabController.text) > 5 ||
        int.parse(controller.week2LabController.text) > 5 ||
        int.parse(controller.week3LabController.text) > 5 ||
        int.parse(controller.week4LabController.text) > 5 ||
        int.parse(controller.week5LabController.text) > 5) {
      VxToast.show(context , msg: 'max Lab Performance mark is 5');
    } else if (int.parse(controller.assignmentController.text) > 10) {
      VxToast.show(context, msg: 'max Assignment mark is 10');
    } else if (int.parse(controller.projectController.text) > 25) {
      VxToast.show(context, msg: 'max Project mark is 25');
    } else if (int.parse(controller.labFinalController.text) > 30) {
      VxToast.show(context, msg: 'max Lab Final mark is 30');
    } else {
      // uploadFile().then((value) => controller.editStudentResult(widget.semesteID, widget.courseID, widget.data.id));
      controller.editStudentResult(widget.semesteID, widget.courseID, widget.data.id);
      VxToast.show(context, msg: 'Result Updated');
      // Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null? basename(file!.path) : 'Project Report';
    return Scaffold(
    resizeToAvoidBottomInset: false,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      'Edit Result Sheet'.text.color(Colors.green).semiBold.size(20).make(),
                      10.heightBox,
                      customTextFeild(title: 'Week3 Lab Perfomance: ', hint: 'out of 5', keytype: TextInputType.number, prefixIcon: const Icon(Icons.task), controller: controller.week3LabController),
                      'out of 5'.text.color(fontGrey).make(),
                    ],
                  ).box.white.rounded.make(),
                  10.heightBox,
                  Obx(() => controller.isloading.value
                    ? loadingIndicator()
                    : myButton(
                      buttonSize: 20.0,
                      color: Colors.green,
                      textColor: whiteColor,
                      title: 'Save Mark',
                      onPress: () {
                        validator(context);
                      }
                    )
                  ),
                  10.heightBox,
                  Column(
                    children: [
                      const Icon(Icons.file_upload_rounded, size: 60,).onTap(() {
                        selectFile();
                      }),
                      fileName.text.size(20).semiBold.color(highEmphasis).make(),
                      5.heightBox,
                      Obx(() => controller.isloading.value
                        ? loadingIndicator()
                        : myButton(
                          buttonSize: 20.0,
                          color: golden,
                          textColor: whiteColor,
                          title: 'Upload',
                          onPress: () {           
                          uploadFile().then((value) => controller.editStudentResult(widget.semesteID, widget.courseID, widget.data.id));
                          // controller.editStudentResult(widget.semesteID, widget.courseID, widget.data.id);
                          VxToast.show(context, msg: 'Report Uploaded');
                          Get.back();
                          }
                        )
                      ),
                    ],
                  ).box.color(textfieldGrey).padding(const EdgeInsets.all(8.0)).rounded.make(),
                  10.heightBox,widget.data['lab_report3'] == '' ? Column(
                    children: [
                      'Please upload the report: '.text.size(16).make(),
                      5.heightBox,
                      const Icon(Icons.close_rounded, color: highEmphasis, size: 60,)
                    ],
                  ).box.rounded.padding(const EdgeInsets.all(8.0)).color(lightGolden).make() 
                  : Column(
                    children: [
                      'The report is available at: '.text.size(16).make(),
                      5.heightBox,
                      Image.asset(icFile, height: 60,)
                    ],
                  ).box.rounded.padding(const EdgeInsets.all(8.0)).color(lightGolden).make().onTap(() {
                    _launchURL(widget.data['lab_report3']);
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future selectFile() async {
    final result= await FilePicker.platform.pickFiles(allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['pdf'],);
    if (result == null) {
      return;
    }
    
      final path = result.files.single.path!;
      setState(() {
        file = File(path);
      });

  }

  Future uploadFile() async{
    final fileName = basename(file!.path);
    final destination = 'week3/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null) return;
    final snapshot = await task!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    controller.pdfLink3= urlDownload;
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file){
    try {
    final ref = FirebaseStorage.instance.ref(destination);
    return ref.putFile(file);
  // ignore: unused_catch_clause
  } on Exception catch (e) {
    
    return null;
  }
  }
}
