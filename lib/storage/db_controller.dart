import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/storage/db_operation.dart';
import 'package:todo_app/storage/db_provider.dart';

class DbController implements DbOperation<Task> {
  late Database _database;

  DbController() : _database = DbProvider().database;

  @override
  Future<int> create(Task date) async {
    return await _database.insert('tasks', date.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int numberOfRow =
        await _database.delete('tasks', where: 'id=?', whereArgs: [id]);
    return numberOfRow != 0;
  }

  @override
  Future<List<Task>> read() async {
    var rowMaps = await _database.query('tasks');
    List<Task> tasks = rowMaps.map((rowMap) => Task.formMap(rowMap)).toList();
    return tasks;
  }

  @override
  Future<Task?> show(int id) async {
    var data =
        await _database.query('contacts', where: 'id=?', whereArgs: [id]);
    List<Task> contacts = data.map((e) => Task.formMap(e)).toList();
    return contacts.length > 0 ? contacts.first : null;
  }

  @override
  Future<bool> update(Task data) async {
    int count = await _database
        .update('tasks', data.toMap(), where: 'id=?', whereArgs: [data.id]);
    return count > 0;
  }
}
