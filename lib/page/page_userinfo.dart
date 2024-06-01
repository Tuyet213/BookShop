import 'package:bookshop/model/customer.dart';
import 'package:bookshop/page/page_update_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'component.dart';

class PageUserInfo extends StatelessWidget {
  const PageUserInfo({Key? key, this.cusRef}) : super(key: key);
  final DocumentReference? cusRef;

  @override
  Widget build(BuildContext context) {
    if (cusRef == null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const Icon(
            Icons.add,
            color: Colors.transparent,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: const Center(
          child: Text("Customer reference is null"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.add,
          color: Colors.transparent,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      body: FutureBuilder<CustomerSnapshot>(
        future: CustomerSnapshot.getCustomerByRef(cusRef!),
        builder: (BuildContext context, snapshot) {
          print(snapshot.error);
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading customer data {snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenSize.getScreenWidth(context) * 0.032,
                      ),
                      SizedBox(
                        width: ScreenSize.getScreenWidth(context) * 0.286,
                        height: ScreenSize.getScreenHeight(context) * 0.128,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/background.png"),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        snapshot.data!.customer.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        snapshot.data!.customer.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ButtonWidget(
                        context: context,
                        width: 200,
                        height: 48,
                        icon: Icons.edit,
                        label: "Edit profile",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageEditInfo(userSnapshot: snapshot.data!),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileMenuTitle(
                          text: snapshot.data!.customer.name,
                          icon: Icons.person),
                      const Divider(),
                      ProfileMenuTitle(
                          text: snapshot.data!.customer.phone,
                          icon: Icons.phone),
                      const Divider(),
                      ProfileMenuTitle(
                          text: snapshot.data!.customer.email,
                          icon: Icons.email_outlined),
                      const Divider(),
                      ProfileMenuTitle(
                          text: snapshot.data!.customer.address,
                          icon: Icons.home),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
