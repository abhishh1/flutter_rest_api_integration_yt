import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:partner/Screens/New_Home_Page_Screen/New_Home_page.dart';
import 'package:partner/Screens/SplashScreen.dart';

class DecodeData extends StatefulWidget {
  @override
  _DecodeDataState createState() => _DecodeDataState();
}

class _DecodeDataState extends State<DecodeData> {
  String mockStringData;
  List<dynamic> allModel;

  @override
  void initState() {
    getData().whenComplete(() async {
      await decodeData();
    });
    super.initState();
  }

  Future getData() async {
    var dio = Dio();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      var headers = {
        'Accept': 'Application/json',
        'Authorization': 'Bearer $finalToken',
        'Content-Type': 'application/json;charset=UTF-8',
      };
      options.headers.addAll(headers);
      return options.data;
    }));

    Response response = await dio.get(urlPath);
    setState(() {
      mockStringData = response.toString();
    });
    return response.data;
  }

  Future decodeData() async {
    final Map parsedData = await json.decode(mockStringData);
    setState(() {
      allModel = parsedData['data']['all-leads'];
    });
    print(allModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getData().then((value) {}).whenComplete(() async {
            await decodeData();
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: FutureBuilder(
          future: getData().whenComplete(() async {
            await decodeData();
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.black));
            }
            return ListView.builder(
              itemCount: allModel.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(allModel[index]['credit'].toString()),
                    subtitle: Text(allModel[index]['id'].toString()),
                    trailing: Text(allModel[index]['delivery_date'].toString()),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
