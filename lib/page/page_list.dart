import 'package:bookshop/model/book.dart';
import 'package:bookshop/page/page_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'component.dart';

class PageList extends StatelessWidget {
  const PageList({
    super.key,
    required this.icon,
    this.cusRef
  });
  final DocumentReference? cusRef;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: icon,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Tất cả sách",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<BookSnapshot>>(
        stream: BookSnapshot.getAll(),
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
              var books = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(5),
                child: GridView.extent(
                  maxCrossAxisExtent: 320,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: books
                      .map((gem) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    print("pagelist ${cusRef}");
                                    return PageDetail(cusRef: cusRef,bookSnapshot: gem);
                                  }
                                      ,
                                ),
                              );
                            },
                            child: Container(
                              width: 180,
                              height: 300,
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
                                              0.43,
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
