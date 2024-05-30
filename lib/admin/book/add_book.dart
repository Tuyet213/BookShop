import 'dart:io';

import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image_upload.dart';
import '../../model/book.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  XFile? _xFile;
  String? imageUrl;
  DocumentReference? bookTypeRef;
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtQuantity = TextEditingController();
  TextEditingController txtPublicationYear = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Thêm sách"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: StreamBuilder<List<BookTypeSnapshot>>(
          stream: BookTypeSnapshot.getAll(),
          builder: (context, snapshot) {
            if(snapshot.hasError) return Center(child: Text("Lỗi"),);
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
            var bookTypes = snapshot.data!;
            if (bookTypeRef == null && bookTypes.isNotEmpty) {
              bookTypeRef = bookTypes[0].ref; // Chỉ thiết lập một lần
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: [
                  DropdownButton<DocumentReference>(
                    isExpanded: true,
                  value: bookTypeRef,
                  items: bookTypes.map((sns) => DropdownMenuItem(
                    child: Text(sns.bookType.name),
                    value: sns.ref,
                  )).toList(),
                  onChanged: (DocumentReference? newValue) {
                    if (newValue != null) {
                      setState(() {
                        bookTypeRef = newValue;
                      });
                    }
                  },
                ),
                      Center(
                        child:  Container(
                          width: w*0.8,
                          height: w*0.8*2/3,
                          child: _xFile==null?Icon(Icons.image):Image.file(File(_xFile!.path)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async{
                                _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                if(_xFile!=null){
                                  setState(() {

                                  });
                                }
                              },
                              child: Text("Chọn ảnh")),

                        ],
                      ),
                      TextField(
                        controller: txtId,
                        decoration: InputDecoration(
                            labelText: "Id"
                        ),
                      ),
                      TextField(
                        controller: txtName,
                        decoration: InputDecoration(
                            labelText: "Tên"
                        ),
                      ),
                      TextField(
                        controller: txtDescription,
                        decoration: InputDecoration(
                            labelText: "Mô tả"
                        ),
                      ),
                      TextField(
                        controller: txtPrice,
                        decoration: InputDecoration(
                            labelText: "Giá"
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: txtQuantity,
                        decoration: InputDecoration(
                            labelText: "Số lượng"
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: txtPublicationYear,
                        decoration: InputDecoration(
                            labelText: "Năm phát hành"
                        ),
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                imageUrl = await uploadImage(imagePath: _xFile!.path, folders: ["book_app"], fileName: "${txtId.text}.jpg");
                                if(imageUrl!=null) {
                                  if (!txtId.text.trim().isEmpty &&
                                      !txtName.text.trim().isEmpty &&
                                      !txtDescription.text.trim().isEmpty &&
                                      bookTypeRef != null &&
                                      !txtQuantity.text.trim().isEmpty&&
                                      !txtPublicationYear.text.trim().isEmpty &&
                                      !txtPrice.text.trim().isEmpty && imageUrl != null) {
                                    Book book = Book(id: txtId.text.trim(),
                                        name: txtName.text.trim(),
                                        description: txtDescription.text.trim(),
                                        image: imageUrl!,
                                        price: double.parse(txtPrice.text.trim()),
                                        quantity: int.parse(txtQuantity.text.trim()),
                                        publicationYear: int.parse(
                                            txtPublicationYear.text.trim()),
                                        bookTypeRef: bookTypeRef!);
                                    showMySnackBar(
                                        context, "Đang thêm  sách", 10);
                                    _addBook(book);
                                  }
                                  else showMySnackBar(context, "Không được để trống trường thông tin nào", 3);
                                }
                                else{
                                  showMySnackBar(context, "Không được để trống ảnh", 3);
                                }
                              },
                              child: Text("Thêm")
    )
                        ],
                      )
                    ]
                ),
              ),
            );
          }
        )
    );
  }
  _addBook(Book book){
    BookSnapshot.add(book)
        .then((value) => showMySnackBar(context, "Thêm  sách thành công", 3))
        .catchError((error)=>showMySnackBar(context, "Thêm  sách không thành công", 3));
  }
}

