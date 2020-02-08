import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  final User currentUser;

  Upload({this.currentUser});

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

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () => print('Save button pressed'),
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: clearImage),
        title: Text(
          'New Look',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
            height: 0.5 * MediaQuery.of(context).size.height,
            width: 0.8 * MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: Container(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Look description',
                ),
              ),
              width: 250,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
            title: Container(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Location',
                ),
              ),
              width: 250,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                'Current location',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => print('Get user location'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            height: 100,
            width: 200,
          ),
        ],
      ),
    );
  }

  void clearImage() {
    setState(() => file = null);
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
