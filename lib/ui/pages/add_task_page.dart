import 'dart:ui';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/provider/change_notifire.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: Themes().subHeadingStyle,
              ),
              InputField(
                title: 'title',
                hint: 'Enter title here',
                contorller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                contorller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2025),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _startTime = picked.format(context);
                              });
                            }
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () async {
                            TimeOfDay? pickedEnd = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedEnd != null) {
                              setState(() {
                                _endTime = pickedEnd.format(context);
                              });
                            }
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      items: remindList
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                '$e',
                                // style: TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      style: Themes().subTileStyle,
                      onChanged: (int? e) {
                        setState(() {
                          _selectedRemind = e!;
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down, size: 32),
                      elevation: 4,
                      underline: Container(height: 0),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      items: repeatList
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                // style: TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      style: Themes().subTileStyle,
                      onChanged: (String? e) {
                        setState(() {
                          _selectedRepeat = e!;
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down, size: 32),
                      elevation: 4,
                      underline: Container(height: 0),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColorPallete(),
                  MyButton(
                      lable: 'Create Task',
                      OnTap: () {
                        savePerform(context);
                        // print('object');
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void savePerform(BuildContext context) async {
    if (checkDate()) {
      saveContact(context);
    }
  }

  bool checkDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future saveContact(BuildContext context) async {
    bool succesful =
        await Provider.of<TaskChangeProvider>(context, listen: false)
            .create(info);
    print(succesful);
    if (succesful) {
      Navigator.pop(context);
    } else {
      print('error');
    }
  }

  Task get info {
    Task ctn = Task(note: _noteController.text, title: _titleController.text,color: _selectedColor);
    ctn.isCompleted = 0;
    // ctn.date = _selectedDate as String?;
    ctn.startTime = _startTime;
    ctn.endTime = _endTime;
    return ctn;
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: primaryClr,
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

  Column ColorPallete() {
    return Column(
      children: [
        Text('Color', style: Themes().titleStyle),
        SizedBox(
          height: 10,
        ),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                child: index == _selectedColor
                    ? Icon(
                        Icons.done,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
              ),
            ),
          ),
        ))
      ],
    );
  }
}
