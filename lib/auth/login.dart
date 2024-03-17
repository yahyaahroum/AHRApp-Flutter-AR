import 'dart:convert';

import 'package:flutter_gen_l10n_example/Components/costum_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_l10n_example/Components/text_form_field.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:http/http.dart' as http;
import '../home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  late String errormsg;
  late bool error, showprogress;

  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();




  startLogin() async {
    String apiurl = "https://idico.ma/ahrapp_flutter/login.php";

    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username.text, //get the username text
      'password': password.text  //get password text
    });

    if(response.statusCode == 200){
      var jsondata = json.decode(response.body);
      if(jsondata["error"]){
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];

        });
      }else{
        if(jsondata["success"]){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));

        }else{
          print('Something went wrong.');

        }
      }
    }else{
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(height: 50,),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 80,),
            const Text('المصادقة',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            const Text('قم بتسجيل الدخول للوصول إلى التطبيق',style: TextStyle(color: Colors.grey),),
            const SizedBox(height: 20,),
            const Text('إسم المستخدم' ,style: TextStyle(fontSize: 15),),
            const SizedBox(height: 5,),
            TextFormFieldEx(myhintText: " المرجوا إدخال اسم المستخدم",myController: username,),
            const SizedBox(height: 10,),
            const Text('كلمة المرور',style: TextStyle(fontSize: 15),),
            const SizedBox(height: 5,),
            TextFormField(
                obscureText: _isObscure,
                controller: password,
                decoration: InputDecoration(
                    hintText:'المرجوا إدخال كلمة المرور',
                    hintStyle: const TextStyle(fontSize: 14,color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.orange)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }))),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    if(username.text == ""){
                      PanaraInfoDialog.showAnimatedGrow(
                        context,
                        title: "خطأ في اسم المستخدم",
                        message:  "يجب إدخال اسم مستخدم صحيح !",
                        buttonText: "نعم",
                        onTapDismiss: () {
                          Navigator.pop(context);
                        },
                        panaraDialogType: PanaraDialogType.error,
                        barrierDismissible: false,
                      );
                      return;
                    }
                  },
                  child: const Text(
                    'استرجاع كلمة المرور ؟',
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 14),
                  ),
                )
            ),
            CostumButton(texteButton: "تسجيل الدخول", onPress:(){ setState(() {
              showprogress = true;
            });
            startLogin();

            },
            ),
            const SizedBox(height: 10,),
            MaterialButton(onPressed: (){

            },
              height: 40,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.red,
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("تسجيل الدخول باستخدام حساب جوجل  "),
                  Image.asset('assets/images/google.png',height: 15,)

                ],
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("register");
              },
              child: const Center(
                child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: "ليس لديك حساب ؟",),
                      TextSpan(text: "تسجيل",
                          style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,))
                    ]
                ),
                ),
              ),
            )],
        ),
      ),
    );
  }
}
