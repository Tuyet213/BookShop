import 'package:bookshop/model/book.dart';
import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/page/page_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'component.dart';

class PageSearch extends StatelessWidget {
  const PageSearch({
    super.key,
    required this.txt,
    this.checkType,
    this.bookTypeRef,
  });
  final String txt;
  final DocumentReference? bookTypeRef;
  final bool? checkType;
  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    String type = (checkType == true) ? txt : "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type != "" ? type : "Trang tìm kiếm",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/notification.svg"),
          ),
        ],
      ),
      body: StreamBuilder<List<BookSnapshot>>(
        stream: BookSnapshot.getAll()!,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // Lấy danh sách các BookSnapshot
              var list = snapshot.data!;
              List<BookSnapshot> books = [];
              // Kiểm tra xem Book trong BookSnapshot thuộc loại nào
              for (var b in list) {
                // print(bookTypeRef == b.book.bookTypeRef);
                // print("object");
                if (checkType == true && bookTypeRef == b.book.bookTypeRef) {
                  books.add(b);
                  continue;
                }
                // Nếu cùng loại thì add vào
                if ( //b.book.idType == type ||
                    b.book.name.toLowerCase().contains(txt!) ||
                        b.book.name.contains(txt!)) books.add(b);
              }
              if (books.isEmpty) {
                return const Center(
                  child: Text("Không tìm thấy sách."),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.extent(
                  maxCrossAxisExtent: 350,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: books
                      .map((gem) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageDetail(bookSnapshot: gem),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 180,
                              height: 320,
                              child: Card(
                                elevation: 1,
                                shadowColor: Colors.blue,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.network(
                                      gem.book.image,
                                      height:
                                          ScreenSize.getScreenWidth(context) *
                                              0.38,
                                      width:
                                          ScreenSize.getScreenWidth(context) *
                                              0.3,
                                    ),
                                    Text(gem.book.name),
                                    Text(
                                      formatCurrency.format(gem.book.price),
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
