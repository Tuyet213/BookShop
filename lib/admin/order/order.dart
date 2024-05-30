import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '../../model/order.dart';
import '../../widget_connect_firebase.dart';
import 'detail_order.dart';

class OrderPageConection extends StatelessWidget {
  const OrderPageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder: (context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: OrderPage(),
      ),
    );
    ;
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int filterStatus = -1;
  List<OrderSnapshot> fullList = [];
  List<OrderSnapshot> filteredList = [];
  int flag =0;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách đơn hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<OrderSnapshot>>(
          stream: OrderSnapshot.getAll(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError)
              return Center(
                child: Text("Lỗi"),
              );
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            fullList = snapshot.data!;
            if (filteredList.isEmpty && flag ==0) {
              filteredList = fullList;
              flag++;
            }
            return Column(
              children: [
                DropdownButton(
                  isExpanded: true,
                  value: filterStatus,
                    items: [
                      DropdownMenuItem(
                          value: -1,
                          child: Text("None")),
                      DropdownMenuItem(
                          value: 0,
                          child: Text("Chưa giao")),
                      DropdownMenuItem(
                          value: 1,
                          child: Text("Giao thành công")),
                      DropdownMenuItem(
                          value: 2,
                          child: Text("Giao không thành công"))
                    ],
                    onChanged: (int? value) {
                      if(value!=null){
                        setState(() {
                          filterStatus=value;
                          switch(filterStatus){
                            case -1:
                              filteredList = fullList;
                              break;
                            case 0:
                            case 1:
                            case 2:
                              filteredList = fullList.where((order) => order.order.status == filterStatus).toList();
                              break;
                          }
                        });
                      }
                    },),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1.5,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var orderSnapshot = filteredList[index];
                      Color color = Colors.black;
                      if (orderSnapshot.order.status == 1) color = Colors.green;
                      if (orderSnapshot.order.status == 2) color = Colors.red;
                      return Slidable(
                        child: ListTile(
                          title: Text(
                            "Mã đơn hàng: ${orderSnapshot.order.id}",
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Ngày đặt: ${orderSnapshot.order.orderedDate}",
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => OrderDetailPage(orderSnapshot: orderSnapshot),));
                          },
                        ),
                        endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _showEditPanel(context, orderSnapshot),
                              // backgroundColor: Colors.blue,
                              foregroundColor: Colors.blue,
                              icon: Icons.edit,
                              label: 'Cập nhật',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  void _showEditPanel(BuildContext context, OrderSnapshot orderSnapshot) {
    showDialog(
        context: context,
        builder: (context) {
          int status = orderSnapshot.order.status;
          return AlertDialog(
            title: Text('Cập nhật trạng thái đơn hàng'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RadioListTile<int>(
                      title: Text('Chưa giao'),
                      value: 0,
                      groupValue: status,
                      onChanged: (value) {
                        setState((){
                          status = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Giao thành công'),
                      value: 1,
                      groupValue: status,
                      onChanged: (value) {
                        setState((){
                          status = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Không giao được'),
                      value: 2,
                      groupValue: status,
                      onChanged: (value) {
                        setState((){
                          status = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  orderSnapshot.ref.update({'status': status}).then((value) {
                    setState(() {
                      orderSnapshot.order.status = status;
                      if (filterStatus == -1 || filterStatus == status) {
                        int index = filteredList.indexOf(orderSnapshot);
                        if (index != -1) {
                          filteredList[index].order.status = status;
                        }
                      } else {
                        filteredList.remove(orderSnapshot);
                      }
                    });
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        }
    );
  }

}


