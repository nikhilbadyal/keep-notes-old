//26-02-2021

import 'Utilites.dart';

class LockChecker  {
  int passwordLength ;
  String password;
  bool passwordSet ;
   bool bioEnabled ;
   bool bioAvailable ;

   void updateDetails() async {
  }

   void bioAvailCheck() async {
    bioAvailable = await Utilities.isBioAvailable();
  }

  LockChecker(this.passwordLength){
     initConfig();
  }

  Future<void> initConfig() async {
    password = await Utilities.getStringValuesSF('password');
    passwordSet = password == null ? false : true;
    bioEnabled = await Utilities.getBoolValuesSF('bio') == null ? false : bioEnabled;
    if(bioEnabled){
      bioAvailable = true;
    }else{
      bioAvailCheck();
    }
  }
}