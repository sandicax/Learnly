import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:esprit/src/utils/my_urls.dart';
import 'package:esprit/static.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File("/" + pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(File imageFile) async {
    // open a bytestream

    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("${MyUrls.serverUrl}/updateImg");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.fields['lol'] = Userutils.email;
    request.fields['email'] = Userutils.email;
    Userutils.profilepic = Userutils.email + ".png";
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  bool isloaded = false;
  var result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton.icon(
              onPressed: () async => await getImage(),
              icon: Icon(Icons.upload_file),
              label: Text(" Browse Picture")),
          SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () => upload(_image),
              icon: Icon(Icons.upload_rounded),
              label: Text(" Upload now")),
        ],
      ),
    );
  }
}
