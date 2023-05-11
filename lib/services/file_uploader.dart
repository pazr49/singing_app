// a class that accepts a file and uploads it to a server using the http package

import 'dart:io';
import 'package:http/http.dart' as http;

//class called FileUploader
class FileUploader {

  final apiUrl = 'http://192.168.1.232:8000';

  //function to upload the file
  Future<String> uploadFile(File file) async {
    print('made it here1');

    //creating a multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl + '/upload'));
    print('made it here2');

    //adding the file to request
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    print('made it here3');

    //sending the request
    final response = await request.send();
    print(response.statusCode);
    print('made it here4');

    //getting the response from the server
    final responseString = await response.stream.bytesToString();
    print('made it here5');

    //returning the response
    return responseString;
  }

  //function that takes an array of files and uploads them to the server
  Future<String> uploadFiles(List<File> files) async {
    //creating a multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl + '/upload_files'));
    //adding the files to request
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }
    //sending the request
    final response = await request.send();
    //getting the response from the server
    final responseString = await response.stream.bytesToString();
    //returning the response
    return responseString;
  }

}


