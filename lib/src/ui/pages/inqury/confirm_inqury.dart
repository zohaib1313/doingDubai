import 'package:doingdubai/model/hotels_model.dart';
import 'package:doingdubai/src/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/nav.dart';
import '../../widgets/buttons.dart';
import '../payment_page.dart';

class ConfirmationInquiry extends StatefulWidget {
  HotelsModel? hotel;
  ConfirmationInquiry({Key? key, required this.hotel}) : super(key: key);

  @override
  _ConfirmationInquiryState createState() => _ConfirmationInquiryState();
}

class _ConfirmationInquiryState extends State<ConfirmationInquiry> {
  bool isTrue = false;

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
                'Please confirm or decline the secured booking information for ${widget.hotel?.hotel ?? ''} for 2 Adults and 2 Children On February 4th 2022 at 7PM.',
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
                        AppNavigation()
                            .push(context, HomePage(currentIndex: 2));
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
                        AppNavigation().push(context, const PaymentPage());
                      })
                  : const SizedBox(),
            ],
          ),
        ));
  }
}
