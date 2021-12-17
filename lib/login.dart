import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration.dart';
import 'firebaseHelper.dart';

class LoginPage extends StatelessWidget {

  Service service = Service();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chatkuy",
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
                      service.loginUser(context, emailController.text, passwordController.text);

                      pref.setString("email", emailController.text);
                    }else{
                      service.errorBox(context, "Fields must be not empty. Please provide valid email and password");
                    }
                  },
                  child: Text("Login")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=>RegistrationPage()
                        )
                    );
                  },
                  child: Text("i dont have any account")),
            ],
          ),
        ),
      ),
    );
  }
}