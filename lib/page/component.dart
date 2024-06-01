import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/book.dart';

String description = "Chào mừng đến với cửa hàng BookShop của chúng tôi!\n\n"
    "Cửa hàng chúng tôi cung cấp nhiều sách hay và hot trên thị trường.\n\n"
    "Xin chân thành cảm ơn!";

class ScreenSize {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

// Widget tạo một card sản phẩm dùng trong PageHome
class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.press,
  }) : super(key: key);
  final String name, price, image;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(2),
        width: 180,
        height: 280,
        child: Card(
          elevation: 1,
          shadowColor: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.network(
                image,
                height: ScreenSize.getScreenWidth(context) * 0.43,
                width: ScreenSize.getScreenWidth(context) * 0.3,
              ),
              Text(name),
              Text(
                formatCurrency.format(double.parse(price)),
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget tạo một card danh mục dùng trong PageHome
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.type,
    required this.press,
  }) : super(key: key);
  final String type;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: ScreenSize.getScreenWidth(context) * 0.333,
      child: OutlinedButton(
        onPressed: press,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // Image.network(
              //   icon,
              //   height: 50,
              // ),
              const SizedBox(height: 5),
              Text(
                type,
                style: const TextStyle(color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget tạo một nút màu cam có chữ có icon
class ButtonWidget extends StatelessWidget {
  final BuildContext context;
  final double width, height;
  final IconData icon;
  final String label;
  final VoidCallback press;
  const ButtonWidget({
    super.key,
    required this.context,
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: const StadiumBorder(),
        ),
        icon: Icon(icon),
        label: Text(label),
        onPressed: press,
      ),
    );
  }
}

// Widget một input có chữ có icon
class TextFormFieldWidget extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String?) validator;
  final String label;
  final IconData icon;
  final bool? obscureText;
  final IconButton? suffixIcon;
  const TextFormFieldWidget({
    super.key,
    this.suffixIcon,
    this.obscureText,
    required this.keyboardType,
    required this.controller,
    required this.validator,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) => validator(value),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        label: Text(label, style: const TextStyle(color: Colors.brown)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(1, 1, 4, 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Colors.deepOrange,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget hiển thị thông tin người dung trong Drawer
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.email,
  });
  final String name, email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: ListTile(
        leading: const CircleAvatar(
          maxRadius: 25,
          backgroundImage: AssetImage("assets/images/background.png"),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.black87),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(color: Colors.black38),
        ),
      ),
    );
  }
}

// Widget tạo ListTile có chữ có icon trong PageUserInfo
class ProfileMenuTitle extends StatelessWidget {
  const ProfileMenuTitle({
    super.key,
    required this.text,
    required this.icon,
  });
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black54.withOpacity(0.1)),
        child: Icon(icon),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: text == "" || text == "0"
              ? Colors.red.withOpacity(0.5)
              : Colors.green.withOpacity(0.5),
        ),
        child: text == "" || text == "0"
            ? const Icon(Icons.close)
            : const Icon(Icons.check),
      ),
    );
  }
}

// Widget tạo một nút quay lại
class BackIcon extends StatelessWidget {
  const BackIcon({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        CupertinoIcons.left_chevron,
        color: Colors.black,
      ),
    );
  }
}

// Widget tạo một Icon ẩn
class BackNull extends StatelessWidget {
  const BackNull({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.add,
      color: Colors.transparent,
    );
  }
}

void showSnackBar(BuildContext context, String message, int second) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: second),
  ));
}

// Hàm bất đồng bộ hiển thị dialog xác nhận thanh toán trong PageCart
Future<bool> showConfirmDialog(
    BuildContext context, String title, String text) async {
  bool result = false;
  var dialog = AlertDialog(
    title: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orange,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 5,
            bottom: 5,
            right: 5,
            top: 5), //apply padding to some sides only
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
    content: SizedBox(
      height: 120,
      width: 333,
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonWidget(
            context: context,
            width: 100,
            height: 40,
            icon: Icons.verified_user,
            label: "OK",
            press: () {
              result = true;
              Navigator.of(context).pop(result);
            },
          ),
          ButtonWidget(
            context: context,
            width: 130,
            height: 40,
            icon: Icons.cancel,
            label: "Cancel",
            press: () {
              result = false;
              Navigator.of(context).pop(result);
            },
          ),
        ],
      ),
    ],
  );

  result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => dialog,
      ) ??
      false;
  return result;
}

class BookTypeNameWidget extends StatelessWidget {
  final DocumentReference bookTypeRef;
  final String bookTypeName = "";
  const BookTypeNameWidget({Key? key, required this.bookTypeRef})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: BookSnapshot.getBookTypeName(bookTypeRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Text('${snapshot.data}');
        } else {
          return Text('No data');
        }
      },
    );
  }

  static Future<String> getTypeName(DocumentReference bookTypeRef) async {
    try {
      DocumentSnapshot docSnap = await bookTypeRef.get();
      if (docSnap.exists) {
        return docSnap.get('name').toString();
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Error getting document: $e');
    }
  }
}
