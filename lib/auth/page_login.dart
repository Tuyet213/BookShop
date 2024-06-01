import 'package:bookshop/auth/page_forgot_password.dart';
import 'package:bookshop/auth/page_register.dart';
import 'package:bookshop/show_snackbar.dart';
import 'package:bookshop/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/customer.dart';
import '../widget_connect_firebase.dart';


// App tạo kết nối đến Firebase, kết nối thành công sẽ chuyển đến PageLogin
class PageLoginConnection extends StatelessWidget {
  const PageLoginConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyFirebaseConnect(
      connectingMessage: "Đang kết nối",
      errorMessage: "Lỗi",
      builder:(context)=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageLogin(),
      ),
    );
  }
}

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  String validateEmail="";
  String validatePassword="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset("assets/images/jewel_shop.png", height: 220 ,),
                  const Text("Login", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20, height: 1.5),),
                  const SizedBox(height: 30,),
                  Form(
                      key:formState,
                      // Tắt tự động xác thực
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          // Widget input bên component.dart
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: txtEmail,
                            validator: (value) => _validateEmail(value),
                            decoration: InputDecoration(
                              labelText: "Email",
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 25,
                            // Hiển thị email có trên Firebase chưa
                            child: validateEmail=="" ? null : const Text("Please check your email again", style: TextStyle(color: Colors.red),),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: txtPassword,
                            validator: (value) => _validatePassword(value),
                            decoration: InputDecoration(
                              labelText: "Mật khẩu",
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 25,
                            // Hiển thị pass có trên Firebase chưa
                            child: validatePassword=="" ? null : const Text("Please check your password again", style: TextStyle(color: Colors.red),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PageForgotPassword(),));
                                  },
                                  child: const Text("Forgot Password?", style:TextStyle(color: Colors.orange),),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: () => signInWithEmail(),
                              child: Icon(Icons.login))
                        ],
                      )
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.black, height: 1.5,)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Text("Or"),
                      ),
                      Expanded(child: Divider(color: Colors.black, height: 1.5,)),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          signInWithGoogle();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black12
                              ),
                              shape: BoxShape.circle
                          ),
                           child:  Icon(Icons.g_mobiledata),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          signInWithFacebook();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black12
                              ),
                              shape: BoxShape.circle
                          ),
                           child:  Icon(Icons.facebook),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                           //String? phoneNumber = "+1 650-555-1234";
                          showDialogPhone(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black12
                              ),
                              shape: BoxShape.circle
                          ),
                          child:  const Icon(Icons.phone, size: 30,),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 15,),
                      TextButton(
                        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const PageRegister(),)),
                        child: const Text("Sign Up", style: TextStyle(color: Colors.orange),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  void signInWithEmail  () async {
    try {
      showMySnackBar(context, "Logging in...", 1);
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text,
      );
      print((credential.credential ?? null)
          .toString());
      convertStreamToList(CustomerSnapshot.getAll()).then((resultList) {
        // Biến kiểm tra thông tin tài khoản đăng nhập đã có trong bảng customers chưa
        bool hasInfo = false;
        String temp = "Customer";
        for(CustomerSnapshot customerSnapshot in resultList) {
          // Nếu email nhập vào có trong bảng users
          if(customerSnapshot.customer.email == txtEmail.text) {
            temp = customerSnapshot.customer.name;
            hasInfo = true;
            break;
          }
        }
        if(hasInfo) {
          showMySnackBar(context, "Logged in successfully!", 2);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PageHome()),
                (route) => false,
          );
        }
        else {
          Customer newCustomer = Customer(
            id: "",
            name: txtEmail.text,
            address: "",
            email: txtEmail.text,
            phone: "",
          );
          CustomerSnapshot.add(newCustomer);
          showMySnackBar(context, "Logged in successfully!", 2);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PageHome()),
                (route) => false,
          );
        }
      }).catchError((error) {});
    } on FirebaseAuthException catch (e) {
      // Lỗi không có tài khoản email trên firebase
      if (e.code == 'user-not-found') {
        setState(() {
          validateEmail="Incorrect Email";
        });
      } else if (e.code == 'wrong-password') {
        // Mật khẩu không đúng
        setState(() {
          validateEmail= "";
          validatePassword = "Password incorrect";
        });
      }
      else if (e.code != 'wrong-password'){
        // Một lỗi khác khác lỗi sai mật khẩu
        setState(() {
          validatePassword = "";
        });
      }
    }
     catch (e) {
      print('Lỗi khi đăng nhập: $e');
    }
    // Gọi hàm kiểm tra tính hợp lệ của form
    _save(context);

  }
  void signInWithGoogle() async{
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        // Lấy thông tin xác thực từ yêu cầu đăng nhập Google
        GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

        // Đăng nhập bằng token
        var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential).then((value){
          // Đăng nhập thành công
          convertStreamToList(CustomerSnapshot.getAll()).then((resultList) {
            bool hasInfo = false;
            String temp = googleUser.displayName!;
            for(CustomerSnapshot customerSnapshot in resultList) {
              print(customerSnapshot.customer.email);
              if(customerSnapshot.customer.email == googleUser.email) {
                hasInfo = true;
                break;
              }
            }
            // Nếu có rồi thì chạy thẳng vào Home
            if(hasInfo) {
              showMySnackBar(context, "Logged in successfully!", 2);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => PageHome()),
                    (route) => false,
              );
            }
            // Nếu không thì tạo người dùng mới, thêm vào firebase rồi mới vào Home
            else {
              Customer newCustomer = Customer(
                id: "",
                name: googleUser.email,
                address: "",
                email: googleUser.email,
                phone: "",
              );
              CustomerSnapshot.add(newCustomer);
              showMySnackBar(context, "Logged in successfully!", 2);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => PageHome()),
                    (route) => false,
              );
            }
          }).catchError((error) {
            print(error);
          });
        } );
  }

  // Hiển thị dialog nhập số điện thoại
  void showDialogPhone(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: const Text("Enter your phone", textAlign: TextAlign.center,),
      content:
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: txtPhone,
            validator: (value) {
            },
            decoration: InputDecoration(
              labelText: "Số điện thoại"
            ),
          ),
      actions: [
        ElevatedButton(
            onPressed:() {
              Navigator.of(context).pop();
              signInWithPhoneNumber(
                context, phoneNumber: txtPhone.text,
                timeOut: 60,
                smsTesCode: "123456",
                smsCodePrompt: () => showPromtSMSCodeInput(context),
                onSigned: (){
                  convertStreamToList(CustomerSnapshot.getAll()).then((resultList) {
                    bool hasInfo = false;
                    String temp = "Customer";
                    for(CustomerSnapshot customerSnapshot in resultList) {
                      if(customerSnapshot.customer.phone == txtPhone.text) {
                        hasInfo = true;
                        break;
                      }
                    }
                    // Nếu có rồi thì chạy thẳng vào Home
                    if(hasInfo) {
                      showMySnackBar(context, "Logged in successfully!", 2);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => PageHome(),),(route) => false);
                    }
                    // Nếu không thì tạo người dùng mới, thêm vào firebase rồi mới vào Home
                    else {
                      Customer newCustomer = Customer(
                        id: "",
                        name: temp,
                        address: "",
                        email: txtPhone.text,
                        phone: txtPhone.text,
                      );
                      CustomerSnapshot.add(newCustomer);
                      showMySnackBar(context, "Logged in successfully!", 2);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => PageHome()),(route) => false);
                    }
                  }).catchError((error) {
                    print(error);
                  });
                },
              );
            },
            child: Text("Verification")),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"))
      ],
    );
    showDialog(context: context, builder: (context) => dialog,);

  }

  // Đăng nhập bằng Facebook
  void signInWithFacebook() async {
        // Trigger the sign-in flow
        final LoginResult loginResult = await FacebookAuth.instance.login();
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
        // Once signed in, return the UserCredential
         await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)
             .then((value){
           showMySnackBar(context, "Logged in successfully!", 2);
           Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(builder: (context) => const PageHome()), (route) => false);
         } ).catchError((onError){
           print(onError);
         } );
  }

  void signInWithPhoneNumber(BuildContext context, { void Function()? onSigned, String? signIningMessage, String? signedMessage,
    Future<String?> Function()? smsCodePrompt, int timeOut = 30, required phoneNumber, String? smsTesCode
  }) {
    // Đăng nhập bằng số điện thoại
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        // Thời gian tồn tại xác thực
        timeout: Duration(seconds: timeOut),
        verificationCompleted: (phoneAuthCredential)async {},
        verificationFailed: (error) {},
        // Khi đã kiểm tra đúng số điện thoại, gửi code xác thực
        codeSent: (verificationId, forceResendingToken) async {
          print("Verification ID: $verificationId");
              String? smsCode = smsTesCode;
            if(smsCodePrompt!=null) {
              smsCode = await smsCodePrompt();
            }
            if(smsCode!=null){
              var credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode
              );
              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
                if(onSigned!=null) {
                  onSigned();
                }
              } on FirebaseAuthException catch(e){
                print(e);
              }
            }
        },
        codeAutoRetrievalTimeout: (verificationId) {
        },
    );
  }

  // Hiển thị dialog nhập SMS code
  Future<String?> showPromtSMSCodeInput(BuildContext context) async {
    TextEditingController sms =TextEditingController();
    AlertDialog dialog =AlertDialog(
      title: const Text("Enter SMS Code",textAlign: TextAlign.center),
      content: TextFormField(
          keyboardType: TextInputType.phone,
          controller: sms,
          validator: (value) {},
         decoration: InputDecoration(
           labelText: "SMS Code"
         ),
      ),
      actions: [
        ElevatedButton(onPressed: (){Navigator.of(context, rootNavigator: true).pop(sms.text);}, child: Text("OK")),
        ElevatedButton(onPressed: (){Navigator.of(context, rootNavigator: true).pop(null);}, child: Text("Cancel"))
      ],
    );
    String? res = await showDialog<String?>(
      barrierDismissible: false,
        context: context,
        builder: (context) => dialog,
    );
    return res;
  }

  // Các hàm điều kiện tra tính hợp lệ
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty){
      return "Please enter your email" ;
    }
    else if (!value.contains("@") || !value.contains(".")){
      return "Please enter a valid email";
    }
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty){
      return "Please enter your password";
    }
    return null;
  }

  // Hàm kiểm tra tính hợp lệ của form
  _save(BuildContext context) {
    if (formState.currentState!.validate()){
      formState.currentState!.save();
    }
  }

}


// Hàm chuyển đổi Strem<List<Item>> thành List<Item>
// Hàm bất đồng bộ trả về Future<List<Item>> đầu tiên của Stream.
Future<List<CustomerSnapshot>> convertStreamToList(Stream<List<CustomerSnapshot>> stream) async  {
  return await stream.first;
}







