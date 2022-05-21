import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/dio/functions.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/src/ui/pages/auth/update_profle.dart';
import 'package:dubai_screens/src/ui/pages/get_started.dart';
import 'package:dubai_screens/src/ui/pages/home_page.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';
import 'package:req_fun/src/functions/extensions.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';

class ProfilePageBottom extends StatefulWidget {
  const ProfilePageBottom({Key? key}) : super(key: key);

  @override
  _ProfilePageBottomState createState() => _ProfilePageBottomState();
}

class _ProfilePageBottomState extends State<ProfilePageBottom> {
  String? _profileImageURL;
  String name = "";
  String email = "";
  String phone = "";

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
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (builder) => HomePage(
                    currentIndex: 0,
                  ),
                ),
              );
            },
            child:
            Icon(Icons.arrow_back_outlined, color: AppColors.primaryColor)),
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.kPrimary),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          InkWell(
            child: myPopMenu(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileDetail(),
            const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            _buildUpdateProfile(),
            // _updatePassword(),
            _buildPaymentContainer(),
            _buildBookingContainer()
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentContainer() {
    return _buildContainer(
        url: AppImages.payment,
        buttonText: "Add/Edit",
        child: _buildGreyText(text: '1234 **** **** ****'),
        blackText: 'Primary Payment Method',
        onTap: () {});
  }

  Widget _buildBookingContainer() {
    return _buildContainer(
        url: AppImages.booking,
        buttonText: "View",
        blackText: 'Bookings & \nConfirmations',
        onTap: () {
          // AppNavigation().push(context, HomePage(currentIndex: 2,));
          push(HomePage(
            currentIndex: 2,
          ));
        });
  }

  Widget _buildUpdateProfile() {
    return _buildContainer(
      url: AppImages.editProfile,
      buttonText: "Edit",
      blackText: 'Update Profile',
      onTap: () {
        // AppNavigation().push(context, const UpdateProfilePage());
        push(UpdateProfilePage()).then((value) {
          _getUserData();
          setState(() {});
        });
      },
    );
  }

  // Widget _updatePassword() {
  //   return _buildContainer(
  //     url: AppImages.editProfile,
  //     buttonText: "Edit",
  //     blackText: 'Update Password',
  //     onTap: () {
  //       // AppNavigation().push(context, const UpdateProfilePage());
  //       push(UpdatePasswordScreen()).then((value) {
  //         print("okokoo");
  //         _getUserData();
  //       });
  //     },
  //   );
  // }

  Widget _buildWhiteText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildGreyText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildContainer(
      {required String url,
      required String buttonText,
      Widget? child,
      required String blackText,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.kPrimary, width: 1),
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 30,
          child: Image.asset(
            url,
            fit: BoxFit.fill,
          ),
        ),
        title: _buildWhiteText(text: blackText),
        subtitle: child,
        trailing: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.kPrimary),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildProfileDetail() {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 40),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (_profileImageURL != null &&
                          (_profileImageURL ?? '').isNotEmpty)
                      ? NetworkImage(
                          "http://dubai.applypressure.co.uk/profile_pics/$_profileImageURL")
                      : Image.asset('assets/images/user.png').image,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildGreyText(text: '$email'),
                _buildGreyText(text: '$phone'),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ));
  }

  Widget myPopMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      color: Colors.white.withOpacity(0.9),
      onSelected: (value) async {
        if (value == 1) {
          _logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "Logout",
            style: TextStyle(color: AppColors.kPrimary),
          ),
        ),
      ],
    );
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        String fName = prefs.getString(PrefKey.FIRST_NAME)!;
        String lName = prefs.getString(PrefKey.LAST_NAME)!;
        name = "$fName $lName ";
        email = prefs.getString(PrefKey.EMAIL)!;
        phone = prefs.getString(PrefKey.MOBILE)!;
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
        setState(() {});
        print(_profileImageURL);
      });
    });
  }

  _logout() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: Text("Please wait..."));
    var responseData;

    try {
      var response = await _dio.post(
        path: AppUrl.logoutUrl,
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        await Prefs.getPrefs().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GetStarted()),
            (Route<dynamic> route) => false);
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
