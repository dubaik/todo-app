import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[
    Task(
        title: "Task 1",
        color: 2,
        isCompleted: 1,
        note: "Note SomeThing",
        startTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(Duration(minutes: 1))),
        endTime: "8:20"),
    Task(
        title: "Task 1",
        color: 1,
        isCompleted: 0,
        note: "Note SomeThing",
        startTime: "5:30",
        endTime: "8:20"),
    Task(
        title: "Task 1",
        color: 0,
        isCompleted: 0,
        note: "Note SomeThing",
        startTime: "5:30",
        endTime: "8:20"),
    Task(
        title: "Task 1",
        color: 0,
        isCompleted: 0,
        note: "Note SomeThing",
        startTime: "5:30",
        endTime: "8:20"),
    Task(
        title: "Task 1",
        color: 1,
        isCompleted: 0,
        note: "Note SomeThing",
        startTime: "5:30",
        endTime: "8:20"),
    Task(
        title: "Task 1",
        color: 2,
        isCompleted: 0,
        note: "Note SomeThing",
        startTime: "5:30",
        endTime: "8:20"),
  ];
  getTasks() {}
}
