import 'package:bookshop/admin/book/book.dart';
import 'package:bookshop/admin/book_type/book_type.dart';
import 'package:bookshop/admin/customer/customer.dart';
import 'package:bookshop/admin/income_statistics.dart';
import 'package:bookshop/admin/order/order.dart';
import 'package:bookshop/admin/staff.dart';
import 'package:bookshop/admin/book_type/update_booktype.dart';
import 'package:bookshop/auth/page_forgot_password.dart';
import 'package:bookshop/auth/page_login.dart';
import 'package:bookshop/auth/page_register.dart';
import 'package:bookshop/widget_connect_firebase.dart';
import 'package:flutter/material.dart';

class PageAdmin extends StatelessWidget {
  //class
  const PageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                _buildButton(context,
                    label: "Thể loại sách - BookType", destination: BookTypePageConection()),
                _buildButton(context,
                    label: "Sách - Book", destination: BookPageConection()),
                _buildButton(context,
                    label: "Khách hàng - Customer", destination: CustomerPageConection()),
                _buildButton(context,
                    label: "Đơn hàng - Order", destination: OrderPageConection()),
                _buildButton(context,
                    label: "Thống kê doanh thu",
                    destination: StatisticsPageConection())
              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required Widget destination}) {
    //method
    double w = MediaQuery.of(context).size.width * 0.75;
    return Container(
      width: w,
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => destination,
            ));
          },
          child: Text(label)),
    );
  }
}
