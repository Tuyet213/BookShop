import 'dart:math';

import 'package:bookshop/model/book.dart';
import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/page/page_detail.dart';
import 'package:bookshop/page/page_list.dart';
import 'package:bookshop/page/page_search.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import '../model/book.dart';
import 'component.dart';

class PageHome extends StatelessWidget {
  PageHome({Key? key}) : super(key: key);
  final TextEditingController txtSearch = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              var listRandom = randomShowProduct(books);
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Khám phá cửa hàng của chúng tôi",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Lựa chọn sản phẩm tốt nhất cho bạn..."),
                      const SizedBox(height: 25),
                      Form(
                        key: formState,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: txtSearch,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                hintText: "Search everything...",
                                prefixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  // Nhấn nút tìm kiếm đưa text tìm kiếm vào PageType.
                                  onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PageSearch(txt: txtSearch.text),
                                      ),
                                    )
                                  },
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => txtSearch.clear(),
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? "Nothing to search..."
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Loại sách",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Một widget FutureBuilder có dữ liệu là một List<BookTypeSnapshot>
                      StreamBuilder<List<BookTypeSnapshot>>(
                        stream: BookTypeSnapshot.getAll(),
                        builder: (context, snap) {
                          if (snap.hasError) {
                            return const Center(
                              child: Text("Error!"),
                            );
                          } else {
                            if (!snap.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var listTypes = snap.data!;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    listTypes.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: CategoryCard(
                                        type: listTypes[index].bookType.name,
                                        press: () {
                                          // Chuyển đến PageType với tên loại
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PageSearch(
                                                      txt: listTypes[index]
                                                          .bookType
                                                          .name,
                                                      bookTypeRef:
                                                          listTypes[index].ref,
                                                      checkType: true,
                                                    )
                                                // PageTypes(
                                                // type: listTypes[index]
                                                //     .BookType
                                                //     .idType),
                                                ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.red,
                              ),
                              Text(
                                "Sách Hot",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PageList(
                                    icon: BackIcon(),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "See all",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductCard(
                            name: books[listRandom[0]].book.name,
                            price: books[listRandom[0]].book.price.toString(),
                            image: books[listRandom[0]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[0]]),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            name: books[listRandom[1]].book.name,
                            price: books[listRandom[1]].book.price.toString(),
                            image: books[listRandom[1]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[1]]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductCard(
                            name: books[listRandom[2]].book.name,
                            price: books[listRandom[2]].book.price.toString(),
                            image: books[listRandom[2]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[2]]),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            name: books[listRandom[3]].book.name,
                            price: books[listRandom[3]].book.price.toString(),
                            image: books[listRandom[3]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[3]]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductCard(
                            name: books[listRandom[4]].book.name,
                            price: books[listRandom[4]].book.price.toString(),
                            image: books[listRandom[4]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[4]]),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            name: books[listRandom[5]].book.name,
                            price: books[listRandom[5]].book.price.toString(),
                            image: books[listRandom[5]].book.image,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetail(
                                      bookSnapshot: books[listRandom[5]]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

List<int> randomShowProduct(List<BookSnapshot> list) {
  int max = list.length;
  List<int> randomNumbers = [];
  while (randomNumbers.length < 6) {
    var random = Random().nextInt(max);
    while (randomNumbers.contains(random)) {
      random = Random().nextInt(max);
    }
    randomNumbers.add(random);
  }
  return randomNumbers;
}
