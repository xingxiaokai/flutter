import 'package:flutter_app01/common/constant.dart';
import 'package:flutter_app01/model/discover_model.dart';

class DiscoverApi {
  String baseimgUrl = baseURL;
  String uuid = identifier;
  List<DiscoverModel> mock() {
    List<DiscoverModel> _discoverModel = [];
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_social_circle.png",
        title: "朋友圈",
        imgUrl: "${baseimgUrl}/code/lite/avatar?uuid=${uuid}",
        isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_bottle_msg.png", title: "漂流瓶", isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_quick_scan.png",
        title: "扫一扫",
        isDownDivider: false));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_shake_phone.png",
        title: "摇一摇",
        isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_feeds.png", title: "看一看", isDownDivider: false));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_quick_search.png",
        title: "搜一搜",
        isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_people_nearby.png",
        title: "附近的人",
        isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_shopping.png", title: "购物", isDownDivider: false));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_game_entry.png", title: "游戏", isDownDivider: true));
    _discoverModel.add(DiscoverModel(
        assets: "images/ic_mini_program.png",
        title: "小程序",
        isDownDivider: true));
    return _discoverModel;
  }
}
