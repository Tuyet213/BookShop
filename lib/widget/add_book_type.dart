import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';

import '../model/booktype.dart';

class AddBookTypePage extends StatefulWidget {
  const AddBookTypePage({super.key});

  @override
  State<AddBookTypePage> createState() => _AddBookTypePageState();
}

class _AddBookTypePageState extends State<AddBookTypePage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Thêm thể loại sách"),
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
                            if(txtId.text!=null && txtName.text!=null){
                              BookType bookType = BookType(id: txtId.text, name: txtName.text);
                              showMySnackBar(context, "Đang thêm thể loại sách", 10);
                              _addBookType(bookType);
                            }
                            else{
                              showMySnackBar(context, "Không được để trống trường thông tin nào", 3);
                            }
                          },
                          child: Text("Thêm"))
                    ],
                  )
                ]
            ),
          ),
        )
    );
  }
  _addBookType(BookType bookType){
    BookTypeSnapshot.add(bookType)
        .then((value) => showMySnackBar(context, "Thêm thể loại sách thành công", 3))
        .catchError((error)=>showMySnackBar(context, "Thêm thể loại sách không thành công", 3));
  }
}

