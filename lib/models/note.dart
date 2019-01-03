class Note {
  int _id;
  String _title;
  String _descriptionp;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date, [this._descriptionp]);

  //named constructor in dart
  Note.withId(this._id, this._title, this._priority, this._date,
      [this._descriptionp]);

  String get date => _date;

  int get priority => _priority;

  String get descriptionp => _descriptionp;

  String get title => _title;

  int get id => _id;

  set date(String value) {
    _date = value;
  }

  set priority(int value) {
    if (value >= 1 && value <= 2) _priority = value;
  }

  set descriptionp(String value) {
    _descriptionp = value;
  }

  set title(String value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    //dynamic mean any type
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _descriptionp;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._priority = map['priority'];
    this._title = map['title'];
    this._descriptionp = map['description'];
    this._date = map['date'];
  }
}
