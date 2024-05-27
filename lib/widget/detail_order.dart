import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookshop/model/order.dart';
import 'package:bookshop/model/order_detail.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderSnapshot orderSnapshot;

  OrderDetailPage({required this.orderSnapshot, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn hàng ${orderSnapshot.order.id}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: orderSnapshot.order.customerRef.get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> customerSnapshot) {
          if (customerSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (customerSnapshot.hasError || !customerSnapshot.hasData) {
            return Center(child: Text("Lỗi khi tải thông tin khách hàng"));
          }

          Map<String, dynamic> customerData = customerSnapshot.data!.data() as Map<String, dynamic>;

          return StreamBuilder<List<OrderDetailSnapshot>>(
            stream: OrderDetailSnapshot.getByOrderRef(orderSnapshot.ref),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Lỗi khi tải chi tiết đơn hàng"));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var orderDetails = snapshot.data!;
              print(orderDetails);

              return ListView(
                children: [
                  ListTile(
                    title: Text("Người nhận: ${customerData['name']}"),
                    subtitle: Text("Địa chỉ: ${customerData['address']}"),
                  ),
                  ...orderDetails.map((orderDetailSnapshot) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: orderDetailSnapshot.orderDetail.bookRef.get(),
                      builder: (context, bookSnapshot) {
                        if (bookSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(title: Text("Đang tải..."));
                        }
                        if (bookSnapshot.hasError || !bookSnapshot.hasData) {
                          return ListTile(title: Text("Lỗi khi tải thông tin sách"));
                        }
                        Map<String, dynamic> bookData = bookSnapshot.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text("${bookData['name']} x${orderDetailSnapshot.orderDetail.quantity}"),
                          subtitle: Text("Giá: ${orderDetailSnapshot.orderDetail.price}"),
                        );
                      },
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}