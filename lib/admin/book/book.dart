import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/admin/book/update_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '../../model/book.dart';
import '../../widget_connect_firebase.dart';
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


class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  TextEditingController txtSearchKeyword = new TextEditingController();
  List<BookSnapshot> fullList = [];
  List<BookSnapshot> filteredList = [];
  List<BookTypeSnapshot> bookTypes = [];
  BookTypeSnapshot? bookType;
  int flag =0;
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
            fullList = snapshot.data!;
            if (filteredList.isEmpty && flag == 0) {
              filteredList = fullList;
              flag++;
            }//AsyncSnapshot=>data
            return FutureBuilder<List<String>>(
                future: Future.wait(fullList.map((book) async{
                  DocumentSnapshot bookTypeSnapshot = await book.book.bookTypeRef.get();
                  Map<String, dynamic> bookTypeSnapshotData = bookTypeSnapshot.data() as Map<String, dynamic>;
                  return bookTypeSnapshotData["name"];
                })),
                builder: (context, futureBookTypeNames) {
                  if(!futureBookTypeNames.hasData) return CircularProgressIndicator();
                  //chuyển từ Future (BĐB)->Đồng bộ
                  var bookTypeNames = futureBookTypeNames.data;
                  return Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButton<BookTypeSnapshot>(
                      isExpanded: true,
                      value: bookType,
                      items: bookTypes.map((sns) => DropdownMenuItem(
                        child: Text(sns.bookType.name),
                        value: sns,
                      )).toList(),
                      onChanged: (BookTypeSnapshot? newValue) {
                        if (newValue != null) {
                          setState(() {
                            bookType = newValue;
                          });
                        }
                      },
                    ),
                    TextField(
                      style: TextStyle(height: 0.5),
                      controller: txtSearchKeyword,
                      decoration: InputDecoration(
                        labelText: "Nhập từ khóa",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String keyword = txtSearchKeyword.text.trim().toLowerCase();
                        setState(() {
                          filteredList = fullList.where((book)=>book.book.bookTypeRef == bookType!.ref).toList();
                          filteredList = filteredList.where((book) {
                            return book.book.name.toLowerCase().contains(keyword)
                                ||book.book.author.toLowerCase().contains(keyword)
                                ||book.book.publicationYear.toString().toLowerCase().contains(keyword);
                          }).toList();
                        });
                      },
                      child: Text("Tìm kiếm"),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          var bookSnapshot = filteredList[index];
                          String bookType = bookTypeNames![index];
                                  return Slidable(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Image.network(bookSnapshot.book.image!, height: 100, fit: BoxFit.cover,),),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Tên sách: ${bookSnapshot.book.name}", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("Giá: ${bookSnapshot.book.price}"),
                                                  Text("Số lượng: ${bookSnapshot.book.quantity.toString()}"),
                                                  //Text("Thể loại: ${bookType}"),
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
                        separatorBuilder: (context, index) => Divider(thickness: 1.5),
                      ),
                    )
                  ]);
                },);

          },
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    fetchBookTypes();
  }
  void fetchBookTypes() async {
    Stream<List<BookTypeSnapshot>> bookTypeSnapshots = BookTypeSnapshot.getAll();
    await for (var snapshot in bookTypeSnapshots) {
      setState(() {
        bookTypes = snapshot;
        bookType =bookTypes[0];
      });
    }
  }
}
