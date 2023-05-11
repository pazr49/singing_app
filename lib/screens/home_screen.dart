import 'package:flutter/material.dart';
import 'package:my_app/screens/camera_from_scratch.dart';
import 'package:my_app/services/file_uploader.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filepath_1 = '';
  String filepath_2 = '';

  FileUploader fileUploader = FileUploader();

  setFilePath(String path, num fileNumber) {
    fileNumber == 1 ?
    setState(() {filepath_1 = path;}) :
    setState(() {filepath_2 = path;}
    );
  }


  Future<void> _uploadFile() async {
    fileUploader.uploadFile(File(filepath_1)).then((value) {
      print(value);
    });
  }

  Future<void> _uploadFiles() async {
    fileUploader.uploadFiles(List<File>.from([File(filepath_1), File(filepath_2)])).then((response) {
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World App'),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                child: Text('File 1'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraFromScratch(
                                setFilePath: setFilePath,
                                fileNumber: 1,
                          ))
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text('File 2'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraFromScratch(
                            setFilePath: setFilePath,
                            fileNumber: 2,
                          ))
                  );
                },
              ),
            ),
            Center(
              child: filepath_1 == '' ? Text('No file 1 selected') :
              Text(filepath_1),
            ),
            Center(
              child: filepath_2 == '' ? Text('No file 2 selected') :
              Text(filepath_2),
            ),
            Center(
              child: ElevatedButton(
                child: Text('Upload files'),
                onPressed: filepath_1 == '' || filepath_2 == '' ? null : () {
                 _uploadFiles();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
