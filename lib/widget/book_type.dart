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


class BookTypePage extends StatelessWidget {
  const BookTypePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            var list = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(thickness: 1.5,),
              itemCount: list.length,
              itemBuilder: (context, index) {
                var bookTypeSnapshot = list[index];
                return Slidable(
                  child: Text("${bookTypeSnapshot.bookType.name}"),
                  endActionPane: ActionPane(
                    extentRatio: 0.6,
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (context) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateBookTypePage(bookTypeSnapshot: bookTypeSnapshot),));
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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

