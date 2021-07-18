import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_photo_210718/photo_view_screen.dart';
import 'package:flutter_book_photo_210718/sign_in_screen.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  late int _currentIndex;
  late PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // PageViewで表示されているWidgetの番号を持っておく
    _currentIndex = 0;
    // PageViewの表示を切り替えるのに使う
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("photo App"),
        actions: [
          IconButton(
            onPressed: ()=> _onSignOut(),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        //表示が切り替わった時
        onPageChanged: (int index) => _onPageChanged(index),
        children: [
          Container(
            child: Center(
              child: Text("page:photo"),
            ),
          ),
          PhotoGridView(
            onTap: (imageURL) => _onTapPhoto(imageURL),
          ),
          Container(
            child: Center(
              child: Text("page:favorite"),
            ),
          ),
          PhotoGridView(
            onTap: (imageURL) => _onTapPhoto(imageURL),
          ),
        ],
      ),
      // 画像追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBarItemがタップされたときの処理
        //   0: フォト
        //   1: お気に入り
        onTap: (int index) =>  _onTapBottomNavigationItem(index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "photo"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "favorite"),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    // PageViewで表示されているWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });

  }

  void _onTapBottomNavigationItem(int index) {
    _controller.animateToPage(
    index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn);
    setState(() {
      _currentIndex=index;
    });
  }

  void _onTapPhoto(String imageURL) {
    // 最初に表示する画像のURLを指定して、画像詳細画面に切り替える
    Navigator.of(context).push(
        MaterialPageRoute(
        builder: (_) => PhotoViewScreen(imageURL: imageURL),),);
  }

  Future<void> _onSignOut() async {
    await FirebaseAuth.instance.signOut();
    // ログアウトに成功したらログイン画面に戻す
    //   現在の画面は不要になるのでpushReplacementを使う
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInScreen(),
      ),
    );
  }
}

class PhotoGridView extends StatelessWidget {

  const PhotoGridView({
    Key? key,
    required this.onTap,
});

  final void Function(String imageURL) onTap;

  @override
  Widget build(BuildContext context) {
    // ダミー画像一覧
    final List<String> imageList = [
      'https://placehold.jp/400x300.png?text=0',
      'https://placehold.jp/400x300.png?text=1',
      'https://placehold.jp/400x300.png?text=2',
      'https://placehold.jp/400x300.png?text=3',
      'https://placehold.jp/400x300.png?text=4',
      'https://placehold.jp/400x300.png?text=5',
    ];

    // GridViewを使いタイル状にWidgetを表示する
    return GridView.count(
      // 1行あたりに表示するWidgetの数
      crossAxisCount: 2,
      // Widget間のスペース（上下）
      mainAxisSpacing: 8,
      // Widget間のスペース（左右）
      crossAxisSpacing: 8,
      // 全体の余白
      padding: const EdgeInsets.all(8),
      // 画像一覧
      children: imageList.map((String imageURL) {
        // Stackを使いWidgetを前後に重ねる
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              // Widgetをタップ可能にする
              child: InkWell(
                onTap: () => onTap(imageURL),
                // URLを指定して画像を表示
                child: Image.network(
                  imageURL,
                  // 画像の表示の仕方を調整できる
                  //  比率は維持しつつ余白が出ないようにするので cover を指定
                  //  https://api.flutter.dev/flutter/painting/BoxFit-class.html
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 画像の上にお気に入りアイコンを重ねて表示
            //   Alignment.topRightを指定し右上部分にアイコンを表示
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {},
                color: Colors.white,
                icon: Icon(Icons.favorite_border),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
