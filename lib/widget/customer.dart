
import 'package:bookshop/model/customer.dart';
import 'package:bookshop/widget/update_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../widget_connect_firebase.dart';
import 'add_customer.dart';
class CustomerPageConection extends StatelessWidget {
  const CustomerPageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: CustomerPage(),
      ),
    );;
  }
}


class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Khách hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCustomerPage(),));

        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<CustomerSnapshot>>(
          stream: CustomerSnapshot.getAll(),
          builder: (context, snapshot){
            if(snapshot.hasError) return Center(child: Text("Lỗi"),);
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            var list = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(thickness: 1.5,),
              itemCount: list.length,
              itemBuilder: (context, index) {
                var customerSnapshot = list[index];
                return Slidable(
                  child: Container(
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tên: ${customerSnapshot.customer.name}"),
                        Text("Email: ${customerSnapshot.customer.email}"),
                        Text("SĐT: ${customerSnapshot.customer.phone}"),
                        Text("Mật khẩu: ${customerSnapshot.customer.password}"),
                        Text("Địa chỉ: ${customerSnapshot.customer.address}"),
                      ],
                    ),
                  ),
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateCustomerPage(customerSnapshot: customerSnapshot),));
                        },
                        // backgroundColor: Colors.blue,
                        foregroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Cập nhật',
                      ),

                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

