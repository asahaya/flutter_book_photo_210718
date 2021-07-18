import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_photo_210718/photo_list_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
// メールアドレス用のTextEditingController
final TextEditingController _emailController = TextEditingController();
// パスワード用のTextEditingController
final TextEditingController _passwordController = TextEditingController();

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "photo App",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    //アドレス入力なし
                    if (value?.isEmpty == true) {
                      return "メールアドレスを入力してください";
                    }
                    //問題がない時はNullで返す
                    return null;
                  },
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "パスワード"),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      //問題がある
                      return "パスワードを入力してください";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onSignIn(),
                    child: Text("ログイン"),
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onSignUp(),
                    child: Text("新規登録"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    try {
      if (_formkey.currentState?.validate() != true) {
        return;
      }
      // 新規登録と同じく入力された内容をもとにログイン処理を行う
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PhotoListScreen(),
        ),
      );
      print("成功");
    } catch (e) {
      // 失敗したらエラーメッセージを表示
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.toString()),
          );
          print("失敗");
        },
      );
    }
  }

  Future<void> _onSignUp() async {
    try {
      if (_formkey.currentState?.validate != true) {
        return;
      }
      // メールアドレス・パスワードで新規登録
      //   TextEditingControllerから入力内容を取得
      //   Authenticationを使った複雑な処理はライブラリがやってくれる
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PhotoListScreen(),
        ),
      );
      print("成功");
    } catch (e) {
      // 失敗したらエラーメッセージを表示
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.toString()),
          );
          print("失敗");
        },
      );
    }
  }
}
