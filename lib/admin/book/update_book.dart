import 'dart:io';

import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image_upload.dart';
import '../../model/book.dart';

class UpdateBookPage extends StatefulWidget {
  BookSnapshot bookSnapshot;
  UpdateBookPage({required this.bookSnapshot, super.key});

  @override
  State<UpdateBookPage> createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  XFile? _xFile;
  String? imageUrl;
  bool setImage = false;
  DocumentReference? bookTypeRef;
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtAuthor = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtQuantity = TextEditingController();
  TextEditingController txtPublicationYear = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Cập nhật sách"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: StreamBuilder<List<BookTypeSnapshot>>(
            stream: BookTypeSnapshot.getAll(),
            builder: (context, snapshot) {
              if(snapshot.hasError) return Center(child: Text("Lỗi"),);
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
              var bookTypes = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: [
                        Center(
                          child:  Container(
                            width: w*0.8,
                            height: w*0.8*2/3,
                            child: setImage?_xFile==null?Icon(Icons.image):Image.file(File(_xFile!.path)):Image.network(imageUrl!),
                          ),
                        ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () async{
                                  _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if(_xFile!=null){
                                    setState(() {
                                      setImage=true;

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
                          controller: txtAuthor,
                          decoration: InputDecoration(
                              labelText: "Tác giả"
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
                                  if(_xFile == null) imageUrl = widget.bookSnapshot.book.image;
                                  else imageUrl = await uploadImage(imagePath: _xFile!.path, folders: ["book_app"], fileName: "${txtId.text}.jpg");
                                  if(imageUrl!=null) {
                                    if (!txtId.text.trim().isEmpty &&
                                        !txtName.text.trim().isEmpty &&
                                        !txtDescription.text.trim().isEmpty &&
                                        !txtAuthor.text.trim().isEmpty &&
                                        bookTypeRef != null &&
                                        !txtQuantity.text.trim().isEmpty&&
                                        !txtPublicationYear.text.trim().isEmpty &&
                                        !txtPrice.text.trim().isEmpty && imageUrl != null) {
                                      Book book = Book(id: txtId.text.trim(),
                                          name: txtName.text.trim(),
                                          description: txtDescription.text.trim(),
                                          author: txtAuthor.text.trim(),
                                          image: imageUrl!,
                                          price: double.parse(txtPrice.text.trim()),
                                          quantity: int.parse(txtQuantity.text.trim()),
                                          publicationYear: int.parse(
                                              txtPublicationYear.text.trim()),
                                          bookTypeRef: bookTypeRef!);
                                      showMySnackBar(
                                          context, "Đang cập nhật sách", 10);
                                      _updateBook(book);
                                    }
                                    else showMySnackBar(context, "Không được để trống trường thông tin nào", 3);
                                  }
                                },
                                child: Text("Cập nhật")
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
  @override
  void initState() {
    super.initState();
    widget.bookSnapshot.ref.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var book = Book.fromJson(snapshot.data() as Map<String, dynamic>);
        setState(() {
          txtId.text = book.id;
          txtName.text = book.name;
          txtPublicationYear.text = book.publicationYear.toString();
          txtQuantity.text = book.quantity.toString();
          txtPrice.text = book.price.toString();
          txtDescription.text = book.description;
          bookTypeRef =  book.bookTypeRef;
          imageUrl = book.image;
        });
      }
    });
  }
  _updateBook(Book book){
    widget.bookSnapshot.update(book)
        .then((value) => showMySnackBar(context,"Cập nhật sách thành công" ,3 ))//: ${txtName.text.trim()
        .catchError((error){
      return showMySnackBar(context,"Cập nhật sách không thành công",3 );//: ${txtName.text.trim()}"
    }
    );
  }
}

