import 'package:bookshop/widget/book.dart';
import 'package:bookshop/widget/book_type.dart';
import 'package:bookshop/widget/customer.dart';
import 'package:bookshop/widget/order.dart';
import 'package:bookshop/widget/staff.dart';
import 'package:bookshop/widget/update_booktype.dart';
import 'package:bookshop/widget_connect_firebase.dart';
import 'package:flutter/material.dart';


class PageHome extends StatelessWidget {//class
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              _buildButton(context,
                  label: "BookType",
                  destination: BookTypePageConection()),
              _buildButton(context,
                  label: "Book",
                  destination: BookPageConection()),
              _buildButton(context,
                  label: "Staff",
                  destination: StaffPageConection()),
              _buildButton(context,
                  label: "Customer",
                  destination: CustomerPageConection()),
              _buildButton(context,
                  label: "Order",
                  destination: OrderPageConection()),

            ],
          ),
        ),
      ),
    );

  }

  Widget _buildButton(BuildContext context,{required String label, required Widget destination}) {//method
    double w = MediaQuery.of(context).size.width*0.75;
    return Container(
      width: w,
      child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                destination,)
            );
          },
          child: Text(label)),
    );
  }
}
