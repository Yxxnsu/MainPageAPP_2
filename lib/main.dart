import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page Num1',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _PageOnboardBankState createState() => _PageOnboardBankState();
}

class _PageOnboardBankState extends State<HomePage> {
  // var
  final PageController _controller = PageController(initialPage: 0);
  Color colorMain = Colors.deepPurple;
  Color colorAccent = Colors.white;
  List<Widget> _pages = [];
  IconData incons = Icons.clear;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      pageInformacion(
          context: context,
          colorIcon: colorAccent,
          iconData: Icons.phone_android,
          title: "스마트폰을 이용해보세요!",
          subTitle: "스마트폰을 사용할 수 있을까요?\n군대에서는 사용할 수 없을거에요!"),
      pageInformacion(
          context: context,
          colorIcon: colorAccent,
          iconData: Icons.monetization_on,
          title: "환전을 해보세요!",
          subTitle: "해당 어플에서는\n바로바로 환전도 가능합니다!!"),
      pageInformacion(
          context: context,
          colorIcon: colorAccent,
          iconData: Icons.notifications_active,
          title: "할 일을 계획해보세요!",
          subTitle: "오늘 할 일을 바로바로 기록해보세요!\n미래를 설계하세요!"),
      pageButton(
          context: context,
          color: Colors.deepPurple,
          text: "You know it?",
          textoButton: "Take Button",
          colorText: colorAccent),
    ];

    colorMain = Theme.of(context).brightness == Brightness.dark
        ? Colors.deepPurple
        : Colors.deepPurple;

    return Scaffold(
      backgroundColor: colorMain,
      body: body(),
      floatingActionButton: dotsIndicator(pageController: _controller, pages: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// WIDGETS
  Widget body() {
    return PageView(
      controller: _controller,
      pageSnapping: true,
      scrollDirection: Axis.horizontal,
      children: _pages,
    );
  }

  // WIDGETS COMPONENT
  Widget dotsIndicator(
      {required PageController pageController, required List pages}) {
    return DotsIndicator(
      color: colorAccent,
      controller: pageController,
      itemCount: pages.length,
      onPageSelected: (int page) {
        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
    );
  }

  Widget pageInformacion(
      {required BuildContext context,
      Color colorIcon = Colors.white,
      Color colorText = Colors.white,
      required String title,
      IconData? iconData,
      String subTitle = ""}) {
    final mainTextStyle = TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.bold, color: colorText);
    final subTextStyle =
        TextStyle(fontSize: 20.0, color: colorText.withOpacity(0.5));

    //ScreenSize
    var screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          iconData != null
              ? Container(
                  width: screenSize.width / 2,
                  height: screenSize.height / 2,
                  child: Icon(iconData,
                      size: screenSize.width * 0.25, color: colorIcon),
                )
              : Container(),
          Text(title, style: mainTextStyle, textAlign: TextAlign.center),
          SizedBox(height: 12.0),
          Text(subTitle, style: subTextStyle, textAlign: TextAlign.center),
          SizedBox(height: 12.0),
          Expanded(child: Container()),
        ],
      ),
    ));
  }

  Widget pageButton(
      {required BuildContext context,
      required String text,
      required String textoButton,
      MaterialColor color = Colors.blue,
      Color colorText = Colors.white}) {
    final TextStyle mainTextStyle = TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.bold, color: colorText);

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: color,
      primary: color[300],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(text,
                    style: mainTextStyle, textAlign: TextAlign.center)),
            ElevatedButton(
              style: raisedButtonStyle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Text(textoButton,
                  style: TextStyle(fontSize: 20.0, color: colorText))),
                onPressed: () => _controller.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease),
            ),
          ],
        ),
      ),
    );
  }
}


class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      {required this.controller,
      required this.itemCount,
      required this.onPageSelected,
      this.color: Colors.white})
      : super(listenable: controller);
  
  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;

  
  static const double _kDotSize = 8.0;
  static const double _kMaxZoom = 2.0;
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(max(0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs()));
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      height: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(onTap: () => onPageSelected(index)),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
