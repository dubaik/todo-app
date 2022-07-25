class Task {
  Task({
    required this.title,
    required this.note,
    this.isCompleted,
    // this.date,
    this.startTime,
    this.endTime,
   required this.color,
  });
  int? id;
  late String title;
  late String note;
  int? isCompleted;
  // String? date;
  String? startTime;
  String? endTime;
  late int color;
  int? remind;
  String? repeat;

// 'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,note TEXT, isCompleted BIT,date TEXT,startTime TEXT,endTime TEXT,color BIT,remind BIT, repeat TEXT)',

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['note'] = this.note;
    map['isCompleted'] = this.isCompleted;
    // map['date'] = this.date;
    map['startTime'] = this.startTime;
    map['endTime'] = this.endTime;
    map['color'] = this.color;
    map['remind'] = this.remind;
    map['repeat'] = this.repeat;
    return map;
  }

  Task.formMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.title = data['title'];
    this.note = data['note'];
    this.isCompleted = data['isCompleted'];
    // this.date = data['date'];
    this.startTime = data['startTime'];
    this.endTime = data['endTime'];
    this.color = data['color'];
    this.remind = data['remind'];
    this.repeat = data['repeat'];
  }
}
