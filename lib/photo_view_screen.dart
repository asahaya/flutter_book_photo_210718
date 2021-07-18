import 'package:flutter/material.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({
    Key? key,
    //requiredを付けると必須パラメーターという意味になる
    required this.imageURL
});

  //最初に表示する画像のURLを受け取る
  final String imageURL;

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _controller;

  // ダミー画像一覧
  final List<String> imageList = [
    'https://placehold.jp/400x300.png?text=0',
    'https://placehold.jp/400x300.png?text=1',
    'https://placehold.jp/400x300.png?text=2',
    'https://placehold.jp/400x300.png?text=3',
    'https://placehold.jp/400x300.png?text=4',
    'https://placehold.jp/400x300.png?text=5',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final int initialPage=imageList.indexOf(widget.imageURL);
    _controller=PageController(
      initialPage: initialPage,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarの裏までbodyの表示エリアを広げる
      extendBodyBehindAppBar: true,
      //透明Appber
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          //画像一覧
          PageView(
            controller: _controller,
            onPageChanged: (int index)=>{},
            children: imageList.map((String imageURL){
              return Image.network(
                imageURL,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,

                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: [0.0,1.0],
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: ()=>{}, icon: Icon(Icons.share)),
                  IconButton(onPressed: ()=>{}, icon: Icon(Icons.delete)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
