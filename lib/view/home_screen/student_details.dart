import 'package:starterapp/const/consts.dart';
import 'package:starterapp/const/images.dart';
import 'package:starterapp/controller/semester_controller.dart';
import 'package:starterapp/services/firestore_services.dart';
import 'package:starterapp/view/home_screen/home_screen.dart';
import 'package:starterapp/view/home_screen/result_screen.dart';
import 'package:starterapp/view/home_screen/week1.dart';
import 'package:starterapp/view/home_screen/week2.dart';
import 'package:starterapp/view/home_screen/week3.dart';
import 'package:starterapp/view/home_screen/week4.dart';
import 'package:starterapp/view/home_screen/week5.dart';
import 'package:starterapp/widgets-common/end_drawer.dart';
import 'package:starterapp/widgets-common/my_button.dart';

class StudentDetailsScreen extends StatefulWidget {
  final dynamic data;
  final dynamic semesteID;
  final dynamic courseID;

  const StudentDetailsScreen({Key? key, required this.data, required this.semesteID, required this.courseID}) : super(key: key);

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  var controller = Get.put(SemesterController());

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<dynamic>(
              stream: FireStoreServices.getStudentDetails(widget.semesteID, widget.courseID, widget.data.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;

                  int calculateLabPerformanceTotal() {
                    int weekOneLP = int.parse(data['week_one_lp']);
                    int weekTwoLP = int.parse(data['week_two_lp']);
                    int weekThreeLP = int.parse(data['week_three_lp']);
                    int weekFourLP = int.parse(data['week_four_lp']);
                    int weekFiveLP = int.parse(data['week_five_lp']);

                    return weekOneLP + weekTwoLP + weekThreeLP + weekFourLP + weekFiveLP;
                  }

                  String calculateFinalResult() {
                    int weekOneLP = int.parse(data['week_one_lp']);
                    int weekTwoLP = int.parse(data['week_two_lp']);
                    int weekThreeLP = int.parse(data['week_three_lp']);
                    int weekFourLP = int.parse(data['week_four_lp']);
                    int weekFiveLP = int.parse(data['week_five_lp']);
                    int assignment = int.parse(data['assignment']);
                    int project = int.parse(data['project']);
                    int labFinal = int.parse(data['lab_final']);

                    weekOneLP != 0 ? weekOneLP+=2 : weekOneLP+=0;
                    weekTwoLP != 0 ? weekTwoLP+=2 : weekTwoLP+=0;
                    weekThreeLP != 0 ? weekThreeLP+=2 : weekThreeLP+=0;
                    weekFourLP != 0 ? weekFourLP+=2 : weekFourLP+=0;
                    weekFiveLP != 0 ? weekFiveLP+=2 : weekFiveLP+=0;

                    var result = weekOneLP + weekTwoLP + weekThreeLP + weekFourLP + weekFiveLP+ assignment + project + labFinal;

                    if (result >= 80){
                      return 'Grade: A+, Grade Point: 4.00';
                    }else if (result >= 75){
                      return 'Grade: A, Grade Point: 3.75';
                    }else if (result >= 70){
                      return 'Grade: A-, Grade Point: 3.50';
                    }else if (result >= 65){
                      return 'Grade: B+, Grade Point: 3.25';
                    }else if (result >= 60){
                      return 'Grade: B, Grade Point: 3.00';
                    }else if (result >= 55){
                      return 'Grade: B-, Grade Point: 2.75';
                    }else if (result >= 50){
                      return 'Grade: C+, Grade Point: 2.50';
                    }else if (result >= 45){
                      return 'Grade: C, Grade Point: 2.25';
                    }else if (result >= 40){
                      return 'Grade: D, Grade Point: 2.00';
                    }else{
                      return 'Grade: F, Grade Point: 0.00';
                    }
                  }

                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Center(
                                child: Text(
                                  'Result Sheet',
                                  style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // 10.heightBox,
                              // Row(
                              //   children: [
                              //     Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                              //     'Week1 Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                              //     '${data['week_one_lp']}'.text.semiBold.color(primary).size(18).make(),
                              //     ' out of 5'.text.semiBold.color(fontGrey).size(14).make(),
                              //   ],
                              // ),
                              // 5.heightBox,
                              // Row(
                              //   children: [
                              //     Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                              //     'Week2 Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                              //     '${data['week_two_lp']}'.text.semiBold.color(primary).size(18).make(),
                              //     ' out of 5'.text.semiBold.color(fontGrey).size(14).make(),
                              //   ],
                              // ),
                              // 5.heightBox,
                              // Row(
                              //   children: [
                              //     Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                              //     'Week3 Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                              //     '${data['week_three_lp']}'.text.semiBold.color(primary).size(18).make(),
                              //     ' out of 5'.text.semiBold.color(fontGrey).size(14).make(),
                              //   ],
                              // ),
                              // 5.heightBox,
                              // Row(
                              //   children: [
                              //     Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                              //     'Week4 Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                              //     '${data['week_four_lp']}'.text.semiBold.color(primary).size(18).make(),
                              //     ' out of 5'.text.semiBold.color(fontGrey).size(14).make(),
                              //   ],
                              // ),
                              // 5.heightBox,
                              // Row(
                              //   children: [
                              //     Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                              //     'Week5 Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                              //     '${data['week_five_lp']}'.text.semiBold.color(primary).size(18).make(),
                              //     ' out of 5'.text.semiBold.color(fontGrey).size(14).make(),
                              //   ],
                              // ),
                              // const Divider(),
                              Row(
                                children: [
                                  Image.asset(icPerformance, height: 20, color: highEmphasis,), 5.widthBox,
                                  'Lab Performance: '.text.semiBold.color(highEmphasis).size(18).make(),
                                  '${calculateLabPerformanceTotal()}'.text.semiBold.color(primary).size(18).make(),
                                  ' out of 25'.text.semiBold.color(fontGrey).size(14).make(),
                                ],
                              ),
                              5.heightBox,
                              Row(
                                children: [
                                  Image.asset(icAssingment, height: 20, color: highEmphasis,), 5.widthBox,
                                  'Assignment + Viva: '.text.semiBold.color(highEmphasis).size(18).make(),
                                  '${data['assignment']}'.text.semiBold.color(primary).size(18).make(),
                                  ' out of 10'.text.semiBold.color(fontGrey).size(14).make(),
                                ],
                              ),
                              5.heightBox,
                              Row(
                                children: [
                                  Image.asset(icProject, height: 20, color: highEmphasis,), 5.widthBox,
                                  'Project: '.text.semiBold.color(highEmphasis).size(18).make(),
                                  '${data['project']}'.text.semiBold.color(primary).size(18).make(),
                                  ' out of 25'.text.semiBold.color(fontGrey).size(14).make(),
                                ],
                              ),
                              5.heightBox,
                              Row(
                                children: [
                                  Image.asset(icLabFinal, height: 20, color: highEmphasis,), 5.widthBox,
                                  'Lab Final: '.text.semiBold.color(highEmphasis).size(18).make(),
                                  '${data['lab_final']}'.text.semiBold.color(primary).size(18).make(),
                                  ' out of 30'.text.semiBold.color(fontGrey).size(14).make(),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Image.asset(icResult, height: 20, color: highEmphasis,), 5.widthBox,
                                  'Final Result: '.text.bold.color(highEmphasis).size(20).make(),
                                  calculateFinalResult().text.semiBold.color(calculateFinalResult() == 'Grade: F, Grade Point: 0.00' ? Colors.red : Colors.green).size(18).make(),
                                ],
                              ),
                            ],
                          ).box.white.rounded.make(),
                          10.heightBox,
                          Center(
                            child: myButton(
                              buttonSize: 20.0,
                              color: primary,
                              textColor: whiteColor,
                              title: 'Edit Result Sheet',
                              onPress: (){
                                Get.to(()=> ResultScreen(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                              }
                            ),
                          ),
                          10.heightBox,
                          'Week 1'.text.size(20).bold.color(highEmphasis).make().box.color(Colors.amber).padding(const EdgeInsets.all(8.0)).alignCenter.rounded.width(context.screenWidth).make().onTap(() {
                            Get.to(()=> WeekOne(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                          }),
                          10.heightBox,
                          'Week 2'.text.size(20).bold.color(highEmphasis).make().box.color(Colors.amber).padding(const EdgeInsets.all(8.0)).alignCenter.rounded.width(context.screenWidth).make().onTap(() {
                            Get.to(()=> WeekTwo(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                          }),
                          10.heightBox,
                          'Week 3'.text.size(20).bold.color(highEmphasis).make().box.color(Colors.amber).padding(const EdgeInsets.all(8.0)).alignCenter.rounded.width(context.screenWidth).make().onTap(() {
                            Get.to(()=> WeekThree(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                          }),
                          10.heightBox,
                          'Week 4'.text.size(20).bold.color(highEmphasis).make().box.color(Colors.amber).padding(const EdgeInsets.all(8.0)).alignCenter.rounded.width(context.screenWidth).make().onTap(() {
                            Get.to(()=> WeekFour(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                          }),
                          10.heightBox,
                          'Week 5'.text.size(20).bold.color(highEmphasis).make().box.color(Colors.amber).padding(const EdgeInsets.all(8.0)).alignCenter.rounded.width(context.screenWidth).make().onTap(() {
                            Get.to(()=> WeekFive(data: data, semesteID: widget.semesteID, courseID: widget.courseID,));
                          }),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
