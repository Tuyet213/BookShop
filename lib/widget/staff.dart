
import 'package:bookshop/widget/update_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../model/staff.dart';
import '../widget_connect_firebase.dart';
import 'add_staff.dart';
class StaffPageConection extends StatelessWidget {
  const StaffPageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: StaffPage(),
      ),
    );;
  }
}


class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách nhân viên"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddStaffPage(),));

        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<StaffSnapshot>>(
          stream: StaffSnapshot.getAll(),
          builder: (context, snapshot){
            if(snapshot.hasError) return Center(child: Text("Lỗi"),);
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            var list = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(thickness: 1.5,),
              itemCount: list.length,
              itemBuilder: (context, index) {
                var staffSnapshot = list[index];
                return Slidable(
                  child: Container(
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tên: ${staffSnapshot.staff.name}"),
                        Text("Email: ${staffSnapshot.staff.email}"),
                        Text("SĐT: ${staffSnapshot.staff.phone}"),
                        Text("Mật khẩu: ${staffSnapshot.staff.password}"),
                      ],
                    ),
                  ),
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateStaffPage(staffSnapshot: staffSnapshot),));
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

