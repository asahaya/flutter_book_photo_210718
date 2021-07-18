import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_photo_210718/photo_list_screen.dart';
import 'package:flutter_book_photo_210718/sign_in_screen.dart';

void main() async {
  // Flutterの初期化処理を待つ
  WidgetsFlutterBinding.ensureInitialized();

  // アプリ起動前にFirebase初期化処理を入れる
  //   initializeApp()の返り値がFutureなので非同期処理
  //   非同期処理(Future)はawaitで処理が終わるのを待つことができる
  //   ただし、awaitを使うときは関数にasyncを付ける必要がある
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"photo-stock",
      theme: ThemeData.dark(),
      home: FirebaseAuth.instance.currentUser == null
          ? SignInScreen()
          : PhotoListScreen(),
    );
  }
}
