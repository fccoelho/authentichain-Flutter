import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentichain',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
         // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Authenticate your object!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _filePath;
  Digest _fileDigest;
  List<Digest> _auths = [];



  Future<File> get _localFile async {
    // Asynchronous file getter
    return File(this._filePath);
  }

  void getFile() async {
    // selects a file to authenticate.
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }

      print("File path: " + filePath);

      setState((){this._filePath = filePath;});
      final file = await _localFile;
      this._fileDigest = sha256.convert(file.readAsBytesSync());
      setState(() {
        this._auths.add(this._fileDigest);
      });

    } on Exception catch (e) {
      print("Error while picking the file: " + e.toString());
    }
    print(this._auths);
  }

  Widget _authList(){
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: this._auths.length,
        itemBuilder: (BuildContext context, int index){
          var item = this._auths[index].toString();
          return InputChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              child: Icon(Icons.enhanced_encryption),
            ),
            label: Text(item.substring(0,40) + '...'),
            onPressed: (){
              print("selected $item");
            },
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
        body: _authList(),

      floatingActionButton: FloatingActionButton(
        onPressed: getFile,
        tooltip: 'Select file',
        child: Icon(Icons.sd_storage),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
