import 'package:clean_architecture/core/widgets/app_background.dart';
import 'package:clean_architecture/core/widgets/bottom_nav.dart';
import 'package:clean_architecture/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:clean_architecture/features/feature_weather/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';



class MainWrapper extends StatelessWidget {
   MainWrapper({Key? key}) : super(key: key);
final  pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {



    List <Widget> pageViewWidget = [
      const HomeScreen(),
      BookmarkScreen(pageController: pageController)
    ];
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(controller: pageController),
      body: Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppBackground.getBackGroundImage(),
            fit: BoxFit.cover
          )
        ),
        child: PageView(
          controller: pageController,
          children: pageViewWidget,
        ),
      ),
    );
  }
}
