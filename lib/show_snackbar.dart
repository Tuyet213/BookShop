import 'package:flutter/material.dart';

showMySnackBar(BuildContext context, String thongBao, int giay){
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(thongBao),
    duration: Duration(seconds: giay),
  ));
}