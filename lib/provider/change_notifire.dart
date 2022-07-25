import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/storage/db_controller.dart';

class TaskChangeProvider extends ChangeNotifier {
  List<Task> tasks = [];
   TaskChangeProvider()  {
    read();
  }

  Future<void> read() async {
    tasks = await DbController().read();
    notifyListeners();
  }

  Future<bool> update(Task ctn) async {
    bool done = await DbController().update(ctn);
    if (done) {
      int index = tasks.indexWhere((element) => element.id == ctn.id);
      tasks[index] = ctn;
      notifyListeners();
    }
    return done;
  }

  Future<void> Delete(int id, int index) async {
    bool deleted = await DbController().delete(id);
    print(deleted);
    if (deleted) {
      tasks.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> create(Task date) async {
    int inserted = await DbController().create(date);
    if (inserted != 0) {
      date.id = inserted;
      tasks.add(date);
      notifyListeners();
    }
    return inserted != 0;
  }
}
