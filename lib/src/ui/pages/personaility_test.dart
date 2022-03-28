import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/dio/functions.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/src/ui/pages/home_page.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/src/ui/widgets/drop_down.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

class PersonalityTestPage extends StatefulWidget {
  const PersonalityTestPage({Key? key}) : super(key: key);

  @override
  _PersonalityTestPageState createState() => _PersonalityTestPageState();
}

String? question1;
String? question2;
String? question3;
String? question4;
String? question5;

class _PersonalityTestPageState extends State<PersonalityTestPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        title: Text(
          'Personality Test',
          style: TextStyle(color: AppColors.kPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 80, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropDownLabel(label: 'When It comes to travel you’d rather:'),
            _buildDropDown(1, [
              "Explore your own backyard.",
              "Travel the world, you’ve got a passport!"
            ]),
            _buildDropDownLabel(
                label:
                    'The location for dinner is yours, what’s the perfect setting?'),
            _buildDropDown(2, [
              "Grand and Glorious",
              "Fresh Air Outdoorsy Scene",
              "Italian Neighborhood, Pasta & Pesto",
              "Fine Dining & Atmosphere",
              "Sunset Dinner In A Safari",
            ]),
            _buildDropDownLabel(label: 'What’s your most ideal happy place?'),
            _buildDropDown(3, [
              "Snowy Peaks & Arresting Views",
              "Jaw Dropping Awe Inspiring Hills & Scenery",
              "Sunbathing On A Yacht Deck",
              "Visit to the Local Market",
              "Searching for Wildlife & Wonder",
              "Somewhere on a massage table",
            ]),
            _buildDropDownLabel(
                label: 'You’re at the airport, who’s with you?'),
            _buildDropDown(4, [
              "No One, I Travel Solo",
              "Us and the Kids",
              " The Entire Family from Granny to Grandchildren",
              " A Pack of Friends",
              "	Just The Two Of Us"
            ]),
            _buildDropDownLabel(
                label: 'You’re on vacation, what’s on your to-do list?'),
            _buildDropDown(5, [
              "Hit the trails",
              "Breathing Salt Air and Having Sand In My Toes",
              "Capture My Instagram Moments",
              "Explore The History",
              "Explore The Local On a Bike"
            ]),
            AuthButton(
                text: 'Submit',
                onTap: () {
                  if (((question1 ?? "").isEmpty) ||
                      ((question2 ?? "").isEmpty) ||
                      ((question3 ?? "").isEmpty) ||
                      ((question4 ?? "").isEmpty) ||
                      ((question5 ?? "").isEmpty)) {
                    errorDialog(context, "Error", 'Select All Fields',
                        closeOnBackPress: true, neutralButtonText: "OK");
                  } else {
                    _submitPersonality();
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDropDown(int questionNumber, List<String> list) {
    return DropDownWidget(
      onChanged: (value) {
        switch (questionNumber) {
          case 1:
            question1 = value;
            break;
          case 2:
            question2 = value;
            break;
          case 3:
            question3 = value;
            break;
          case 4:
            question4 = value;
            break;
          case 5:
            question5 = value;
            break;
        }
      },
      list: list,
      select: getValue(questionNumber),
    );
  }

  Widget _buildDropDownLabel({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
    );
  }

  _submitPersonality() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: const Text("Please wait..."));
    var responseData;

    try {
      var response = await _dio.post(
        path: AppUrl.submitPersonality,
        data: {
          "question1": question1 ?? '',
          "question2": question2 ?? '',
          "question3": question3 ?? '',
          "question4": question4 ?? '',
          "question5": question5 ?? '',
        },
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
        push(HomePage(
          currentIndex: 0,
        ));

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

  getValue(int questionNumber) {
    switch (questionNumber) {
      case 1:
        return question1;
      case 2:
        return question2;
      case 3:
        return question3;
      case 4:
        return question4;
      case 5:
        return question5;
    }
  }
}
