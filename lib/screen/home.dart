import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uwlaa/screen/business_business_home.dart';
import 'package:uwlaa/screen/business_consumer_home.dart';
import 'package:uwlaa/screen/web/seller_registration_web.dart';
import 'package:uwlaa/util/ui_icons.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId = "";
  String fullName = "";
  String signupType = "";
  String email = "";
  String sellerId = "";
  bool isSeller = false;
  List<dynamic> _shopList = List<dynamic>();

  int _selectedBottomIndex = 0;

  final RefreshController _refreshController = RefreshController();

  YYDialog yyProgressDialogNoBody() {
    return YYDialog().build()
      ..width = 200
      ..borderRadius = 4.0
      ..circularProgress(
        padding: EdgeInsets.all(24.0),
        valueColor: Colors.orange[500],
      )
      ..barrierDismissible = false
      ..text(
        padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
        text: "Please wait...",
        alignment: Alignment.center,
        color: Colors.orange[500],
        fontSize: 18.0,
      );
  }

  @override
  void initState() {
    super.initState();
    initPreferences();
    Future.delayed(Duration.zero).then((value) {
      var dialog = yyProgressDialogNoBody();
      _initHome(dialog);
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }

  initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    fullName = prefs.getString('name');
    email = prefs.getString('email');
    signupType = prefs.getString('signup_type');
    sellerId = prefs.getString('seller_id');
    setState(() {});
  }

  Future<void> _initHome(YYDialog dialog) async {
    _shopList = [];
    dialog.show();
    var url =
        "https://us-central1-uwlaamart.cloudfunctions.net/httpFunction/api/v1/mobileHomeInit";
    Map data = {"user_id": userId};
    var body = json.encode(data);
    http
        .post(url, headers: {"Content-Type": "application/json"}, body: body)
        .then((response) {
      dialog.dismiss();
      var resp = json.decode(response.body);
      if (resp["status"] == 'OK') {
        print("OK");
        isSeller = resp["is_seller"];
        print(resp["is_seller"]);
        print(resp["shop_list"].runtimeType.toString());
        print("sellerIdType " + sellerId.runtimeType.toString());
        for (var item in resp["shop_list"]) {
          _shopList.add({
            "shop_name": item["shop_name"],
            "shop_logo": item["shop_logo"],
            "shop_id": item["shop_id"]
          });
          print(item["shop_name"]);
        }
      } else {
        print("ERROR");
      }
    }).catchError((onError) {
      dialog.dismiss();
      print(onError.toString());
    });
  }

  Widget _createNews(String image, String title, int index) {
    return Container(
      margin: index % 2 == 0
          ? EdgeInsets.only(left: 10.0)
          : EdgeInsets.only(right: 10.0),
      child: Card(
        elevation: 2.0,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            children: <Widget>[
              Container(
                height: 150.0,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(43.0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.black,
                  margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '📖 1 min read',
                      style: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: ScreenUtil().setSp(35.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _becomeSellerDialog() {
    var confirm = AlertDialog(
      title: Text(
        "Sorry! Wholesale session only applicable to business.",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(
            50.0,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(50.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            'Apply Business Account',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(50.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerRegistrationWeb(),
              ),
            );
          },
        ),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return confirm;
        });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).primaryColor);
    Widget homeWidget = SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: MaterialClassicHeader(
          color: Colors.orange,
          backgroundColor: Colors.white,
        ),
        onRefresh: () async {
          _refreshController.refreshCompleted();
          var dialog = yyProgressDialogNoBody();
          _initHome(dialog);
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Container(
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    "Uwlaa",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(75.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        // border: Border.all(width: 0.5),
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Rank",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(45.0),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Points",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(45.0),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(7.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  if (isSeller) {
                                    if (sellerId.runtimeType.toString() !=
                                        "Null") {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessBusinessHome(),
                                        ),
                                      );
                                      setState(() {});
                                    } else {
                                      // Only got one shop
                                      if (_shopList.length < 2) {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setString(
                                          "shop_id",
                                          _shopList[0]["shop_id"],
                                        );
                                        await prefs.setString("shop_logo",
                                            _shopList[0]["shop_logo"]);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BusinessBusinessHome(),
                                          ),
                                        );
                                        setState(() {});
                                      } else {
                                        // More than 1 shop TODO: Add dialog to choose default
                                      }
                                      print(_shopList[0]["shop_id"]);
                                    }
                                  } else {
                                    print("Not seller");
                                    _becomeSellerDialog();
                                  }
                                },
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage('assets/b2b.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Wholesale",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(45.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BusinessConsumerHome(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage('assets/b2c.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Mall",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(45.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {},
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage('assets/pray.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Solat",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(45.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {},
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Center(
                                    child: Image(
                                      image: AssetImage('assets/tender.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Tender",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(45.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                  left: 7.0,
                  right: 7.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {},
                                child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/delivery.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Delivery",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(45.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Text(
                  'Keep Discovering',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(45.0),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              children: <Widget>[
                _createNews("assets/pizza.jpg", "Free pIZAA Free pIZAA", 0),
                _createNews("assets/newnorm.jpg", "New Norm in the office", 1),
                _createNews("assets/newnorm.jpg", "New Norm in the office", 2),
                _createNews("assets/pizza.jpg", "Free pIZAA Free pIZAA", 3),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10.0),
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: PreferredSize(
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      body: IndexedStack(
        index: _selectedBottomIndex,
        children: <Widget>[
          homeWidget,
          Container(),
          homeWidget,
          homeWidget,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black87,
        currentIndex: _selectedBottomIndex,
        onTap: _onBottomNavTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(UiIcons.compass),
            title: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.atomic),
            title: Text(
              "News",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.message_1),
            title: Text(
              "Message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.user_1),
            title: Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
