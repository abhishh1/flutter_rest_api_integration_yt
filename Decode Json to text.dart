import 'dart:convert';
import 'package:apiUsage/Get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GetMethod());
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Dio dio = new Dio();
  Map<String, dynamic> dataModel;
  String mockData, title = '', body = '', userId = '', id = '';

  Future postData() async {
    final String pathUrl = 'https://jsonplaceholder.typicode.com/posts';

    dynamic data = {
      'title': 'Flutter Http post',
      'body': 'Flutter is awesome',
      'userId': 5000
    };

    var response = await dio.post(pathUrl,
        data: data,
        options: Options(headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }));
    setState(() {
      mockData = response.toString();
    }); 
    return response.data;
  }

  Future decodeData() async {
    final Map parsedData = await json.decode(mockData);
    setState(() {
      title = parsedData['title'];
      body = parsedData['body'];
      userId = parsedData['userId'].toString();
      id = parsedData['id'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.black,
                onPressed: () async {
                  print('Posting data...');
                  await postData().then((value) {}).whenComplete(() async {
                    await decodeData();
                  });
                },
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                  'The body of $title is $body and it has userId of $userId having an id of $id')
            ],
          ),
        ));
  }
}
