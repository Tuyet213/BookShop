
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';

import '../../model/customer.dart';
import '../../model/staff.dart';

class UpdateCustomerPage extends StatefulWidget {
  CustomerSnapshot customerSnapshot;

  @override
  State<UpdateCustomerPage> createState() => _UpdateCustomerPageState();

  UpdateCustomerPage({
    required this.customerSnapshot,
  });
}

class _UpdateCustomerPageState extends State<UpdateCustomerPage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật khách hàng"),
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
              TextField(
                controller: txtAddress,
                decoration: InputDecoration(
                    labelText: "Địa chỉ"
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        if(!txtId.text.trim().isEmpty && !txtName.text.trim().isEmpty && !txtEmail.text.trim().isEmpty && !txtPhone.text.trim().isEmpty && !txtPassword.text.trim().isEmpty && !txtAddress.text.trim().isEmpty){
                          Customer customer = Customer(id: txtId.text.trim(), name: txtName.text.trim(), email: txtEmail.text.trim(), phone: txtPhone.text.trim(), password: txtPassword.text.trim(), address: txtAddress.text.trim());

                          showMySnackBar(context, "Đang cập nhật khách hàng", 3);
                          _updateCustomer(customer);
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
    widget.customerSnapshot.ref.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var customer = Customer.fromJson(snapshot.data() as Map<String, dynamic>);
        setState(() {
          txtId.text = customer.id;
          txtName.text = customer.name;
          txtPassword.text = customer.password;
          txtPhone.text = customer.phone;
          txtEmail.text = customer.email;
          txtAddress.text = customer.address;
        });
      }
    });
  }
  _updateCustomer(Customer customer){
    widget.customerSnapshot.update(customer)
        .then((value) => showMySnackBar(context,"Cập nhật khách hàng thành công",3 ))//: ${txtName.text.trim()}"
        .catchError((error){
      return showMySnackBar(context,"Cập nhật khách hàng không thành công" ,3 );//: ${txtName.text.trim()}
    }
    );
  }
}





