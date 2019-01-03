import 'package:flutter/material.dart';
import 'package:note_app/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Note List"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigateToDetail(Note('', 2, ''), "Add Note");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title,
                style: textStyle,
              ),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector(
                //to detect specific area of widget
                child: Icon(Icons.delete_outline),
                onTap: () {
                  _confirmdelete(context, noteList[position]);
                },
              ),
              onTap: () {
                NavigateToDetail(this.noteList[position], "Edit Note");
              },
            ),
          );
        });
  }

  void NavigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result) {
      updateListView();
    }
  }

  //perform delete
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deletetNote(note.id);
    if (result != 0) {
      updateListView();
    }
  }

  //return priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //return priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.play_arrow);
        break;
      default:
        return Icon(Icons.play_arrow);
    }
  }

  //show snackbar
  void _showSnackBar(BuildContext context, String message, Note noteList) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "OK",textColor: Colors.yellow,
        onPressed: () {
          setState(() {
            _delete(context,noteList);
          });
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((notelist) {
        setState(() {
          this.noteList = notelist;
          this.count = notelist.length;
        });
      });
    });
  }

  void _confirmdelete(BuildContext context, Note noteList) {
    _showSnackBar(context, "Are you want to delete note ? ",noteList);
  }
}
