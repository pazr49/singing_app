// a class that accepts a file and uploads it to a server using the http package
import 'dart:async';

import 'package:my_app/services/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

//class called FileUploader
class FileUploader {


  Future<String> pingServer() async {
    print("pinging server");
    final response = await http.get(Uri.parse(apiUrl));
    return response.body;
  }
  //function to upload the file
  Future<String> uploadFile(File file) async {
    //creating a multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl + '/upload'));

    //adding the file to request
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    //sending the request
    final response = await request.send();
    print(response.statusCode);

    //getting the response from the server
    final responseString = await response.stream.bytesToString();

    //returning the response
    return responseString;
  }

  //function that takes an array of files and uploads them to the server
  Future<String> uploadFiles(List<String> files) async {
    print("uploading files");
    //creating a multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl + '/upload_files'));

    print (files);
    //adding the files to request
    for (var file in files) {
      if (file == '' ) {
        continue;
      }
      request.files.add(await http.MultipartFile.fromPath('file', file));
    }
    //sending the request
    final response = await request.send();
    //getting the response from the server
    final responseString = await response.stream.bytesToString();
    //returning the response
    print("done uploading files");
    return responseString;
  }

}




