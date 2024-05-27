import 'package:bookshop/model/staff.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';


class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Thêm nhân viên"),
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
                  TextField(
                    controller: txtEmail,
                    decoration: InputDecoration(
                        labelText: "Email"
                    ),
                  ),
                  TextField(
                    controller: txtPhone,
                    decoration: InputDecoration(
                        labelText: "SĐT"
                    ),
                  ),
                  TextField(
                    controller: txtPassword,
                    decoration: InputDecoration(
                        labelText: "Mật khẩu"
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            if(txtId.text!=null && txtName.text!=null && txtEmail.text!=null && txtPhone.text!=null && txtPassword!=null){
                              Staff staff = Staff(id: txtId.text, name: txtName.text, email: txtEmail.text, phone: txtPhone.text, password: txtPassword.text);
                              showMySnackBar(context, "Đang thêm nhân viên", 10);
                              _addStaff(staff);
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
  _addStaff(Staff staff){
    StaffSnapshot.add(staff)
        .then((value) => showMySnackBar(context, "Thêm nhân viên thành công", 3))
        .catchError((error)=>showMySnackBar(context, "Thêm nhân viên không thành công", 3));
  }
}

