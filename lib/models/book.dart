class Book {
  String title;
  bool done;
  bool newTest;
  String startDate;
  String endDate;

  Book({this.title, this.done, this.startDate, this.endDate, this.newTest});

  Book.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    newTest = json['newTest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['newTest'] = this.newTest;
    return data;
  }
}
