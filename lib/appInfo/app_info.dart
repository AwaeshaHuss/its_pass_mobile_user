import 'package:flutter/material.dart';
import 'package:itspass_user/models/address_models.dart';

class AppInfoClass extends ChangeNotifier{
  AddressModel? pickUpLocation;
  AddressModel? dropOffLocation;

  void updatePickUpLocation(AddressModel pickUpModel){
    pickUpLocation = pickUpModel;
    notifyListeners();  
  }

  void updateDropOffLocation(AddressModel dropOffModel){
    dropOffLocation = dropOffModel;
    notifyListeners();
  }
}