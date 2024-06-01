import 'package:bookshop/model/book.dart';
import 'package:bookshop/page/page_cart.dart';
import 'package:bookshop/page/page_main.dart';
import 'package:bookshop/page/page_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/cart_item.dart';
import 'component.dart';

class PageDetail extends StatelessWidget {
  final BookSnapshot bookSnapshot;
  final DocumentReference? cusRef;
  const PageDetail({
    super.key,
    required this.bookSnapshot,
    this.cusRef
  });

  @override
  Widget build(BuildContext context) {
    print("pagedetail   ${cusRef}");
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bookSnapshot.book.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 8.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
          ),
        ),
        actions: [
          StreamBuilder<List<CartItemSnapshot>>(
            stream: CartItemSnapshot.getAll(),
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
                  var list = snapshot.data!;
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageCart(cusRef: cusRef,icon: BackNull())
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 25,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: Center(
                            child: Text(
                              list.length.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            bookSnapshot.book.image,
            height: ScreenSize.getScreenHeight(context) * 0.35,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffe6e6e6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: BookTypeNameWidget(
                            bookTypeRef: bookSnapshot.book.bookTypeRef,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.sell),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                                formatCurrency.format(bookSnapshot.book.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      bookSnapshot.book.description,
                      style: const TextStyle(
                        color: Color(0xff8c8c8c),
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Tác giả",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            bookSnapshot.book.author,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Số lượng",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            bookSnapshot.book.quantity.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Năm XB",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            bookSnapshot.book.publicationYear.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  StreamBuilder<List<CartItemSnapshot>>(
                    stream: CartItemSnapshot.getAll(),
                    builder: (context, AsyncSnapshot<List<CartItemSnapshot>> snapshot) {
                      print("PageDetailttt${snapshot.error}");
                      if (snapshot.hasError) {
                        return  Center(child: Text("Error"),);
                      }
                      else {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                          bool isAdded = false;
                          var list = snapshot.data!;
                          if(list.isEmpty) return Center(
                          child: SizedBox(
                            width: 200,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                CartItem book = CartItem(
                                    id: "",
                                    bookRef: bookSnapshot.ref,
                                    customerRef: cusRef!,
                                    quantity: 1
                                );
                                await CartItemSnapshot.add(book);
                                showSnackBar(
                                  context,
                                  "Thêm thành công!",
                                  2,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text("Thêm vào giỏ hàng"),
                            ),
                          ),
                        );
                          else{
                            for (var item in list) {
                              if (item.cartItem.bookRef == bookSnapshot.ref) {
                                isAdded = true;
                                break;
                              }
                              if (isAdded) {
                                return Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showSnackBar(
                                          context,
                                          "This product has already been added!",
                                          2,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text("ADDED"),
                                    ),
                                  ),
                                );
                              }
                              else {
                                return Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        CartItem book = CartItem(
                                            id: "",
                                            bookRef: bookSnapshot.ref,
                                            customerRef: cusRef!,
                                            quantity: 1
                                        );
                                        await CartItemSnapshot.add(book);
                                        showSnackBar(
                                          context,
                                          "Thêm thành công!",
                                          2,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text("Thêm vào giỏ hàng"),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                      }
                      return Text("");
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
