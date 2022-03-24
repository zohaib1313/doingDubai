import 'package:dubai_screens/src/ui/pages/home_page.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:flutter/material.dart';

import '../../../model/hotels_model.dart';
import '../../utils/colors.dart';

class PaymentPage extends StatefulWidget {
  HotelsModel? hotel;
  int adults;
  int kids;
  String date;
  String time;
  String bookingId;

  PaymentPage(
      {Key? key,
      required this.hotel,
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
                        widget.hotel?.hotel ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          widget.hotel?.description ?? '',
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
                    '\$40',
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
              Column(
                children: List<Widget>.generate(cards.length, (index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.kPrimary),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Image.asset(
                          cards[index]['cardImage'] ?? '',
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        subtitle: Text(cards[index]['cardNumber'] ?? '',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        title: Text(
                          cards[index]['cardName'] ?? '',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: _selectedIndex == index
                            ? Icon(
                                Icons.check_circle,
                                color: AppColors.kPrimary,
                              )
                            : const Icon(Icons.circle_outlined),
                      ));
                }),
              ),
              const SizedBox(
                height: 50,
              ),
              AuthButton(
                  text: "Secure Reservation",
                  onTap: () {
                    AppNavigation().push(context, HomePage(currentIndex: 2));
                  })
            ],
          ),
        ));
  }
}
