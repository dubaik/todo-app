import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/provider/change_notifire.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/pages/add_task_page.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(
              height: 6,
            ),
            _showTasks(),
          ],
        ));
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              ThemeServices().switchThem();
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            )),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 15,
          )
        ],
      );
  _addTaskBar() {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Text('September'),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: Themes().headingStyle,
            ),
            Text(
              'Today',
              style: Themes().subHeadingStyle,
            ),
          ]),
          MyButton(
            lable: '+ Add Task',
            OnTap: () async {
              await Get.to(() => AddTaskPage());
              // _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
        DateTime.now(),
        dayTextStyle: GoogleFonts.lato(
          color: Get.isDarkMode ? Colors.white : Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        dateTextStyle: GoogleFonts.lato(
          color: Get.isDarkMode ? Colors.white : Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        monthTextStyle: GoogleFonts.lato(
          color: Get.isDarkMode ? Colors.white : Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        initialSelectedDate: DateTime.now(),
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _showTasks() {
    // Provider.of<TaskChangeProvider>(context).read();
    return Consumer<TaskChangeProvider>(
      builder: (context, value, child) {
        if (value.tasks.isNotEmpty) {
          return Expanded(
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemCount: value.tasks.length,
              itemBuilder: (context, index) {
                Task task = value.tasks[index];
                // NotifyHelper().scheduledNotification(20, 55, task);
                return AnimationConfiguration.staggeredList(
                  duration: const Duration(milliseconds: 1375),
                  position: index,
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          showBottemSheet(context, task, index);
                        },
                        child: TaskTile(
                          task: task,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 2000),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    direction: SizeConfig.orientation == Orientation.landscape
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizeConfig.orientation == Orientation.landscape
                          ? SizedBox(height: 6)
                          : SizedBox(height: 150),
                      SvgPicture.asset(
                        'images/task.svg',
                        height: 220,
                        color: primaryClr.withOpacity(0.5),
                        semanticsLabel: 'Task',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 50),
                        child: Text(
                          'You dont have tasks',
                          style: Themes().subHeadingStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenHeight * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleStyle
                : Themes().titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  showBottemSheet(BuildContext context, Task task, int index) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () async {
                      setState(() {
                        task.isCompleted = 1;
                    Provider.of<TaskChangeProvider>(context, listen: false)
                    .update(task);
                      });
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete Task ',
              onTap: () async {
                await Provider.of<TaskChangeProvider>(context, listen: false)
                    .Delete(task.id!, index);
                Get.back();
              },
              clr: primaryClr,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              label: 'Cancle',
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
