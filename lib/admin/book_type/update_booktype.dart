
import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateBookTypePage extends StatefulWidget {
  BookTypeSnapshot bookTypeSnapshot;
  UpdateBookTypePage({required this.bookTypeSnapshot, super.key});

  @override
  State<UpdateBookTypePage> createState() => _UpdateBookTypePageState();
}

class _UpdateBookTypePageState extends State<UpdateBookTypePage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật thể loại sách"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        if(!txtId.text.trim().isEmpty && !txtName.text.trim().isEmpty){
                          BookType bookType = BookType(id: txtId.text.trim(), name: txtName.text.trim());
                          print(widget.bookTypeSnapshot.bookType);
                          print(widget.bookTypeSnapshot.ref);
                          showMySnackBar(context, "Đang cập nhật thể loại sách", 3);
                          _updateBookType(bookType);
                        }
                        else{
                          showMySnackBar(context, "Không được để trống trường thông tin nào", 3);
                        }
                      },
                      child: Text("Cập nhật"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  // @override
  // void initState() {
  //   txtId.text = widget.bookTypeSnapshot.bookType.id;
  //   txtName.text = widget.bookTypeSnapshot.bookType.name;
  // }
  @override
  void initState() {
    super.initState();
    widget.bookTypeSnapshot.ref.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var bookType = BookType.fromJson(snapshot.data() as Map<String, dynamic>);
        setState(() {
          txtId.text = bookType.id;
          txtName.text = bookType.name;
        });
      }
    });
  }
  _updateBookType(BookType bookType){
    widget.bookTypeSnapshot.update(bookType)
        .then((value) => showMySnackBar(context,"Cập nhật thể loại sách thành công" ,3 ))//: ${txtName.text.trim()}
        .catchError((error){
      return showMySnackBar(context,"Cập nhật thể loại sách không thành công" ,3 );//: ${txtName.text.trim()}
    }
    );
  }
}





