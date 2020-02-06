import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;


void main() => runApp(FirbaseStorageApp());

class FirbaseStorageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStorage(title: 'Flutter Firebase Storage'),
    );
  }
}

class MyStorage extends StatefulWidget {
  MyStorage({Key key, this.title}) : super(key: key);
 final String title;

  @override
  StorageState createState() => StorageState();
}

class StorageState extends State<MyStorage> {
File _imageFile;

Future getImage() async{
  var tempFile= await ImagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _imageFile=tempFile;
  });
  
}

Future uploadPic(BuildContext context) async{
  String filename= Path.basename(_imageFile.path);
  StorageReference storageReference = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask storageUploadTask =storageReference.putFile(_imageFile);
  StorageTaskSnapshot  storageTaskSnapshot = await storageUploadTask.onComplete;
  setState(() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully"),backgroundColor: Colors.green[100],));
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
           SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.blue,
                    child: ClipOval(
                      child:SizedBox(
                        height: 180,
                        width: 180,
                        child: (_imageFile!=null)?
                        Image.file(_imageFile,fit: BoxFit.fill,)
                        :Image.network('https://flutter.dev/images/catalog-widget-placeholder.png',fit: BoxFit.fill,),
                      )

                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:60.0),
                  child: IconButton(
                    icon:Icon(
                      FontAwesomeIcons.camera,
                      size: 30.0,
                    ),
                    onPressed: (){
                      getImage();

                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.cyan,
                  onPressed: (){
                    uploadPic(context);
                  },
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  child: Text(
                    'Upload',style: TextStyle(color: Colors.white,fontSize: 16.0),
                  ),
                )
              ],
            )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
