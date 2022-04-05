import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/dio/functions.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/src/ui/pages/personaility_test.dart';
import 'package:dubai_screens/src/ui/pages/auth/sign_up.dart';
import 'package:dubai_screens/src/ui/widgets/image_auth_page.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../../../utils/images.dart';
import '../../../utils/nav.dart';
import '../../widgets/buttons.dart';
import '../../widgets/decrated_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late AppDio _dio;

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const LogoImageWidget(),
            _buildTextFieldLabel(
              label: 'Email',
            ),
            DecoratedTextField(
              textInputType: TextInputType.emailAddress,
              hintText: 'Enter Email',
              controller: _emailController,
              validator: Validator.email("Email is not Valid"),
            ),
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
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 10),
              child: AuthButton(
                  text: "Sign In",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                    // AppNavigation().push(context, const PersonalityTestPage());
                  }),
            ),
            Center(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.kPrimary),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            SocialButton(
              text: 'Sign In with facebook',
              url: AppImages.facebookLogo,
              onTap: () {},
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            SocialButton(
              text: 'Sign In with Apple',
              url: AppImages.appleLogo,
              onTap: () {},
              backGroundColor: Colors.black,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(),
                ),
                TextButton(
                    onPressed: () {
                      AppNavigation().push(context, const SignUpPage());
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: AppColors.kPrimary, fontSize: 16),
                    ))
              ],
            )
          ]),
        ),
      )),
    );
  }

  Widget _buildTextFieldLabel({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: AppColors.kPrimary),
      ),
    );
  }

  _login() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: Text("Please wait..."));
    var responseData;

    try {
      var response = await _dio.post(
        path: AppUrl.loginUrl,
        data: {
          "email": _emailController.getText(),
          "password": _passwordController.getText(),
        },
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        var user = responseData['data']['user'];
        var token = responseData['data']['token'];

        await Prefs.getPrefs().then((prefs) {
          prefs.setInt(PrefKey.ID, user['id']);
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
          prefs.setBool(PrefKey.FIRST_TIME_LOGIN, false);
          prefs.setString(PrefKey.AUTHORIZATION, token);
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PersonalityTestPage()),
            (Route<dynamic> route) => false);

        // replace(PersonalityTestPage());
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
