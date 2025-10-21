import 'package:amir_api/services/auth.dart';
import 'package:amir_api/views/register.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();

  TextEditingController pwdController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: pwdController),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email cannot be empty.")),
                      );
                      return;
                    }
                    if (pwdController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password cannot be empty.")),
                      );
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await AuthServices()
                          .loginUser(
                            email: emailController.text,
                            pwd: pwdController.text,
                          )
                          .then((val) async {
                            await AuthServices()
                                .getProfile(val.token.toString())
                                .then((userModel) {
                                  isLoading = false;
                                  setState(() {});
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Message"),
                                        content: Text(
                                          "${userModel.user!.name.toString()} has been logged in successfully",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Text("Okay"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                          });
                    } catch (e) {
                      isLoading = false;  
                      setState(() {});
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Login"),
                ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterView()),
              );
            },
            child: Text("Go to Register"),
          ),
        ],
      ),
    );
  }
}
