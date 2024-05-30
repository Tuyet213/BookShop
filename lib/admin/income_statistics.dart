import 'dart:math';

import 'package:bookshop/model/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../model/book.dart';
import '../model/order.dart';
import '../widget_connect_firebase.dart';

class StatisticsPageConection extends StatelessWidget {
  const StatisticsPageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: BudgetStatistics(),
      ),
    );;
  }
}

class BudgetStatistics extends StatefulWidget {
  const BudgetStatistics({super.key});

  @override
  State<BudgetStatistics> createState() => _BudgetStatisticsState();
}

class _BudgetStatisticsState extends State<BudgetStatistics> {
  DateTime? from;
  DateTime?  to;
  List<OrderSnapshot> fullList = [];
  List<OrderSnapshot> filterList = [];
  Map<DocumentReference, int> productRevenues = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thống kê doanh thu"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<OrderSnapshot>>(
              stream: OrderSnapshot.getAll(),
              builder: (context, snapshot) {
                if(snapshot.hasError) return Center(child: Text("Lỗi"),);
                if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                fullList = snapshot.data!;
                if (filterList.isEmpty) {
                  filterList = fullList;
                }
                return Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Từ: "),
                        IconButton(
                            onPressed: () async{
                              DateTime? d = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime(2040)
                              );
                              if(d!=null){
                                // setState(() {
                                //   from=d;
                                // });
                                from=d;
                              }

                            },
                            icon: Icon(Icons.calendar_month)
                        ),
                        Text("${from?.day??1}/${from?.month??1}/${from?.year??2003}")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Đến: "),
                        IconButton(
                            onPressed: () async{
                              DateTime? d = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime(2040)
                              );
                              if(d!=null){
                                // setState(() {
                                //   to=d;
                                // });
                                to=d;
                              }

                            },
                            icon: Icon(Icons.calendar_month)
                        ),
                        Text("${to?.day??1}/${to?.month??1}/${to?.year??2003}")
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filterList = fullList.where((order) => order.order.orderedDate.isAfter(from!)
                                && order.order.orderedDate.isBefore(to!),).toList();
                            for(var order in filterList){
                              Stream<List<OrderDetailSnapshot>> orderDetailSnapshots = OrderDetailSnapshot.getByOrderRef(order.ref);
                              List<OrderDetailSnapshot> orderDetailsList = [];
                              //Stream=>StreamBuilder||listen
                              orderDetailSnapshots.listen((List<OrderDetailSnapshot> data) {
                                  orderDetailsList = data;
                                  if(orderDetailsList!=null && orderDetailsList.isNotEmpty){
                                    for(var orderDetail in orderDetailsList){
                                      if(!productRevenues.containsKey(orderDetail.orderDetail.bookRef)){
                                        productRevenues[orderDetail.orderDetail.bookRef] = orderDetail.orderDetail.quantity * orderDetail.orderDetail.price;
                                      }
                                      else{
                                        productRevenues[orderDetail.orderDetail.bookRef] = (productRevenues[orderDetail.orderDetail.bookRef] ?? 0) + (orderDetail.orderDetail.quantity * orderDetail.orderDetail.price);                                }
                                    }
                                  }
                                },
                                onError: (error) {
                                  print('Lỗi: $error');
                                },
                                onDone: () {
                                  print('Hoàn thành');
                                },
                              );

                            }
                          });
                          print(filterList);
                        },
                        child: Text("Thống kê")),
                    filterList.isNotEmpty?Center(child: Text("Tỉ lệ doanh thu từ sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),):Text(""),
                    filterList.isNotEmpty?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("(${from?.day??1}/${from?.month??1}/${from?.year??2003} - "),
                        Text("${to?.day??1}/${to?.month??1}/${to?.year??2003})")
                      ],
                    ):Text(""),
                    filterList.isNotEmpty?FutureBuilder<List<PieChartSectionData>>(
                      future: getPieSections(),//Future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Lỗi khi tải dữ liệu.");
                        }
                        return Expanded(child: PieChart(PieChartData(
                          startDegreeOffset: 90,
                            sections: snapshot.data),
                        ));
                      },
                    ):Text(""),
                  ],
                );
              }
          ),
        )
    );

  }

  @override
  void initState() {
    DateTime today = DateTime.now();
    from = today.subtract(Duration(days: 30));
    to = today;
  }
  Future<List<PieChartSectionData>> getPieSections() async {
    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    var productRevenueList = productRevenues.entries.toList();
    productRevenueList.sort((a, b)=> a.value.compareTo(b.value));
    productRevenues = Map.fromEntries(productRevenueList);
    for (var entry in productRevenues.entries) {
      DocumentSnapshot bookSnapshot = await entry.key.get();
      Book book = Book.fromJson(bookSnapshot.data() as Map<String, dynamic>);
      String title = book.name;
      double value = entry.value.toDouble();
      Color color = Color.fromRGBO(Random().nextInt(255),Random().nextInt(255),Random().nextInt(255), 0.5);

      sections.add(PieChartSectionData(
        title: '${title}\n${value}',
        color: color,
        value: value,
        radius: 170,
        showTitle: true,

      ));
      colorIndex++;
    }
    return sections;
  }

}
