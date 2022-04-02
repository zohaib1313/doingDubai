import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/model/custom_booking_model.dart';
import 'package:dubai_screens/model/custom_inquiry_model.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:req_fun/req_fun.dart';

import '../../../../config/app_urls.dart';
import '../../../../config/dio/functions.dart';
import '../../../../config/keys/pref_keys.dart';
import '../../../../config/keys/response_code.dart';
import '../../../utils/nav.dart';
import 'confirm_inqury.dart';

class SubmitInqury extends StatefulWidget {
  CustomInquiryModel? customInquiryModel;
  CustomBookingModel? myBookingsModel;

  SubmitInqury(
      {Key? key, required this.customInquiryModel, this.myBookingsModel})
      : super(key: key);

  @override
  _SubmitInquryState createState() => _SubmitInquryState();
}

class _SubmitInquryState extends State<SubmitInqury> {
  DateTime? selectedFromDates;
  int _selectedTimeIndex = -1;
  int _adults = 0;
  int _kids = 0;
  bool _loading = false;
  late AppDio _dio;
  List<String> times = [];

  final TextEditingController _notesTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesTextEditingController.clear();
    _dio = AppDio(context);
    times = widget.customInquiryModel?.checkins?.split(",").toList() ?? [];

    if (widget.myBookingsModel != null) {
      setupValuesWithBookingForUpdate(booking: widget.myBookingsModel!);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.customInquiryModel?.name ?? '',
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
            Visibility(
              visible: widget.customInquiryModel?.adults != null,
              child: _buildAdultAndKids(),
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
                  controller: _notesTextEditingController,
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
                text: widget.myBookingsModel != null
                    ? 'Update Inquiry'
                    : 'Submit Inquiry',
                textColor: AppColors.blackColor,
                onTap: () {
                  if (selectedFromDates != null && _selectedTimeIndex != -1) {
                    if (widget.customInquiryModel?.adults != null &&
                        _adults == 0) {
                      warningDialog(context, "Warnings", "Select Adults",
                          closeOnBackPress: true, neutralButtonText: "OK");
                      return;
                    }

                    if (widget.myBookingsModel != null) {
                      _updateBooking();
                    } else {
                      _makeBookings();
                    }
                  } else {
                    warningDialog(context, "Warnings", "Fill all fields",
                        closeOnBackPress: true, neutralButtonText: "OK");
                  }
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
                  _selectedTimeIndex = times.indexOf(i);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _selectedTimeIndex == times.indexOf(i)
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
    selectedFromDates ??= DateTime.now();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeadText(text: 'Select Guest'),
        Padding(
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
                          if (_adults > 0) {
                            _adults--;
                            setState(() {});
                          }
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
              Visibility(
                visible: (widget.customInquiryModel?.adults == true) ||
                    (widget.customInquiryModel?.adults == 1),
                child: Expanded(
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
                            if (_kids > 0) {
                              setState(() {
                                _kids--;
                              });
                            }
                          },
                          incrementTap: () {
                            setState(() {
                              _kids++;
                            });
                          },
                          val: _kids.toString()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 50,
          color: AppColors.whiteColor,
        ),
      ],
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

  _makeBookings() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: const Text("Please wait..."));
    // ignore: prefer_typing_uninitialized_variables
    var responseData;

    try {
      String? userId = "";
      await Prefs.getPrefs().then((prefs) {
        userId = prefs.getInt(PrefKey.ID).toString();
      });
      var response = await _dio.post(
        path: AppUrl.bookingsCreate,
        data: {
          "entity_type": "Hotel",
          "entity_type_id": (widget.customInquiryModel?.id.toString() ?? "-1"),
          "user_id": userId ?? '-1',
          "sent": "1",
          "seen": "0",
          "actioned": "0",
          "book_date": DateFormat('yyyy-MM-dd')
              .format(selectedFromDates!) /*"2022-02-21"*/,
          "book_time": times.elementAt(_selectedTimeIndex),
          "adults": _adults.toString(),
          "kids": _kids.toString(),
          "notes": _notesTextEditingController.text,
        },
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;
      print("*******\n");
      print(responseData);
      print("*******\n");

      if (responseStatusCode == StatusCode.OK) {
        AppNavigation().pushReplacement(
            context,
            ConfirmationInquiry(
                customModel: widget.customInquiryModel,
                bookingId: (responseData['data']['booking']['id']).toString(),
                time: times.elementAt(_selectedTimeIndex),
                date: DateFormat('yyyy-MM-dd').format(selectedFromDates!),
                kids: _kids,
                adults: _adults));
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

  _updateBooking() async {
    _loading = true;
    progressDialog(context,
        progressDialogType: ProgressDialogType.CIRCULAR,
        contentWidget: const Text("Please wait..."));
    // ignore: prefer_typing_uninitialized_variables
    var responseData;

    try {
      String? userId = "";
      await Prefs.getPrefs().then((prefs) {
        userId = prefs.getInt(PrefKey.ID).toString();
      });
      var response = await _dio.put(
        path: AppUrl.bookingUpdate + widget.myBookingsModel!.id.toString(),
        data: {
          "entity_type": "Hotel",
          "entity_type_id": (widget.customInquiryModel?.id.toString() ?? "-1"),
          "user_id": userId ?? '-1',
          "sent": "1",
          "seen": "0",
          "actioned": "0",
          "book_date": DateFormat('yyyy-MM-dd')
              .format(selectedFromDates!) /*"2022-02-21"*/,
          "book_time": times.elementAt(_selectedTimeIndex),
          "adults": _adults.toString(),
          "kids": _kids.toString(),
          "notes": _notesTextEditingController.text,
        },
      );

      if (_loading) {
        pop();
        _loading = false;
      }

      var responseStatusCode = response.statusCode;
      responseData = response.data;
      print("*******\n");
      print(responseData);
      print("*******\n");

      if (responseStatusCode == StatusCode.OK) {
        infoDialog(context, responseData['message'], 'Booking updated',
            closeOnBackPress: true, neutralButtonText: "OK");
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

  void setupValuesWithBookingForUpdate({required CustomBookingModel booking}) {
    selectedFromDates = DateTime.parse(booking.bookDate!);
    _kids = booking.kids ?? 0;
    _adults = booking.adults ?? 0;
    for (int i = 0; i < times.length; i++) {
      if (times[i].trim() == booking.bookTime!.trim()) {
        _selectedTimeIndex = i;
      }
    }
    // _notesTextEditingController.text = booking ?? '';
    setState(() {});
  }
}
