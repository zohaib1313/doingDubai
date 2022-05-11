import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/dio/functions.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/widgets/profile_image.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../../../utils/colors.dart';
import '../../widgets/decrated_text_field.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String? _profileImageURL;
  File? _imageFile;

  bool _loading = false;
  late AppDio _dio;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _dio = AppDio(context);
    _getUserData();
    super.initState();
  }

  int counterForImageCache = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        title: Text(
          'Update Profile',
          style: TextStyle(color: AppColors.kPrimary),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 28, right: 28, top: 8, bottom: 8),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: AppProfileImage(
                  title: "profile",
                  counter: counterForImageCache,
                  imagePicker: true,
                  height: 90,
                  width: 90,
                  imageUrl: _profileImageURL,
                  onImageSelected: (path, name) {
                    setState(() {
                      _imageFile = path;
                    });
                  },
                ),
              ),
              _buildTextFieldLabel(
                label: 'First Name',
              ),
              DecoratedTextField(
                hintText: 'Enter First Name',
                controller: _firstController,
                validator: (value) {
                  if (value!.isEmpty) return "Required";
                  return null;
                },
              ),
              _buildTextFieldLabel(
                label: 'Last Name',
              ),
              DecoratedTextField(
                hintText: 'Enter Last Name',
                controller: _lastController,
                validator: (value) {
                  if (value!.isEmpty) return "Required";
                  return null;
                },
              ),
              _buildTextFieldLabel(
                label: 'Email',
              ),
              DecoratedTextField(
                textInputType: TextInputType.emailAddress,
                hintText: 'Enter Email',
                controller: _emailController,
                validator: Validator.email("Invalid email address"),
              ),
              _buildTextFieldLabel(
                label: 'Contact Number',
              ),
              DecoratedTextField(
                hintText: 'Enter Contact Number',
                controller: _phoneController,
                validator: Validator.number("Invalid contact number"),
              ),
              _buildTextFieldLabel(
                label: 'Country',
              ),
              DecoratedTextField(
                hintText: 'Enter Your Country',
                controller: _countryController,
                validator: (value) {
                  if ((value ?? "").isEmpty) return "Required";
                  return null;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              AuthButton(
                  text: "Save",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      /* if (_imageFile != null) {
                        updateProfile();
                      } else {
                        alertDialog(context, "Error", "Image is required");
                      }*/
                      updateProfile();
                    }
                  }),
            ],
          ),
        ),
      )),
    );
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        _firstController.text = prefs.getString(PrefKey.FIRST_NAME)!;
        _lastController.text = prefs.getString(PrefKey.LAST_NAME)!;
        _emailController.text = prefs.getString(PrefKey.EMAIL)!;
        _phoneController.text = prefs.getString(PrefKey.MOBILE)!;
        _countryController.text = prefs.getString(PrefKey.COUNTRY)!;
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
      });
    });
  }

  Widget _buildTextFieldLabel({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: AppColors.kPrimary),
      ),
    );
  }

  updateProfile() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: Text("Please wait..."));
    var responseData;
    try {
      var formData;
      if (_imageFile != null) {
        print("--------->> if");
        String path = _imageFile!.path;
        formData = FormData.fromMap(
          {
            "first_name": _firstController.getText(),
            "last_name": _lastController.getText(),
            "email": _emailController.getText(),
            "mobile": _phoneController.getText(),
            "country": _countryController.getText(),
            "profile_pic": await MultipartFile.fromFile(path),
          },
        );
      } else {
        print("---------->> else");
        formData = FormData.fromMap(
          {
            "first_name": _firstController.getText(),
            "last_name": _lastController.getText(),
            "email": _emailController.getText(),
            "mobile": _phoneController.getText(),
            "country": _countryController.getText(),
          },
        );
      }

      var response =
          await _dio.post(path: AppUrl.updateProfile, data: formData);

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        if (responseData['status']) {
          var user = responseData['data']['user'];
          print(user);
          await Prefs.getPrefs().then((prefs) {
            prefs.setString(PrefKey.FIRST_NAME, user['first_name'] ?? '');
            prefs.setString(PrefKey.LAST_NAME, user['last_name'] ?? "");
            prefs.setString(PrefKey.EMAIL, user['email'] ?? "");
            prefs.setString(PrefKey.MOBILE, user['mobile'] ?? "");
            prefs.setString(PrefKey.FB_ID, user['fb_id'] ?? "");
            prefs.setString(PrefKey.TW_ID, user['tw_id'] ?? "");
            prefs.setString(PrefKey.IG_ID, user['ig_id'] ?? "");
            prefs.setString(PrefKey.PROFILE_PICTURE, user['profile_pic'] ?? "");
            prefs.setString(PrefKey.COUNTRY, user['country'] ?? "");
            prefs.setString(PrefKey.U_TYPE, user['utype'] ?? "");
            prefs.setString(PrefKey.CREATED_AT, user['created_at'] ?? "");
            prefs.setString(PrefKey.UPDATED_AT, user['updated_at'] ?? "");
            prefs.setString(PrefKey.DELETED_AT, user['deleted_at'] ?? "");
            prefs.setInt(PrefKey.ID, user['id']);
            imageCache?.clearLiveImages();
            imageCache?.clear();
            _profileImageURL =
                "${prefs.getString(PrefKey.PROFILE_PICTURE)}??dummy=${counterForImageCache++}";
            if (mounted) {
              setState(() {});
            }
          });

          pop();
        } else if (!responseData['status']) {
          warningDialog(context, "", responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      } else {
        if (responseData != null) {
          warningDialog(
              context, responseData['message'], responseData['description'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          // errorDialog(context, "Error", "Something went wrong please try again later", closeOnBackPress: true, neutralButtonText: "OK");
          responseError(context, response);
        }
      }
    } catch (e, s) {
      if (_loading) {
        pop();
        _loading = false;
      }

      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      errorDialog(context, "Error", responseData["message"],
          closeOnBackPress: true, neutralButtonText: "OK");

      // errorDialog(context, "Error", "Something went wrong please try again later", closeOnBackPress: true, neutralButtonText: "OK");
    }
  }
}
