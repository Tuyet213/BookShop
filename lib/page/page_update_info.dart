import 'package:bookshop/model/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'component.dart';

class PageEditInfo extends StatefulWidget {
  const PageEditInfo({
    super.key,
    required this.userSnapshot,
  });
  final CustomerSnapshot userSnapshot;

  @override
  State<PageEditInfo> createState() => _PageEditInfoState();
}

class _PageEditInfoState extends State<PageEditInfo> {
  CustomerSnapshot? us;
  final GlobalKey<FormState> formConfirm = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtAddress = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    us = widget.userSnapshot;
    if (us != null) {
      txtName.text = us!.customer.name;
      txtAddress.text = us!.customer.address;
      txtPhone.text = us!.customer.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Edit Info",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/icons/notification.svg"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/background.png"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.userSnapshot.customer.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                widget.userSnapshot.customer.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Form(
                key: formConfirm,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          TextFormFieldWidget(
                            keyboardType: TextInputType.text,
                            controller: txtName,
                            validator: (value) => validatName(value),
                            label: "Name",
                            icon: Icons.person,
                            obscureText: false,
                            suffixIcon: null,
                          ),
                          const SizedBox(height: 30),
                          TextFormFieldWidget(
                            keyboardType: TextInputType.text,
                            controller: txtAddress,
                            validator: (value) => validateAddress(value),
                            label: "Address",
                            icon: Icons.place,
                            obscureText: false,
                            suffixIcon: null,
                          ),
                          const SizedBox(height: 30),
                          TextFormFieldWidget(
                            keyboardType: TextInputType.number,
                            controller: txtPhone,
                            validator: (value) => validatePhone(value),
                            label: "Phone",
                            icon: Icons.phone,
                            obscureText: false,
                            suffixIcon: null,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidget(
                          context: context,
                          width: 200,
                          height: 48,
                          icon: Icons.edit,
                          label: "Update",
                          press: () async {
                            saveInfor(context);
                            Customer newUser = Customer(
                              id: "",
                              name: txtName.text,
                              address: txtAddress.text,
                              email: widget.userSnapshot.customer.email,
                              phone: txtPhone.text,
                              //password: '',
                            );
                            await widget.userSnapshot.update(newUser);
                            showSnackBar(
                                context, "User updated successfully!", 2);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveInfor(BuildContext context) {
    if (formConfirm.currentState!.validate()) {
      formConfirm.currentState!.save();
    }
  }

  String? validatName(String? s) {
    return s == null || s.isEmpty ? "Enter your name" : null;
  }

  String? validateAddress(String? s) {
    return s == null || s.isEmpty ? "Enter your address" : null;
  }

  String? validatePhone(String? s) {
    return s == null || s.isEmpty ? "Enter your phone" : null;
  }

  String? validateAge(String? s) {
    if (s == null || s.isEmpty) {
      return "Incorrect age";
    }
    int? age = int.tryParse(s);
    if (age == null) {
      return "Incorrect age";
    }
    if (age < 0 || age > 100) {
      return "Incorrect age";
    }
    return null;
  }
}
