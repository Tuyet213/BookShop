import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/widget/update_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '../model/book.dart';
import '../widget_connect_firebase.dart';
import 'add_book.dart';

class BookPageConection extends StatelessWidget {
  const BookPageConection({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: BookPage(),
      ),
    );;
  }
}


class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sách"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookPage(),));

        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<BookSnapshot>>(
          stream: BookSnapshot.getAll(),
          builder: (context, snapshot){
            if(snapshot.hasError) return Center(child: Text("Lỗi"),);
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            var list = snapshot.data!;//AsyncSnapshot=>data

            return FutureBuilder<List<String>>(
                future: Future.wait(list.map((book) async{
                  DocumentSnapshot bookTypeSnapshot = await book.book.bookTypeRef.get();
                  Map<String, dynamic> bookTypeSnapshotData = bookTypeSnapshot.data() as Map<String, dynamic>;
                  return bookTypeSnapshotData["name"];
                })),
                builder: (context, futureBookTypeNames) {
                  if(!futureBookTypeNames.hasData) return CircularProgressIndicator();
                  //chuyển từ Future (BĐB)->Đồng bộ
                  var bookTypeNames = futureBookTypeNames.data;
                  return ListView.separated(
                        separatorBuilder: (context, index) => Divider(thickness: 1.5,),
                        itemCount: list.length,
                        itemBuilder: (context, index)   {
                          var bookSnapshot = list[index];
                          String bookType = bookTypeNames![index];
                          return Slidable(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.network(bookSnapshot.book.image!)),
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Tên sách: ${bookSnapshot.book.name}"),
                                          Text("Giá: ${bookSnapshot.book.price}"),
                                          Text("Số lượng: ${bookSnapshot.book.quantity.toString()}"),
                                          Text("Thể loại: ${bookType}"),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateBookPage(bookSnapshot: bookSnapshot),));
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
                },);
            // return ListView.separated(
            //   separatorBuilder: (context, index) => Divider(thickness: 1.5,),
            //   itemCount: list.length,
            //   itemBuilder: (context, index)   {
            //     var bookSnapshot = list[index];
            //     DocumentSnapshot bookTypeSnapshot = await bookSnapshot.book.bookTypeRef.get() as DocumentSnapshot;
            //     Map<String, dynamic> bookTypeSnapshotData = bookTypeSnapshot.data() as Map<String, dynamic>;
            //     String bookType = bookTypeSnapshotData["name"];
            //     return Slidable(
            //       child: Row(
            //         children: [
            //           Expanded(
            //               flex: 1,
            //               child: Image.network(bookSnapshot.book.image!)),
            //           Expanded(
            //               flex: 2,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text("id: ${bookSnapshot.book.name}"),
            //                     Text("tên: ${bookSnapshot.book.price}"),
            //                     Text("giá: ${bookSnapshot.book.quantity.toString()}"),
            //                     Text("mô tả: ${}"),
            //                   ],
            //                 ),
            //               ))
            //         ],
            //       ),
            //       endActionPane: ActionPane(
            //         extentRatio: 0.3,
            //         motion: ScrollMotion(),
            //         children: [
            //           SlidableAction(
            //             onPressed: (context) {
            //               // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateBookTypePage(bookTypeSnapshot: bookTypeSnapshot),));
            //             },
            //             // backgroundColor: Colors.blue,
            //             foregroundColor: Colors.blue,
            //             icon: Icons.edit,
            //             label: 'Cập nhật',
            //           ),
            //
            //         ],
            //       ),
            //     );
            //   },
            // );
          },
        ),
      ),
    );
  }
}

