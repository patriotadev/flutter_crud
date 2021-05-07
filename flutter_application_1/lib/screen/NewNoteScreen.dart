import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';
import 'package:flutter_application_1/Note.dart';
import 'package:flutter_application_1/main.dart';

class NewNoteScreen extends StatefulWidget {
  final Note oldNote;

  NewNoteScreen({Key key, this.oldNote}) : super(key: key);

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  var dbHelper;
  var updateMode = false;
  final _noteForm = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();

    if (widget.oldNote != null) {
      setUpdateNote(widget.oldNote);
    }
  }

  setUpdateNote(oldNote) {
    updateMode = true;
    titleController.text = oldNote.title.toString();
    bodyController.text = oldNote.body.toString();
  }

  submitNote(context) async {
    if (_noteForm.currentState.validate()) {
      if (updateMode == true) {
        final newNote = Note(
            id: widget.oldNote.id,
            title: titleController.text,
            body: bodyController.text);

        await dbHelper.updateNote(newNote).then({
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()))
        });
      } else {
        final newNote =
            Note(title: titleController.text, body: bodyController.text);

        await dbHelper.saveNote(newNote).then({
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()))
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Container(
        padding: EdgeInsets.only(right: 20, top: 40, left: 20),
        child: Form(
          key: _noteForm,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration:
                    InputDecoration(labelText: 'Judul', hintText: 'Isi Judul'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some title.';
                  }
                },
              ),
              TextFormField(
                controller: bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: 'Isi', hintText: 'Isi Catatan..'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter notes.';
                  }
                },
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => submitNote(context),
                  child: Text(
                    updateMode ? 'Update' : 'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
