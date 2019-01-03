import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  String note_table = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  //performing singletone in dart
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return noteDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'create table $note_table($colId integer primary key autoincrement , $colTitle text , $colDescription text ,$colPriority integer ,$colDate text)');
  }

  //fetch Notes
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database database = await this.database;
    var result = await database.query(note_table, orderBy: colPriority);
    return result;
  }

  //insert Notes
  Future<int> insertNote(Note note) async {
    Database database = await this.database;
    var result = await database.insert(note_table, note.toMap());
    return result;
  }

//update Notes
  Future<int> updatetNote(Note note) async {
    Database database = await this.database;
    var result = await database.update(note_table, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete Notes
  Future<int> deletetNote(int id) async {
    Database database = await this.database;
    var result =
        await database.rawDelete('delete from $note_table where $colId = $id');
    return result;
  }

  //return count(*)
  Future<int> getCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> notes =
        await database.rawQuery('select count(*) from $note_table');
    int result = Sqflite.firstIntValue(notes);
    return result;
  }

  //convert map to noteList
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> notes = List<Note>();

    for (int i = 0; i < count; ++i) {
      notes.add(Note.fromMapObject(noteMapList[i]));
    }

    return notes;

  }
}
