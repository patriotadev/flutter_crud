import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';
import 'Note.dart';
import 'database.dart';
import 'screen/NewNoteScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Note>> notes;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loadNotes();
  }

  loadNotes() {
    setState(() {
      notes = dbHelper.getNotes();
    });
  }

  editNote(context, currentItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewNoteScreen(oldNote: currentItem)));
  }

  removeNote(noteId) {
    dbHelper.deleteNote(noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
      ),
      body: FutureBuilder(
        future: notes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // success
            if (snapshot.data.length == 0)
              return Center(
                child: Text('still empty'),
              );
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final currentItem = snapshot.data[index];

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                        ),
                        child: ListTile(
                          title: Text('${currentItem.title}'),
                          onTap: () => editNote(context, currentItem),
                        ),
                        onDismissed: (direction) => removeNote(currentItem.id),
                      );
                    }));
          } else if (snapshot.hasError) {
            // error
            return Center(
              child: Text('error fetching note'),
            );
          } else {
            // loading
            return CircularProgressIndicator();
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewNoteScreen()));
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
