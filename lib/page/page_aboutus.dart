import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'component.dart';

class PageAboutUs extends StatelessWidget {
  const PageAboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "About Us",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSnackBar(context, "Feature is under development!", 2);
            },
            icon: SvgPicture.asset("assets/icons/notification.svg"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/Book_shop.png",
              height: ScreenSize.getScreenHeight(context) * 0.2,
            ),
            SizedBox(
              height: ScreenSize.getScreenHeight(context) * 0.001,
            ),
            Text(
              "WE ARE TEAM PARASITE",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                description,
                textAlign: TextAlign.justify,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.5),
              child: Text(
                "Instructor: Mr. Huỳnh Tuấn Anh\n",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                ".....",
                textAlign: TextAlign.justify,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 5.5, 15, 15),
              child: Text(
                "Nguyễn Văn Minh Quân - 63135194\n"
                "Huỳnh Thị Ngọc Tuyết - 63136018\n"
                "Tạ Huỳnh Đạt - 63133671",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
