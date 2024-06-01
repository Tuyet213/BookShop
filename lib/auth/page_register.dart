import 'package:bookshop/auth/page_login.dart';
import 'package:bookshop/model/customer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../show_snackbar.dart';
import '../test.dart';
class PageRegister extends StatefulWidget {

   const PageRegister({Key? key}) : super(key: key);

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool togglePass = true; // dùng để ẩn hiện password
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            children: [
              // Image.asset("assets/images/jewel_shop.png", height: 220 ,),
              const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20, height: 1.5),),
              const SizedBox(height: 30,),
              Form(
                  key:formState,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: txtEmail,
                        validator: (value) => _validateEmail(value),
                        decoration: InputDecoration(
                          labelText: "Email"
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: txtPassword,
                        validator: (value) => _validatePassword(value),
                        decoration: InputDecoration(
                          labelText: "Password"
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: txtConfirmPassword,
                        validator: (value) => _validateConfirmPassword(value),
                        decoration: InputDecoration(
                          labelText: "Confirm Password"
                        ),
                      ),
                    ],
                  )
                ),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: () => createUserWithEmailAndPassword(), child: Text("Sign Up")),
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
                      // child:  Image.asset("assets/images/google.png" , height: 40,),
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
                      // child:  Image.asset("assets/images/facebook.png" , height: 40,),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //String? phoneNumber = "+1 650-555-1234";
                      showDialogPhone(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14.0),
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
                  const Text("Already have an account?"),
                  const SizedBox(width: 15,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PageLogin(),));
                      },
                      child: const Text("Login", style: TextStyle(color: Colors.orange),),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  _save(BuildContext context) {
    if (formState.currentState!.validate()){
      formState.currentState!.save();
    }
  }
void createUserWithEmailAndPassword  () async{
  _save(context);
  try {
    // Tạo tài khoản đăng nhập mới trên firebase
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text
    );
    showMySnackBar(context, "Registed successfully!", 5);
    Navigator.of(context).pop();
  } on FirebaseAuthException catch(e) {
    // Nếu tài khoản đã tồn tại
    print(e.code);
    showMySnackBar(context, "Email already existed!", 7);
  }
}
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
    else if (value.length <8){
      return "Password too short \nLength of password characters must be 8 \nor greater";
    }
    return null;
  }
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty){
      return "Please enter your password" ;
    }
    else if (value != txtPassword.text) {
      return "Password mismatch ";
    }
    return null;
  }
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
          labelText: "Phone"
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
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
              for(CustomerSnapshot customeSnapshot in resultList) {
                if(customeSnapshot.customer.phone == txtPhone.text) {
                  hasInfo = true;
                  break;
                }
              }
              // Nếu có rồi thì chạy thẳng vào Home
              if(hasInfo) {
                showMySnackBar(context, "Logging in...", 2);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => PageHome()),(route) => false);
              }
              // Nếu không thì tạo người dùng mới, thêm vào firebase rồi mới vào Home
              else {
                Customer newCustomer = Customer(
                  id: "",
                  name: temp,
                  address: "",
                  email: "",
                  phone: txtPhone.text,
                );
                CustomerSnapshot.add(newCustomer);
                showMySnackBar(context, "Logging in...", 2);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => PageHome(),),(route) => false);
              }
            }).catchError((error) {
              print(error);
            });
          },);},
            child: Text("Verification")),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel"))

      ],
    );
    showDialog(context: context, builder: (context) => dialog,);
  }
  void signInWithGoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((value){
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
          showMySnackBar(context, "Logging in...", 2);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PageHome()),
                (route) => false,
          );
        }
        // Nếu không thì tạo người dùng mới, thêm vào firebase rồi mới vào Home
        else {
          Customer newCustomer = Customer(
            id: "",
            name: temp,
            address: "",
            email: googleUser.email,
            phone: "",
          );
          CustomerSnapshot.add(newCustomer);
          showMySnackBar(context, "Logging in...", 2);
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
  void signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)
        .then((value){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PageHome()), (route) => false);
    } ).catchError((onError){
      print(onError);
    } );
  }

  void signInWithPhoneNumber(BuildContext context, { void Function()? onSigned, String? signIningMessage, String? signedMessage,
    Future<String?> Function()? smsCodePrompt, int timeOut = 30, required phoneNumber, String? smsTesCode
  } ) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: timeOut),
      verificationCompleted: (phoneAuthCredential)async {

      },
      verificationFailed: (error) {

      },
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
            print(e.code);
          }
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
      },
    );
  }

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
        ElevatedButton( child: Text("OK"), onPressed: (){Navigator.of(context, rootNavigator: true).pop(sms.text);}),
        ElevatedButton( child: Text("Cancel"), onPressed: (){Navigator.of(context, rootNavigator: true).pop(null);}),
      ],
    );
    String? res = await showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );
    return res;
  }
}


