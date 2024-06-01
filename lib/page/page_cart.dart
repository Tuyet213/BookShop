import 'package:bookshop/model/cart_item.dart';
import 'package:bookshop/model/customer.dart';
import 'package:bookshop/model/order.dart' as od;
import 'package:bookshop/model/order_detail.dart';
import 'package:bookshop/page/page_update_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import 'component.dart';

class PageCart extends StatelessWidget {
  DocumentReference? cusRef;
  PageCart({
    super.key,
    required this.icon,
    this.cusRef
  });
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: icon,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Cart",
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
      body: StreamBuilder<List<CartItemSnapshot>>(
        stream: CartItemSnapshot.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong! Please check the internet"),
            );
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var listProducts = snapshot.data!;

              //Nếu không có mặt hàng nào trong giỏ hàng
              if (listProducts.isEmpty) {
                return const Center(
                  child: Text("Không có sản phẩm trong giỏ hàng"),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: listProducts[index].cartItem.bookRef.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return ListTile(title: Text("Đang tải..."));
                              }
                              if (snapshot.hasError || !snapshot.hasData) {
                                return ListTile(title: Text("Lỗi khi tải thông tin sách"));
                              }
                              Map<String, dynamic> bookData = snapshot.data!.data() as Map<String, dynamic>;
                              return Row(
                                children: [
                                  Container(
                                    height: w*0.2,
                                    width: w*0.2,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color:
                                      const Color.fromARGB(255, 224, 224, 224),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.network(
                                        bookData["image"]),
                                  ),
                                  Container(
                                    height: w*0.4,
                                    width: w*0.4,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bookData['name'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                          Text(
                                            "${bookData['price']} VNĐ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: w*0.3,
                                    width: w*0.3,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: IconButton(
                                              color: Colors.redAccent,
                                              iconSize: 20,
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                final result = await showConfirmDialog(
                                                    context,
                                                    "Xóa",
                                                    "Bạn có mốn xóa sản phẩm này khỏi giỏ hàng không");
                                                if (result) {
                                                  // Nếu Ok thì xóa sản phẩm khỏi giỏ hàng
                                                  listProducts[index].delete();
                                                  showSnackBar(
                                                      context,
                                                      "Sản phẩm đã được xóa!",
                                                      2);
                                                } else {
                                                  // Không thì không làm gì hết
                                                  return;
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(1.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF7F8FA),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.symmetric(vertical: 2),
                                                color: Colors.redAccent,
                                                iconSize: 17,
                                                icon: const Icon(Icons.remove),
                                                onPressed: () async {
                                                  var quantity = listProducts[index]
                                                      .cartItem.quantity -1;

                                                  if (quantity == 0) {
                                                    final result =
                                                    await showConfirmDialog(
                                                        context,
                                                        "Xóa",
                                                        "Bạn có mốn xóa sản phẩm này khỏi giỏ hàng không");
                                                    if (result) {
                                                      // Nếu Ok thì xóa sản phẩm khỏi giỏ hàng
                                                      listProducts[index].delete();
                                                      showSnackBar(
                                                          context,
                                                          "Sản phẩm đã được xóa",
                                                          2);
                                                    } else {
                                                      // Không thì không làm gì hết
                                                      return;
                                                    }
                                                  } else {
                                                    CartItem book =
                                                    CartItem(
                                                        id: "",
                                                        bookRef: listProducts[index].cartItem.bookRef,
                                                        customerRef: listProducts[index].cartItem.customerRef,
                                                        quantity: quantity
                                                    );
                                                    await listProducts[index].update(book);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Text(
                                            listProducts[index]
                                                .cartItem
                                                .quantity
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),),

                                          // Nút thêm số lượng sản phẩm
                                          Expanded(child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7F8FA),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: IconButton(
                                              color: Colors.redAccent,
                                              padding: EdgeInsets.symmetric(vertical: 2),
                                              iconSize: 17,
                                              icon: const Icon(Icons.add),
                                              onPressed: () async {
                                                var quantity = listProducts[index]
                                                    .cartItem
                                                    .quantity +
                                                    1;
                                                CartItem book =
                                                CartItem(
                                                    id: "",
                                                    bookRef: listProducts[index].cartItem.bookRef,
                                                    customerRef: listProducts[index].cartItem.customerRef,
                                                    quantity: quantity
                                                );
                                                await listProducts[index].update(book);

                                              },
                                            ),
                                          ),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),

                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 0,
                      ),
                      itemCount: listProducts.length,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 1),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "Total: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              FutureBuilder<double>(
                                  future: getTotal(listProducts), 
                                  builder: (context, snapshot)  {
                                    print(snapshot);
                                    if(snapshot.hasError){
                                      return Center(child: Text("Error"),);
                                    }
                                    if(!snapshot.hasData){
                                      return Center(child: Text("ko có dữ liệu"),);
                                    }
                                    return Text(
                                      " ${snapshot.data}",
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: cusRef?.get(),
                      builder: (context, snapshot) {
                        print(snapshot);
                        if(snapshot.hasError){
                          return Center(child: Text("Error"),);
                        }
                        if(!snapshot.hasData){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return ElevatedButton(
                            onPressed: () async {
                              Customer customer = Customer.fromJson(snapshot.data?.data() as Map<String, dynamic>);
                              if(customer.phone.isEmpty || customer.address.isEmpty)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PageEditInfo(userSnapshot: CustomerSnapshot.fromJson(snapshot.data!)),
                                  ),
                                );
                              else {
                                od.Order newOrder = od.Order(id: "", customerRef: cusRef!, status: 0, orderedDate: DateTime.now());
                                DocumentReference orderRef = await od.OrderSnapshot.add(newOrder);
                                for(var item in listProducts){
                                  DocumentSnapshot bookSnapshot = await item.cartItem.bookRef.get();
                                  Book book = Book.fromJson(bookSnapshot.data() as Map<String, dynamic>);
                                  OrderDetail od = OrderDetail(id: "", orderRef: orderRef, bookRef: item.cartItem.bookRef, price: book.price.toInt(), quantity: item.cartItem.quantity);
                                  OrderDetailSnapshot.add(od);
                                  item.delete();
                                }
                              }

                            },
                            child: Text("Payment"));
                      },
                  )
                  
                ],
              );
            }
          }
        },
      ),
    );
  }

}

// Hàm tính tổng tiền trong giỏ hàng
Future<double> getTotal(List<CartItemSnapshot> list) async {
  double total = 0;
  for (var item in list) {
   DocumentSnapshot bookSnapshot = await item.cartItem.bookRef.get() ;
   Book book = Book.fromJson(bookSnapshot.data() as Map<String, dynamic>);
    total = total + item.cartItem.quantity * book.price;
  }
  return total;
}
