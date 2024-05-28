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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: orderSnapshot.order.customerRef.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> customerSnapshot) {
            if (customerSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (customerSnapshot.hasError || !customerSnapshot.hasData) {
              return Center(child: Text("Lỗi khi tải thông tin khách hàng"));
            }

            Map<String, dynamic> customerData = customerSnapshot.data!.data() as Map<String, dynamic>;
            int totalMoney=0;
            return StreamBuilder<List<OrderDetailSnapshot>>(
              stream: OrderDetailSnapshot.getByOrderRef(orderSnapshot.ref),//
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi khi tải chi tiết đơn hàng"));
                  //return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var orderDetails = snapshot.data!;
                print(orderDetails);

                return ListView(
                  children: [
                    ListTile(
                      title: Text("Người nhận: ${customerData['name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Địa chỉ: ${customerData['address']}"),
                          Text("SĐT: ${customerData['phone']}"),
                        ],
                      ),
                    ),
                    ...orderDetails.map((orderDetailSnapshot) {
                      totalMoney += orderDetailSnapshot.orderDetail.quantity*orderDetailSnapshot.orderDetail.quantity;
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
                          return Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child:  Image.network(bookData['image'], height: 100, fit: BoxFit.cover,)),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${bookData['name']}",  style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text("${orderDetailSnapshot.orderDetail.quantity} x ${orderDetailSnapshot.orderDetail.quantity}",),
                                      ],
                                    ),
                                  ))
                            ],
                          ) ;

                        },
                      );
                    }).toList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Tổng tiền: ${totalMoney}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                      ],
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}