
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/custom_ui/customelevatedbutton.dart';
import 'package:firebase_2/custom_ui/customform.dart';
import 'package:firebase_2/provider/passwordvisibility.dart';
import 'package:firebase_2/util/string_const.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {

   ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final RegExp emailRegex =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final _formKey = GlobalKey<FormState>();

  final  TextEditingController _emailController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }



  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email:_emailController.text.trim() );
      showDialog(context: context, builder: (context) {
        return AlertDialog(content: Text("Password reset link sent! Check your email"));
      },);

    } on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(content: Text(e.message.toString()),);
      },);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
      Container(
      color: kprimaryColor,
      ),
      Consumer<Passwordvisibility>(builder: (context, passwordVisibility, child) => 
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.transparent,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:15,right: 15,top: 25),
                  child: Form(
                      key: _formKey ,
                    
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8),
                      child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Forget Password?", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: kprimaryColor)),
                          Row(
                            children: [
                              Text("Already have an account?"),
                              SizedBox(
                                width: width(0.015, context),
                              ),
                              GestureDetector(child: Text("Login Now",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, decoration: TextDecoration.underline, color: kprimaryColor)),onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUi(),));
                                
                              },),
                            ],
                          ),
                          SizedBox(height: height(0.018, context),),
                              CustomForm(
                                hintText: "Email Address",
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icon(Icons.email,color: kprimaryColor,),
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return emailValidationStr;

                                  }
                                 else if(!emailRegex.hasMatch(value)){
                                      return 'Please enter a valid email';

                                  }
                                  else{
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: height(0.03, context)),
                              SizedBox(
                                width: width(0.88, context),
                                height: width(0.14, context),
                                child: CustomElevatedButton(onPressed: () {

                          if (_formKey.currentState!.validate()) {
                           passwordReset(); 
                          } 
                                },child: Text("Submit"),onprimary: Colors.white,primary: kprimaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                              )
                        
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ])

    );
    
  }

  height(value, context) {
    return MediaQuery.of(context).size.height * value;
  }

  width(value, context) {
    return MediaQuery.of(context).size.width * value;
  }
}