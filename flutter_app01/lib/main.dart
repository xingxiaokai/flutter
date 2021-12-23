import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/common/constant.dart';
import 'package:flutter_app01/navigator/tab_navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../getJsonData/Data.dart';
import 'package:device_info/device_info.dart';
import 'package:linker/linker.dart' as a;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        platform: TargetPlatform.android,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String version = "";
  TotalData data = TotalData();
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getDataSwitch();
    _deviceDetails();
    //WidgetsBinding.instance.addObserver(this);
  }

/*   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        print("从后台切换前台，界面可见");
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  } */

  /*  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  } */

//获取开关参数
  Future<void> getDataSwitch() async {
    try {
      Dio dio = Dio();
      String url = "${baseURL}code/variable/getVariable";
      //String url = "http://192.168.0.100/code/variable/getVariable";
      Map params = {
        "params": {"varName": "SAFE_MODE"}
      };
      Response response = await dio.post(url, data: params);
      switchData switchdata = switchData.fromJson(response.data);

      if (switchdata.code == 200) {
        if (switchdata.data == false) {
          getDataVersion();
          // _openWeiXin();
        } else {
          //跳转微信
          _openWeiXin();
        }
      } else {
        //提示服务器错误
        Fluttertoast.showToast(
            msg: "服务器错误", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "服务器连接错误", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
    }
  }

//获取版本参数
  Future<void> getDataVersion() async {
    try {
      Dio dio = Dio();
      String url = "${baseURL}code/admin/getNewVersion";

      Map paramsAndroid = {
        "params": {"versionType": "lite-android"}
      };
      Map paramsIos = {
        "params": {"versionType": "lite-ios"}
      };
      Response response = await dio.post(url, data: paramsIos);

      //获取版本信息，查看是否需要更新

      data = TotalData.fromJson(response.data);
      //print(data.versionData.versionType);
      //print(VersionData.oldversionId + "1");
      if (data.versionData.versionType == "lite-android") {
        if (int.parse(VersionData.oldversionId) <
            int.parse(data.versionData.newversionId)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示！"),
                  content: Text("检测到新版本，更新后才能使用"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _lancherApp();
                        },
                        child: Text("立即更新")),
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text("稍后再说")),
                  ],
                );
              });
        } else {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new TabNavigator();
          }));
          /* Fluttertoast.showToast(
              msg: "服务器错误",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3); */
        }
      } else if (data.versionData.versionType == "lite-ios") {
        if (int.parse(VersionData.oldversionId) !=
            int.parse(data.versionData.newversionId)) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示！"),
                  content: Text("检测到新版本，是否更新？"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _lancherApp();
                        },
                        child: Text("立即更新")),
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text("稍后再说")),
                  ],
                );
              });
        } else {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new TabNavigator();
          }));
          /* Fluttertoast.showToast(
              msg: "服务器错误",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3); */
        }
      }

      //print(data.versionData.versionId);
      //print(VersionData.oldversionId + "2");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "服务器连接错误", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 10);
    }
  }

//调用浏览器下载app
  _lancherApp() async {
    if (data.versionData.versionType == "lite-android") {
      var url = data.versionData.versionUrl;
      if (await canLaunch(url)) {
        await launch(url);
        VersionData.oldversionId = data.versionData.newversionId;
        print(VersionData.oldversionId + "3");
      } else {
        Fluttertoast.showToast(
            msg: "无法加载", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
      }
    } else if (data.versionData.versionType == "lite-ios") {
      var url = data.versionData.versionUrl;
      if (await canLaunch(url)) {
        await launch(url);
        setState(() {
          VersionData.oldversionId = data.versionData.newversionId;
        });
      } else {
        Fluttertoast.showToast(
            msg: "无法加载", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
      }
    }
  }

//启动微信
  void _openWeiXin() async {
    /* try {
      const url = 'weixin://'; //这个url就是由scheme和host组成的 ：scheme://host
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e", gravity: ToastGravity.CENTER, timeInSecForIosWeb: 3);
    } */
    if (Platform.isAndroid) {
      //判断是否是android平台
      try {
        await a.Linker.startActivity(new a.Intent.callApp(
            packageName: "com.tencent.mm",
            className: "com.tencent.mm.ui.LauncherUI"));
      } on PlatformException catch (e) {
        print("Open failed $e");
      }
    } else if (Platform.isIOS) {
      try {
        await a.Linker.openURL("weixin://");
      } on PlatformException catch (e) {
        print("Open failed $e");
      }
    }
  }

  //创建设备uuid
  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
          deviceVersion = build.version.toString();
          identifier = build.androidId;
          Fluttertoast.showToast(
              msg: deviceName + deviceVersion + identifier,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3);
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;

          print(deviceName + deviceVersion + identifier);
        }); //UUID for iOS
      }
    } catch (e) {
      print('Failed to get platform version');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "images/wechat_splash.png",
            fit: BoxFit.cover,
          ),
        ),
      ],
    ));
    /* return Scaffold(
        appBar: AppBar(
          title: Text("1"),
        ),
        body: Column(
          children: [
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    getDataVersion();
                  },
                  child: Text("dianji")),
            ),
            Text("${VersionData.oldversionId}")
          ],
        )); */
  }
}


/* class MainPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        platform: TargetPlatform.android,
      ),
      debugShowCheckedModeBanner: false,
      home: TabNavigator(),
    );
  }
} */
