import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/darkness_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingModel {
  String onBoardingImageAssetSrc;
  String onBoardingHeadline;
  String onBoardingDescription;

  OnBoardingModel({
    @required this.onBoardingImageAssetSrc,
    @required this.onBoardingHeadline,
    @required this.onBoardingDescription,
  });
}

class OnBoardingScreen extends StatefulWidget {
  static String id = "onBoarding Screen";

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  bool isLast = false;
  dynamic onBoardingData = [
    OnBoardingModel(
      onBoardingImageAssetSrc: "assets/images/explore_image.png",
      onBoardingHeadline: "Explore Our Platform",
      onBoardingDescription: "explore our app to see whats new in products and get updates every time.",
    ),
    OnBoardingModel(
      onBoardingImageAssetSrc: "assets/images/payment_ways.webp",
      onBoardingHeadline: "Easy Payment",
      onBoardingDescription: "there were different payment ways i.e Cash,Debit Card and Mobile Cash,Bank,Paypal",
    ),
    OnBoardingModel(
      onBoardingImageAssetSrc: "assets/images/fastest_delivery.webp",
      onBoardingHeadline: "Fastest Delivery",
      onBoardingDescription: "your order will arrive to you in shortest possible time",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                onStartUpLoading();
              },
              child: Text("SKIP"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () {
          isLast
              ? onStartUpLoading()
              : controller.nextPage(
              duration: Duration(milliseconds: 750),
              curve: Curves.fastLinearToSlowEaseIn);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageViewItem(),
            buildIndicator(),
          ],
        ),
      ),
    );
  }

  buildIndicator() {
    return SmoothPageIndicator(
        effect: ExpandingDotsEffect(
          spacing: 5,
          dotColor: Colors.grey,
          activeDotColor: defaultAppColor,
          dotWidth: 10,
          expansionFactor: 4,
          strokeWidth: 10,
        ),
        controller: controller,
        count: onBoardingData.length);
  }

  buildPageViewItem() {
    return Expanded(
      child: PageView.builder(
        onPageChanged: (value) {
          if (value == onBoardingData.length - 1) {
            setState(() {
              isLast = true;
            });
          } else {
            setState(() {
              isLast = false;
            });
          }
        },
        controller: controller,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(
                      onBoardingData[index].onBoardingImageAssetSrc,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  onBoardingData[index].onBoardingHeadline,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  onBoardingData[index].onBoardingDescription,
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
        itemCount: onBoardingData.length,
      ),
    );
  }

  onStartUpLoading() {
    CashHelper.putData(key: "onBoarding", value: true).then((value) {
      if (value) {
        doReplacementWidgetNavigation(context, ShopLoginScreen());
      }
    });
  }
}
