import 'package:bookshop/model/customer.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:flutter/material.dart';


class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Thêm khách hàng"),
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
                            if(!txtId.text.trim().isEmpty && !txtName.text.trim().isEmpty && !txtEmail.text.trim().isEmpty && !txtPhone.text.trim().isEmpty  && !txtAddress.text.trim().isEmpty){
                              Customer customer = Customer(id: txtId.text.trim(), name: txtName.text.trim(), email: txtEmail.text.trim(), phone: txtPhone.text.trim(),  address: txtAddress.text.trim());
                              showMySnackBar(context, "Đang thêm khách hàng", 10);
                              _addCustomer(customer);
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
  _addCustomer(Customer customer){
    CustomerSnapshot.add(customer)
        .then((value) => showMySnackBar(context, "Thêm khách hàng thành công", 3))
        .catchError((error)=>showMySnackBar(context, "Thêm khách hàng không thành công", 3));
  }
}

