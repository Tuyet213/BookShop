
import 'package:bookshop/model/booktype.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/staff.dart';

class UpdateStaffPage extends StatefulWidget {
  StaffSnapshot staffSnapshot;

  @override
  State<UpdateStaffPage> createState() => _UpdateStaffPageState();

  UpdateStaffPage({
    required this.staffSnapshot,
  });
}

class _UpdateStaffPageState extends State<UpdateStaffPage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật nhân viên"),
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

                          showMySnackBar(context, "Đang cập nhật nhân viên", 3);
                          _updateStaff(staff);
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
    widget.staffSnapshot.ref.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var staff = Staff.fromJson(snapshot.data() as Map<String, dynamic>);
        setState(() {
          txtId.text = staff.id;
          txtName.text = staff.name;
          txtPassword.text = staff.password;
          txtPhone.text = staff.phone;
          txtEmail.text = staff.email;
        });
      }
    });
  }
  _updateStaff(Staff staff){
    widget.staffSnapshot.update(staff)
        .then((value) => showMySnackBar(context,"Cập nhật nhân viên thành công: ${txtName.text}" ,3 ))
        .catchError((error){
      return showMySnackBar(context,"Cập nhật nhân viên không thành công: ${txtName.text}" ,3 );
    }
    );
  }
}





