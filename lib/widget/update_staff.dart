
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';
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
                keyboardType: TextInputType.phone,
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
                        if(!txtId.text.trim().isEmpty && !txtName.text.trim().isEmpty && !txtEmail.text.trim().isEmpty && !txtPhone.text.trim().isEmpty && !txtPassword.text.trim().isEmpty){
                          Staff staff = Staff(id: txtId.text.trim(), name: txtName.text.trim(), email: txtEmail.text.trim(), phone: txtPhone.text.trim(), password: txtPassword.text.trim());

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
        .then((value) => showMySnackBar(context,"Cập nhật nhân viên thành công",3 ))//: ${txtName.text.trim()}"
        .catchError((error){
      return showMySnackBar(context,"Cập nhật nhân viên không thành công" ,3 );//: ${txtName.text.trim()}
    }
    );
  }
}





