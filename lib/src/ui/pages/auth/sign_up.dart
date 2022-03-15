import 'package:doingdubai/config/app_urls.dart';
import 'package:doingdubai/config/dio/app_dio.dart';
import 'package:doingdubai/config/dio/functions.dart';
import 'package:doingdubai/config/keys/pref_keys.dart';
import 'package:doingdubai/config/keys/response_code.dart';
import 'package:doingdubai/src/ui/pages/personaility_test.dart';
import 'package:doingdubai/src/ui/widgets/buttons.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/images.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../../widgets/decrated_text_field.dart';
import '../../widgets/image_auth_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;
  late AppDio _dio;

  bool loadCountries = true;

  var dropDownValues;

  String _selectedDropDown = "";

  var _countryController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = AppDio(context);

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoImageWidget(),
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
                hintText: 'Enter Country Name',
                controller: _countryController,
                validator: (s) => ((s ?? '').isEmpty) ? "Required" : null,
              ),
              /* loadCountries
                  ? Center(child: CircularProgressIndicator())
                  : DropDownField(
                      value: _selectedDropDown,
                      hintText: 'Please Select Country',
                      dataSource: dropDownValues,
                      onChanged: (v) {
                        print(v);
                        setState(() {
                          _selectedDropDown = v;
                        });
                      },
                      valueField: 'name',
                      textField: 'name',
                    ),*/
              // DecoratedTextField(
              //   hintText: 'Enter Your Country',
              //   controller: _countryController,
              //   validator: (value) {
              //     if (value!.isEmpty) return "Required";
              //     return null;
              //   },
              // ),
              _buildTextFieldLabel(
                label: 'Password',
              ),
              DecoratedTextField(
                obscure: true,
                hintText: 'Enter Password',
                controller: _passwordController,
                validator: (text) {
                  if (!(text!.length > 5) && text.isNotEmpty) {
                    return " \"Password\" length must be at least 6 characters long";
                  }
                },
              ),
              _buildTextFieldLabel(
                label: 'Confirm Password',
              ),
              DecoratedTextField(
                obscure: true,
                hintText: 'Enter Confirm Password',
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value!.trim() == "") return "Required";
                  if (value.trim() != _passwordController.getText())
                    return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              AuthButton(
                  text: "Sign Up",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp();
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              _buildSocialButtonRow(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildSocialButtonRow() {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
              text: 'Sign Up', url: AppImages.facebookLogo, onTap: () {}),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: SocialButton(
              text: 'Sign Up',
              url: AppImages.appleLogo,
              onTap: () {},
              backGroundColor: Colors.black),
        ),
      ],
    );
  }

  init() async {
    //  await getCountries();
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

  getCountries() async {
    var responseData;
    try {
      var response = await _dio.get(
          path: "http://magnijobs.applypressure.co.uk/api/all-countries");
      print("xxxxxresponse");
      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        var user = responseData['data']['countries'];

        dropDownValues = user;
        loadCountries = false;
        setState(() {});
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

  _signUp() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: Text("Please wait..."));
    var responseData;

    try {
      var response = await _dio.post(
        path: AppUrl.signUpUrl,
        data: {
          "first_name": _firstController.getText(),
          "last_name": _lastController.getText(),
          "email": _emailController.getText(),
          "mobile": _phoneController.getText(),
          "country": _countryController.text,

          ///needs to replace
          "password": _passwordController.getText(),
          "password_confirmation": _confirmPasswordController.getText(),
        },
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        if (responseData['status']) {
          var user = responseData['data']['user'];
          var token = responseData['data']['token'];

          await Prefs.getPrefs().then((prefs) {
            prefs.setString(PrefKey.FIRST_NAME, user['first_name']);
            prefs.setString(PrefKey.LAST_NAME, user['last_name'] ?? "");
            prefs.setString(PrefKey.EMAIL, user['email']);
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

            prefs.setString(PrefKey.AUTHORIZATION, token);
          });

          replace(PersonalityTestPage());
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
