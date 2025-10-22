import 'package:amir_api/providers/token.dart';
import 'package:amir_api/providers/user.dart';
import 'package:amir_api/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    nameController = TextEditingController(
      text: userProvider.getUser()!.user!.name.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile")),
      body: Column(
        children: [
          TextField(controller: nameController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Name cannot be empty.")),
                );
                return;
              }
              try {
                await AuthServices()
                    .updateProfile(
                      token: tokenProvider.getToken().toString(),
                      name: nameController.text,
                    )
                    .then((val) async{

                     await AuthServices()
                                .getProfile(tokenProvider.getToken().toString())
                                .then((userModel) {
                                  userProvider.setUser(userModel);
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
                                            onPressed: () {
                                           Navigator.pop(context);
                                           Navigator.pop(context);
                                            },
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
            child: Text("Update Profile"),
          ),
        ],
      ),
    );
  }
}
