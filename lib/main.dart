import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  int userId;
  int id;
  String title;

  Album({required this.userId , required this.id , required this.title});

  factory Album.fromJson(Map<String , dynamic> json){
    return Album(userId: json['userId'] , id: json['id'] , title: json['title']);
  }
}

Future<Album> fetchData() async{
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if(response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Album');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Album>? album;
  @override
  void initState() {
    super.initState();
    album = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Album>(
              future: album,
              builder: (context , snapshot){
                if(snapshot.hasData){
                  return Text(snapshot.data!.title);
                } else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              })
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
