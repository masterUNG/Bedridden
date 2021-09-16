import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bedridden/Screen/login.dart';
import 'package:bedridden/utility/dialog.dart';
import 'package:bedridden/Screen/my_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  bool statusRedEye = true;
  bool statusRedEye2 = true;
  // ignore: non_constant_identifier_names
  String? Username, Email, Password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff7e4db),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: const Color(0xfff7e4db),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     size: 20,
        //     color: Colors.black,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height - 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account, It's free ",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              onChanged: (value) => Username = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Username",
                                hintText: "Enter your username",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 45,
                                  vertical: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.black87),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.black87),
                                  gapPadding: 10,
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) => Email = value.trim(),
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Enter your email",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 45,
                                  vertical: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.black87),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(color: Colors.black87),
                                  gapPadding: 10,
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            obscureText: statusRedEye,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => Password = value.trim(),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      statusRedEye = !statusRedEye;
                                    });
                                  },
                                  icon: statusRedEye
                                      ? Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black87,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Colors.black87,
                                        )),
                              labelText: "Password",
                              hintText: "Enter your Password",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 45,
                                vertical: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(color: Colors.black87),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(color: Colors.black87),
                                gapPadding: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.only(top: 3, left: 3),
                              child: signupbutton(),
                            ),
                          ),
                          Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account?"),
                                TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.black87),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                      );
                                    },
                                    child: Text("Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ))),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton signupbutton() {
    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: () {
        print('Username = $Username, Email = $Email, Password =$Password');
        if ((Username?.isEmpty ?? true) ||
            (Email?.isEmpty ?? true) ||
            (Password?.isEmpty ?? true)) {
          print('ใส่ข้อมูลไม่ครบ');
          normalDialog(context, 'กรุณากรอกข้อมูล');
        } else {
          print('ครบถ้วน');
          signupFirebase();
        }
      },
      color: const Color(0xffdfad98),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        "Sign up",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<Null> signupFirebase() async {
    await Firebase.initializeApp().then((value) async {
      print('Firebase Initialize Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: (Email as String), password: (Password as String))
          .then((value) async {
        print('Signup Success');
        // ignore: deprecated_member_use
        await value.user!.updateProfile(displayName: Username).then((value) =>
            Navigator.pushNamedAndRemoveUntil(
                context, '/myService', (route) => true));
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
