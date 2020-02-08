import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File file;

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }

  Container buildSplashScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: SvgPicture.asset(
              'assets/images/upload.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
          ),
          Padding(
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Upload The Look',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onPressed: () => selectImage(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: EdgeInsets.only(top: 20),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      color: Theme.of(context).accentColor.withOpacity(0.6),
    );
  }

  Center buildUploadForm() {
    return Center(
      child: Text('Uploaded $file'),
    );
  }

  void handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      maxHeight: 675,
      maxWidth: 960,
      source: ImageSource.camera,
    );
    setState(() => this.file = file);
  }

  void handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this.file = file);
  }

  selectImage(BuildContext parentContext) {
    return showDialog(
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              child: Icon(
                Icons.camera_alt,
                size: 35,
              ),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Icon(
                Icons.image,
                size: 35,
              ),
              onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          title: Text(
            'Look Source',
            textAlign: TextAlign.center,
          ),
        );
      },
      context: parentContext,
    );
  }
}
