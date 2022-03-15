import 'package:doingdubai/src/ui/pages/inqury/confirm_inqury.dart';
import 'package:doingdubai/src/ui/widgets/buttons.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/hotels_model.dart';

class SubmitInqury extends StatefulWidget {
  HotelsModel? hotelModel;
  SubmitInqury({Key? key, required this.hotelModel}) : super(key: key);

  @override
  _SubmitInquryState createState() => _SubmitInquryState();
}

class _SubmitInquryState extends State<SubmitInqury> {
  List<String> times = [
    '06:00 pm',
    '07:00 pm',
    '08:00 pm',
    '09:00 pm',
    '10:00 pm',
    '11:00 pm',
    '12:00 am',
    '01:00 am',
  ];
  DateTime? selectedFromDates;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedFromDates = picked;
      });
    }
  }

  int _selectedIndex = -1;

  int _adults = 0;
  int _kids = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.hotelModel?.hotel ?? '',
          style: TextStyle(color: AppColors.kPrimary),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadText(text: 'Select Date'),
            _buildFromDateTimeRow(selectedFromDates),
            Divider(
              height: 50,
              color: AppColors.whiteColor,
            ),
            _buildHeadText(text: 'Select Guest'),
            _buildAdultAndKids(),
            Divider(
              height: 50,
              color: AppColors.whiteColor,
            ),
            _buildHeadText(text: 'Select Check-in Time'),
            _buildTiming(),
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: _buildHeadText(text: 'General Notes (Optional)'),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.kPrimary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.kPrimary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Text Here'),
                )),
            AuthButton(
                text: 'Submit Inquiry',
                textColor: AppColors.blackColor,
                onTap: () {
                  AppNavigation().push(
                      context, ConfirmationInquiry(hotel: widget.hotelModel));
                }),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
      ),
    );
  }

  Widget _buildTiming() {
    return Wrap(
      spacing: 10,
      runSpacing: 20,
      children: times
          .map((i) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = times.indexOf(i);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _selectedIndex == times.indexOf(i)
                        ? AppColors.kPrimary
                        : Colors.transparent,
                    border: Border.all(color: AppColors.kPrimary)),
                child: Text(
                  times.elementAt(times.indexOf(i)),
                  style: const TextStyle(fontSize: 15),
                ),
              )))
          .toList(),
    );
  }

  Widget _buildHeadText({required String text}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ));
  }

  Widget _buildFromDateTimeRow(
    DateTime? selectedDate,
  ) {
    String selectedDate =
        DateFormat('dd  MMMM yyyy').format(selectedFromDates ?? DateTime.now());

    return Row(
      children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.kPrimary)),
          child: Text(
            selectedDate.toString(),
          ),
        )),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            _selectFromDate(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.kPrimary)),
            child: Icon(
              Icons.calendar_today,
              size: 22,
              color: AppColors.kPrimary,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAdultAndKids() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Adults',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildValueContainer(
                    decrementTap: () {
                      _adults--;
                      setState(() {});
                    },
                    incrementTap: () {
                      _adults++;
                      setState(() {});
                    },
                    val: _adults.toStringAsFixed(0)),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Kids',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildValueContainer(
                    decrementTap: () {
                      _kids--;
                      setState(() {});
                    },
                    incrementTap: () {
                      _kids++;
                      setState(() {});
                    },
                    val: _kids.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildValueContainer(
      {required VoidCallback decrementTap,
      required VoidCallback incrementTap,
      required String val}) {
    return Row(
      children: [
        GestureDetector(
          onTap: incrementTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kPrimary)),
            child: const Icon(
              Icons.add,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          val,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        GestureDetector(
          onTap: decrementTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kPrimary)),
            child: const Icon(Icons.remove, size: 18),
          ),
        ),
      ],
    );
  }
}
