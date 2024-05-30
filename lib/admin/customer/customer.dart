
import 'package:bookshop/model/customer.dart';
import 'package:bookshop/admin/customer/update_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../../widget_connect_firebase.dart';
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


class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  TextEditingController txtSearchKeyword = new TextEditingController();
  List<CustomerSnapshot> fullList = [];
  List<CustomerSnapshot> filteredList = [];
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
            fullList = snapshot.data!;
            if (filteredList.isEmpty) {
              filteredList = fullList;
            }
            return Column(children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(height: 0.5),
                controller: txtSearchKeyword,
                decoration: InputDecoration(
                  labelText: "Nhập từ khóa",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String keyword = txtSearchKeyword.text.trim().toLowerCase();
                  setState(() {
                    filteredList = fullList.where((customer) {
                      return customer.customer.name.toLowerCase().contains(keyword)
                      ||customer.customer.address.toLowerCase().contains(keyword)
                      ||customer.customer.phone.toLowerCase().contains(keyword)
                      ||customer.customer.email.toLowerCase().contains(keyword);
                    }).toList();
                  });
                },
                child: Text("Tìm kiếm"),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    var customerSnapshot = filteredList[index];
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
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateCustomerPage(
                                    customerSnapshot: customerSnapshot),
                              ));
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
                  separatorBuilder: (context, index) => Divider(thickness: 1.5),
                ),
              )
            ]);

          },
        ),
      ),
    );
  }
}

