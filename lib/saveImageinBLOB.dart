// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:save_image_in_blob/database.dart';
import 'package:save_image_in_blob/pictureModalClass.dart';

class saveImageSqfLite extends StatefulWidget {
  const saveImageSqfLite({Key? key}) : super(key: key);

  @override
  _saveImageSqfLiteState createState() => _saveImageSqfLiteState();
}

class _saveImageSqfLiteState extends State<saveImageSqfLite> {
  Future<File>? imageFile;
  Image? image;
  DatabaseHelper? databaseHelper;
  List<Picture>? listOfPhotoImages;

  @override
  void initState() {
    super.initState();
    listOfPhotoImages = [];
    databaseHelper = DatabaseHelper();
    refreshImages();
  }

  refreshImages() {
    databaseHelper!.getPictures().then((imgs) {
      setState(() {
        listOfPhotoImages!.clear();
        listOfPhotoImages!.addAll(imgs);
      });
    });
  }

  Image retrieveImage(Picture picture) {
    return Image.memory(
      picture.picture!,
      fit: BoxFit.fill,
    );
  }

  pickImageFromGallery() {
    ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((XFilefromImagepicker) async {
      Uint8List uint8list = await XFilefromImagepicker!.readAsBytes();
      Picture picture = Picture(0, uint8list);
      databaseHelper!.savePicture(picture);
      refreshImages();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: listOfPhotoImages!.map((picture) {
            return retrieveImage(picture);
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Save Image in SQLLite'),
        actions: [
          IconButton(
              onPressed: () {
                pickImageFromGallery();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Flexible(child: gridView())],
        ),
      ),
    );
  }
}
