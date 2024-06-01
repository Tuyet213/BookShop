// import 'package:bookshop/model/cart_item.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class PageCart extends StatelessWidget {
//   const PageCart({
//     super.key,
//     required this.icon,
//   });
//   final Widget icon;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: icon,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text(
//               "Cart",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             highlightColor: Colors.transparent,
//             splashColor: Colors.transparent,
//             onPressed: () {},
//             icon: const Icon(
//               Icons.add,
//               color: Colors.transparent,
//             ),
//           ),
//         ],
//       ),
//       body: StreamBuilder<List<CartItemSnapshot>>(
//         stream: CartItemSnapshot.getAll(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text("Something went wrong! Please check the internet"),
//             );
//           } else {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               var listProducts = snapshot.data!;
//
//               //Nếu không có mặt hàng nào trong giỏ hàng
//               if (listProducts.isEmpty) {
//                 return const Center(
//                   child: Text("Nothing here. Try adding some our products!"),
//                 );
//               }
//               return Column(
//                 children: [
//                   Expanded(
//                     child: ListView.separated(
//                       itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.all(0.0),
//                         child: Container(
//                           height: 130,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 15),
//                           padding: const EdgeInsets.all(11),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 70,
//                                 width: 70,
//                                 margin: const EdgeInsets.only(right: 15),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 224, 224, 224),
//                                   borderRadius: BorderRadius.circular(100),
//                                 ),
//                                 child: Image.network(
//                                     listProducts[index].productItem.image),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       listProducts[index].productItem.name,
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black.withOpacity(0.7),
//                                       ),
//                                     ),
//                                     Text(
//                                       "${listProducts[index].productItem.size} Carat",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black.withOpacity(0.5),
//                                       ),
//                                     ),
//                                     Text(
//                                       "\$ ${listProducts[index].productItem.price.toString()}",
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFFFD725A),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Spacer(),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     IconButton(
//                                       color: Colors.redAccent,
//                                       iconSize: 20,
//                                       icon: const Icon(Icons.delete),
//                                       onPressed: () async {
//                                         final result = await showConfirmDialog(
//                                             context,
//                                             "Delete",
//                                             "Are you sure want to remove this product from your cart?");
//                                         if (result) {
//                                           // Nếu Ok thì xóa sản phẩm khỏi giỏ hàng
//                                           listProducts[index].delete();
//                                           showSnackBar(
//                                               context,
//                                               "The product has been removed!",
//                                               2);
//                                         } else {
//                                           // Không thì không làm gì hết
//                                           return;
//                                         }
//                                       },
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(1.0),
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFFF7F8FA),
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: IconButton(
//                                             color: Colors.redAccent,
//                                             iconSize: 17,
//                                             icon: const Icon(Icons.remove),
//                                             onPressed: () async {
//                                               var amount = listProducts[index]
//                                                       .productItem
//                                                       .amount -
//                                                   1;
//                                               if (amount == 0) {
//                                                 final result =
//                                                     await showConfirmDialog(
//                                                         context,
//                                                         "Delete",
//                                                         "Are you sure want to remove this product from your cart?");
//                                                 if (result) {
//                                                   // Nếu Ok thì xóa sản phẩm khỏi giỏ hàng
//                                                   listProducts[index].delete();
//                                                   showSnackBar(
//                                                       context,
//                                                       "The product has been removed!",
//                                                       2);
//                                                 } else {
//                                                   // Không thì không làm gì hết
//                                                   return;
//                                                 }
//                                               } else {
//                                                 ProductItem product =
//                                                     ProductItem(
//                                                   id: listProducts[index]
//                                                       .productItem
//                                                       .id,
//                                                   name: listProducts[index]
//                                                       .productItem
//                                                       .name,
//                                                   size: listProducts[index]
//                                                       .productItem
//                                                       .size,
//                                                   image: listProducts[index]
//                                                       .productItem
//                                                       .image,
//                                                   price: listProducts[index]
//                                                       .productItem
//                                                       .price,
//                                                   amount: amount,
//                                                 );
//                                                 await listProducts[index]
//                                                     .update(product);
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                         Text(
//                                           listProducts[index]
//                                               .productItem
//                                               .amount
//                                               .toString(),
//                                           style: const TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 0,
//                                         ),
//                                         // Nút thêm số lượng sản phẩm
//                                         Container(
//                                           padding: const EdgeInsets.all(1),
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFFF7F8FA),
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: IconButton(
//                                             color: Colors.redAccent,
//                                             iconSize: 17,
//                                             icon: const Icon(Icons.add),
//                                             onPressed: () async {
//                                               var amount = listProducts[index]
//                                                       .productItem
//                                                       .amount +
//                                                   1;
//                                               ProductItem product = ProductItem(
//                                                 id: listProducts[index]
//                                                     .productItem
//                                                     .id,
//                                                 name: listProducts[index]
//                                                     .productItem
//                                                     .name,
//                                                 size: listProducts[index]
//                                                     .productItem
//                                                     .size,
//                                                 image: listProducts[index]
//                                                     .productItem
//                                                     .image,
//                                                 price: listProducts[index]
//                                                     .productItem
//                                                     .price,
//                                                 amount: amount,
//                                               );
//                                               await listProducts[index]
//                                                   .update(product);
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       separatorBuilder: (context, index) => const Divider(
//                         thickness: 0,
//                       ),
//                       itemCount: listProducts.length,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(top: 1),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               const Text(
//                                 "Total: ",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 "\$ ${getTotal(listProducts).toString()}",
//                                 style: const TextStyle(
//                                   color: Colors.orange,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   StreamBuilder<List<UserSnapshot>>(
//                     stream: UserSnapshot.getAllUser(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return const Center(
//                           child: Text("Error!"),
//                         );
//                       } else {
//                         if (!snapshot.hasData) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else {
//                           var listUser = snapshot.data!;
//                           String currentInfo;
//                           // Xử lý nếu đăng nhập bằng phone
//                           if (FirebaseAuth.instance.currentUser!.email ==
//                               null) {
//                             currentInfo =
//                                 FirebaseAuth.instance.currentUser!.phoneNumber!;
//                           } else {
//                             currentInfo =
//                                 FirebaseAuth.instance.currentUser!.email!;
//                           }
//                           // Tạo ra một UserSnaphot tạm
//                           UserSnapshot? currentUser;
//                           // Lặp và lấy user hiện tại
//                           for (var userSnapshot in listUser) {
//                             if (userSnapshot.user.email == currentInfo ||
//                                 userSnapshot.user.phone == currentInfo) {
//                               currentUser = userSnapshot;
//                             }
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Center(
//                               child: SizedBox(
//                                 width: 200,
//                                 height: 48,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     // Nếu user hiện tại đã cập nhật thông tin
//                                     if (currentUser!.user.isUpdated) {
//                                       // Kiểm tra giỏ hàng có đồ hay không
//                                       final result = await showConfirmDialog(
//                                           context,
//                                           "Pay Confirm",
//                                           "Are you sure want to pay all the products in your cart?");
//                                       if (result) {
//                                         // Nếu Ok thì thanh toán và xóa hết đồ trong giỏ hàng
//                                         for (var item in listProducts) {
//                                           item.delete();
//                                         }
//                                         showSnackBar(
//                                             context,
//                                             "Paid successfully, thanks for your payment!",
//                                             2);
//                                       } else {
//                                         // Không thì không làm gì hết
//                                         return;
//                                       }
//                                     }
//                                     // Nếu user hiện tại chưa cập nhật thông tin
//                                     else {
//                                       // Chuyển đến trang cập nhật thông tin
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => PageEditInfo(
//                                               userSnapshot: currentUser!),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     shape: const StadiumBorder(),
//                                   ),
//                                   child: const Text("Pay"),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
//
// // Hàm tính tổng tiền trong giỏ hàng
// int getTotal(List<ProductItemSnapshot> list) {
//   int total = 0;
//   for (var item in list) {
//     total = total + item.productItem.amount * item.productItem.price;
//   }
//   return total;
// }
