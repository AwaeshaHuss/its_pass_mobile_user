import 'package:flutter/material.dart';
import 'package:uber_users_app/methods/common_methods.dart';
import 'package:uber_users_app/pages/home_page.dart';

import '../models/user_model.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  CommonMethods commonMethods = CommonMethods();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    gmailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: Initialize with user data from API
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BLoC pattern

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile Setup',
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 35),
              child: Column(
                children: [
                  Column(
                    children: [
                      // textFormFields
                      myTextFormField(
                        hintText: 'Enter Your Full Name',
                        icon: Icons.account_circle,
                        textInputType: TextInputType.name,
                        maxLines: 1,
                        maxLength: 25,
                        textEditingController: nameController,
                        enabled: true,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      myTextFormField(
                        hintText: 'Enter Your Email Address',
                        icon: Icons.account_circle,
                        textInputType: TextInputType.emailAddress,
                        maxLines: 1,
                        maxLength: 25,
                        textEditingController: gmailController,
                        enabled: true, // TODO: Handle Google sign-in state
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      myTextFormField(
                        hintText: 'Enter your phone number',
                        icon: Icons.phone,
                        textInputType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 13,
                        textEditingController: phoneController,
                        enabled: true, // TODO: Handle phone number state
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed:
                          saveUserDataToFireStore, // Correctly call the sendPhoneNumber function

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextFormField({
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
    required int maxLines,
    required int maxLength,
    required TextEditingController textEditingController,
    required bool enabled,
  }) {
    return TextFormField(
      enabled: enabled,
      cursorColor: Colors.grey,
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), color: Colors.black),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintText: hintText,
        alignLabelWithHint: true,
        border: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  // store user data via API
  void saveUserDataToFireStore() async {
    // TODO: Implement API-based user data saving
    UserModel userModel = UserModel(
        id: "temp_id", // TODO: Get from API response
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: gmailController.text.trim(),
        blockStatus: "no");

    if (nameController.text.length >= 3) {
      // TODO: Call API to save user data
      // For now, navigate to home screen
      navigateToHomeScreen();
    } else {
      commonMethods.displaySnackBar(
          'Name must be atleast 3 characters', context);
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }
}
