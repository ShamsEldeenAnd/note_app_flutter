import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _Piriorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  var _formKey = GlobalKey<FormState>();
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.descriptionp;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            moveTolastScreen();
          },
        ),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                getDropDownButton(),
                getTextField("Title", "Enter Your Title", titleController),
                getTextField("Description", "Enter Your Description",
                    descriptionController),
                getRow()
              ],
            ),
          )),
    );
  }

  Widget getDropDownButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: DropdownButton<String>(
        items: _Piriorities.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          );
        }).toList(),
        value: convertPriorityToString(note.priority),
        onChanged: (String newVal) {
          setState(() {
            convertPriorityToInt(newVal);
          });
        },
      ),
    );
  }

  Widget getTextField(
      String label, String hint, TextEditingController myController) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (String newVal) {
          if(newVal.isEmpty){return "Please Fill That Field !";}
          if (label == 'Title') {
            UpdateTitle();
          } else {
            UpdateDescription();
          }
        },
        controller: myController,
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.deepPurple, fontSize: 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            labelText: "$label",
            hintText: "$hint"),
      ),
    );
  }

  Widget getRow() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 2.0),
                child: RaisedButton(
                  color: Colors.deepPurple,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      if(_formKey.currentState.validate())
                      _save();
                    });
                  },
                ))),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 2.0),
                child: RaisedButton(
                  color: Colors.deepPurple,
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _delete();
                    });
                  },
                )))
      ],
    );
  }

  void convertPriorityToInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String convertPriorityToString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _Piriorities[0];
        break;
      case 2:
        priority = _Piriorities[1];
        break;
    }

    return priority;
  }

  void UpdateTitle() {
    this.note.title = titleController.text;
  }

  void UpdateDescription() {
    this.note.descriptionp = descriptionController.text;
  }

  void _save() async {
    moveTolastScreen();
    this.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      //update
      result = await helper.updatetNote(note);
    } else {
      //insert
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog("Status", "Note Saved Sucessfully ");
    } else {
      _showAlertDialog("Status", "Error has occured  ");
    }
  }

  void _delete() async {
    moveTolastScreen();
    if (note.id == null) {
      _showAlertDialog("Status", "No Note To delete !");
      return;
    }

    int result = await helper.deletetNote(note.id);
    if (result != 0) {
      _showAlertDialog("Status", "Note Deleted Sucessfully ");
    } else {
      _showAlertDialog("Status", "Error Occured when delete");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void moveTolastScreen() {
    Navigator.pop(context, true);
  }
}
