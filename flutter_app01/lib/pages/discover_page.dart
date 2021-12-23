import 'package:flutter/material.dart';
import 'package:flutter_app01/common/constant.dart';
import 'package:flutter_app01/pages/browser.dart';
import '../model/discover_model.dart';
import '../api/discover_api.dart';
import 'package:flutter_easy_permission/constants.dart';
import 'package:flutter_easy_permission/flutter_easy_permission.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'dart:async';
import 'package:flutter/services.dart';

const _permissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

const _permissionGroup = const [PermissionGroup.Camera, PermissionGroup.Photos];

/// 发现页面
class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHomePage();
  }
}

class StateHomePage extends State<DiscoverPage> {
  String _imgUrl = baseURL;
  String uuid = identifier;
  bool isCustom;
  FlutterScankit scanKit;
  String code = "";

  /// 新消息的头像缩略图
  List<DiscoverModel> _discoverModel = [];

  @override
  void initState() {
    super.initState();

    /// 模拟请求数据
    _discoverModel.addAll(DiscoverApi().mock());
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      debugPrint("scanning result:$val");
      setState(() {
        code = Uri.encodeComponent(val);
        //print("${_imgUrl}code/lite/greenCode?url=${this.code}&uuid=${uuid}");

        if (this.code != "") {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new Browser(
              url:
                  "${_imgUrl}code/lite/greenCode?url=${this.code}&uuid=${uuid}",
              title: "东北大学验证平台",
            );
          }));
        }
      });
    });
  }

  @override
  void dispose() {
    scanKit.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
  }

  Future<void> getScan() async {
    isCustom = false;
    if (!await FlutterEasyPermission.has(
        perms: _permissions, permsGroup: _permissionGroup)) {
      FlutterEasyPermission.request(
          perms: _permissions, permsGroup: _permissionGroup);
    } else {
      startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(
      _titleBar(),
    );

    _discoverModel.forEach((o) {
      list.add(
          _discoverItem(assets: o.assets, title: o.title, imgUrl: o.imgUrl));
      if (o.isDownDivider) {
        list.add(Container(
          height: 10,
          color: Color(0xffededed),
        ));
      } else {
        list.add(Divider(
          height: 1,
          color: Colors.grey[400],
          indent: 70,
        ));
      }
    });
    return Scaffold(
//      backgroundColor: Color(THEME_COLOR),
      body: SingleChildScrollView(
        child: Column(
          children: list,
        ),
      ),
    );
  }

  /// 每一个发现导航Item
  Widget _discoverItem(
      {String assets, String title, String imgUrl, bool isBadge = true}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (title == "扫一扫") {
          await getScan();
        }
        if (title == "摇一摇") {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new Browser(
              url: "${_imgUrl}code/lite/health?uuid=${uuid}",
              title: "东北大学健康上报平台",
            );
          }));
        }
      },
      child: Container(
        height: 50,
        width: double.maxFinite,
        padding: EdgeInsets.only(bottom: 7, top: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, right: 20),
                  child: Image.asset(
                    assets,
                    height: 28,
                    width: 28,
                  ),
                ),
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                imgUrl != null
                    ? Container(
                        height: 43,
                        width: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                imgUrl,
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipOval(
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 15,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 标题栏
  _titleBar() {
    return Container(
        color: Color(0xffebebeb),
        height: 100,
        child: Padding(
            padding: EdgeInsets.only(top: 60, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "发现",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )));
  }
}
