import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetMethod extends StatefulWidget {
  @override
  _GetMethodState createState() => _GetMethodState();
}

class _GetMethodState extends State<GetMethod> {
  Dio dio = new Dio();
  List<dynamic> dataList;
  String mockData;

  Future getData() async {
    final String pathUrl = 'https://jsonplaceholder.typicode.com/posts';

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions option) async {
      var headers = {
        'Content-type': 'application/json; charset=UTF-8',
        'Accept': 'application',
        //'Authorization':'Bearer $token'
      };
      option.headers.addAll(headers);
      return option.data;
    }));

    Response response = await dio.put(pathUrl);
    setState(() {
      mockData = response.toString();
    });
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(
            child: MaterialButton(
          color: Colors.deepOrangeAccent,
          onPressed: () async {
            print('Getting data...');
            await getData().then((value) {
              print(value.toString());
            });
          },
          child: Text('Get'),
        )));
  }
}
