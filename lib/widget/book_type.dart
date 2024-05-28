import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/widget/add_book_type.dart';
import 'package:bookshop/widget/update_booktype.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../widget_connect_firebase.dart';
class BookTypePageConection extends StatelessWidget {
  const BookTypePageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: BookTypePage(),
      ),
    );;
  }
}


class BookTypePage extends StatefulWidget {
  const BookTypePage({super.key});

  @override
  State<BookTypePage> createState() => _BookTypePageState();
}

class _BookTypePageState extends State<BookTypePage> {
  TextEditingController txtSearchId = new TextEditingController();
  TextEditingController txtSearchKeyword = new TextEditingController();
  var list=[];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Thể loại sách"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookTypePage(),));

        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<BookTypeSnapshot>>(
          stream: BookTypeSnapshot.getAll(),
          builder: (context, snapshot){
            if(snapshot.hasError) return Center(child: Text("Lỗi"),);
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            list = snapshot.data!;
            //dùng StreamBuilder thì ko cần setState
            return Column(
              children: [
                TextField(
                  style: TextStyle(
                    height: 0.5
                  ),
                  controller: txtSearchId,
                  decoration: InputDecoration(
                    labelText: "Nhập mã sách",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  style: TextStyle(
                      height: 0.5
                  ),
                  controller: txtSearchKeyword,
                  decoration: InputDecoration(
                      labelText: "Nhập từ khóa",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String id = txtSearchId.text.trim().toLowerCase();
                      String keyword = txtSearchKeyword.text.trim().toLowerCase();
                      setState(() {
                        list = snapshot.data!.where((bookType) {
                          return (bookType.bookType.id.toLowerCase().contains(id) &&
                              bookType.bookType.name.toLowerCase().contains(keyword));
                        }).toList();
                      });

                    },
                    child: Text("Tìm kiếm"),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(thickness: 1.5,),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var bookTypeSnapshot = list[index];
                      return Slidable(
                        child: Container(
                          width: w,
                          height: 50,
                          child: Center(
                            child: Text(
                              "${bookTypeSnapshot.bookType.name}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),                  ),
                        endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateBookTypePage(bookTypeSnapshot: bookTypeSnapshot),));
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
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

