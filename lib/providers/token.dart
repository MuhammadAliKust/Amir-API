import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier{
  String _token = "";

  void setToken(String token){
    _token = token;
    notifyListeners();
  }


  String getToken()=>_token;
}