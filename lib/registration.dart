import 'package:chatkuy/firebaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegistrationPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Daftar",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Enter Your Email",
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: "Enter Your Password",
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                  ),
                  onPressed: () async{
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                      service.createUser(context, emailController.text, passwordController.text);
                      
                      pref.setString("email", emailController.text);
                    }else{
                      service.errorBox(context, "Fields must be not empty. Please provide valid email and password");
                    }
                  },
                  child: Text("Register")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=>LoginPage()
                        )
                    );
                  },
                  child: Text("Already have an account")),
            ],
          ),
        ),
      ),
    );
  }
}