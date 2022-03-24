import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/ui/pages/home_page.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../../config/app_urls.dart';
import '../../../../config/dio/app_dio.dart';
import '../../../../config/dio/functions.dart';
import '../../../../config/keys/response_code.dart';
import '../../../utils/colors.dart';
import '../../../utils/nav.dart';
import '../../widgets/buttons.dart';
import '../payment_page.dart';

class ConfirmationInquiry extends StatefulWidget {
  HotelsModel? hotel;
  int adults;
  int kids;
  String date;
  String time;

  String bookingId;

  ConfirmationInquiry({
    Key? key,
    required this.bookingId,
    required this.hotel,
    required this.date,
    required this.time,
    this.adults = 0,
    this.kids = 0,
  }) : super(key: key);

  @override
  _ConfirmationInquiryState createState() => _ConfirmationInquiryState();
}

class _ConfirmationInquiryState extends State<ConfirmationInquiry> {
  bool isTrue = false;
  late AppDio _dio;

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
          centerTitle: true,
          title: Text(
            widget.hotel?.hotel ?? '',
            style: TextStyle(color: AppColors.kPrimary),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.kPrimary),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Please confirm or decline the secured booking information for ${widget.hotel?.hotel ?? ''} for ${widget.adults.toString()} Adults and ${widget.kids.toString()} Children On ${widget.date} at  ${widget.time}.',
                style: TextStyle(
                    height: 1.5, color: AppColors.kPrimary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTrue ? Colors.green : AppColors.kPrimary),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    onTap: () {
                      isTrue = !isTrue;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                      onTap: () {
                        _changeBookingStatus(
                            0); //1: Secured; 0: Declined; 2: Cancelled
                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.kPrimary),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 50,
                        ),
                      ))
                ],
              ),
              const Spacer(),
              isTrue
                  ? AuthButton(
                      text: 'Make Downpayment',
                      onTap: () {
                        _changeBookingStatus(
                            1); //1: Secured; 0: Declined; 2: Cancelled
                      })
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Future<void> _changeBookingStatus(int status) async {
//

    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: const Text("Please wait..."));
    // ignore: prefer_typing_uninitialized_variables
    var responseData;

    try {
      var response = await _dio.post(
        path: AppUrl.actionBooking,
        data: {"booking_id": widget.bookingId, "status": status},
      );
      if (status == 0) {
        AppNavigation().pushReplacement(context, HomePage(currentIndex: 2));
      } else if (status == 1) {
        AppNavigation().pushReplacement(
            context,
            PaymentPage(
                bookingId: widget.bookingId,
                time: widget.time,
                adults: widget.adults,
                hotel: widget.hotel,
                date: widget.date,
                kids: widget.kids));
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;

      if (responseStatusCode == StatusCode.OK) {
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
