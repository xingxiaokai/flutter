import 'package:flutter/material.dart';
import 'package:flutter_app01/common/constant.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Browser extends StatefulWidget {
  Browser({Key key, this.url, this.title}) : super(key: key);
  final String url;
  final String title;

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  double lineProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      print(progress);
      setState(() {
        lineProgress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(BG_COLOR),
            title: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: Colors.black87,
                )),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz_outlined,
                    size: 20,
                    color: Colors.black87,
                  ))
            ],
            bottom: PreferredSize(
              child: _progressBar(lineProgress, context),
              preferredSize: Size.fromHeight(0.1),
            ),
          ),
          preferredSize: Size.fromHeight(50)),
      url: widget.url,
    );
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      minHeight: 1.0,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}




/* class Browser extends StatelessWidget {
  const Browser({Key? key, required this.url, this.title}) : super(key: key);

  final String url;
  final String? title;




  @override
  Widget build(BuildContext context) {
     return Scaffold(
         appBar: AppBar(
        title: Text(title!),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ), 
        body: Column(
      children: [
        _titleBar(),
        WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        )
      ],
    )); *
    
  }




//标题栏
  _titleBar() {
    return Container(
        height: 70,
        color: Color(BG_COLOR),
        child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.clear,
                    size: 23,
                  ),
                ),
                /* Padding(
                  padding: EdgeInsets.only(left: 15),
                ), */
                Container(
                  child: Text(
                    "东北大学验证平台",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      //fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      child: Icon(
                        Icons.more_horiz,
                        size: 23,
                        color: Colors.black87,
                      ),
                    ))
              ],
            )));
  }
}
 */