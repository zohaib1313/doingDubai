import 'package:dubai_screens/model/custom_inquiry_model.dart';
import 'package:dubai_screens/repo/stripe_repo.dart';
import 'package:dubai_screens/src/ui/pages/home_page.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../utils/colors.dart';

class PaymentPage extends StatefulWidget {
  CustomInquiryModel? customModel;
  int adults;
  int kids;
  String date;
  String time;
  String bookingId;

  PaymentPage(
      {Key? key,
      required this.customModel,
      required this.adults,
      required this.kids,
      required this.date,
      required this.time,
      required this.bookingId})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedIndex = -1;
  List<Map<String, String>> cards = [
    {
      'cardName': 'PayPal',
      'cardNumber': 'johndemarcs@hotmail.co.uk',
      'cardImage': AppImages.bottomPayPalCard
    },
    {
      'cardName': 'Visa Card',
      'cardNumber': '234 **** **** ****',
      'cardImage': AppImages.bottomVisaCard
    },
    {
      'cardName': 'Apple Pay',
      'cardNumber': '234 **** **** ****',
      'cardImage': 'assets/images/applepay.png'
    },
  ];

  late String secretKey, pubKey;
  bool isInProgress = false;
  late Map<String, dynamic> paymentIntentData;

  @override
  void initState() {
    _getStripeKey();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getStripeKey() async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    await StripeRepo.stripeInfo().then((response) {
      pubKey = response['data']['publish'];
    });

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.kPrimary),
          title: const Text(
            'Payment',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(AppImages.building),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customModel?.name ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          widget.customModel?.description ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      Text(
                        '${widget.date} ${widget.time}',
                        style: TextStyle(color: AppColors.kPrimary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "${widget.customModel?.price.toString()} " +
                        (widget.customModel?.inquiry_price ?? 0).toString(),
                    style: TextStyle(
                        color: AppColors.kPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CheckOut'),
                  TextButton.icon(
                    onPressed: () {},
                    label: Icon(
                      Icons.add,
                      color: AppColors.kPrimary,
                    ),
                    icon: Text(
                      'Add New Card',
                      style: TextStyle(color: AppColors.kPrimary),
                    ),
                  )
                ],
              ),
              // Column(
              //   children: List<Widget>.generate(cards.length, (index) {
              //     return Container(
              //         margin: const EdgeInsets.symmetric(vertical: 10),
              //         padding: const EdgeInsets.all(2),
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             border: Border.all(color: AppColors.kPrimary),
              //             borderRadius: BorderRadius.circular(10)),
              //         child: ListTile(
              //           leading: Image.asset(
              //             cards[index]['cardImage'] ?? '',
              //           ),
              //           onTap: () {
              //             setState(() {
              //               _selectedIndex = index;
              //             });
              //           },
              //           subtitle: Text(cards[index]['cardNumber'] ?? '',
              //               style: const TextStyle(
              //                   fontSize: 12, color: Colors.grey)),
              //           title: Text(
              //             cards[index]['cardName'] ?? '',
              //             style: const TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black),
              //           ),
              //           trailing: _selectedIndex == index
              //               ? Icon(
              //                   Icons.check_circle,
              //                   color: AppColors.kPrimary,
              //                 )
              //               : const Icon(Icons.circle_outlined),
              //         ));
              //   }),
              // ),
              const SizedBox(
                height: 50,
              ),
              AuthButton(
                  text: "Secure Reservation",
                  onTap: () {
                    _initiateThePayment(int.parse(widget.bookingId));
                  })
            ],
          ),
        ));
  }


  _initiateThePayment(int? bookingId) async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    await StripeRepo().payForMyBooking(bookingId!).then((response) {
      //print(response);
      paymentIntentData = response.data;
    });
print(paymentIntentData);
    Stripe.publishableKey = pubKey;
    Stripe.merchantIdentifier = 'DoingDubai';
    await Stripe.instance.applySettings();

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['client_secret'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'UK',
            merchantDisplayName: 'DoingDubai'
        ));

    setState(() {});

    displaySheet();

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }

  }

  Future<void> displaySheet() async {
    //try {
    await Stripe.instance.presentPaymentSheet();
    setState(() {
      _updatePayment(paymentIntentData['id']);
      paymentIntentData.clear();

      AppNavigation().push(context, HomePage(currentIndex: 2));
    });
    // } catch (e){
    //   errorDialog(
    //       context, 'Error.', 'Failed to make the payment.',
    //       closeOnBackPress: true, neutralButtonText: "OK");
    // }
  }

  _updatePayment(String paymentID) async {
    if (mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    await StripeRepo.confirmPayment(widget.customModel?.id,paymentID).then((response) {
      successDialog(
          context, 'Payment Received', 'Booking payment received.',
          closeOnBackPress: true, neutralButtonText: "OK");
    });

    setState(() {});

    if (mounted) {
      setState(() {
        isInProgress = false;
      });
    }

  }

}
