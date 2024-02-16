import 'package:flutter/material.dart';


class BottomNav extends StatelessWidget {
  PageController controller;
  BottomNav({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 0,
      color: Colors.blue.withOpacity(0.2),

      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: (){
                  controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.home,color: Colors.white,)),
            const SizedBox(),
            IconButton(onPressed: (){
              controller.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }, icon: const Icon(Icons.bookmark,color: Colors.white,)),
          ],
        ),
      ),
    );
  }
}