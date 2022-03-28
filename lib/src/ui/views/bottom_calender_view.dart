import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/model/my_bookings_model.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:req_fun/req_fun.dart';

import '../../../config/app_urls.dart';
import '../../../config/keys/response_code.dart';
import '../pages/inqury/make_inqury.dart';

class BookingsAndConfirmationsBottom extends StatefulWidget {
  const BookingsAndConfirmationsBottom({Key? key}) : super(key: key);

  @override
  _BookingsAndConfirmationsBottomState createState() =>
      _BookingsAndConfirmationsBottomState();
}

class _BookingsAndConfirmationsBottomState
    extends State<BookingsAndConfirmationsBottom> {
  DateTime? selectedFromDates;
  String? _profileImageURL;

  bool _isLoading = true;
  List<MyBookingsModel> _allBookings = [];

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

  DateTime? selectedToDates;

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedToDates = picked;
      });
    }
  }

  late AppDio _dio;

  @override
  void initState() {
    _dio = AppDio(context);
    _init();
    super.initState();
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
        title: Text(
          'Bookings & Confirmations',
          style: TextStyle(color: AppColors.kPrimary),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const ProfilePageBottom()));
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: (_profileImageURL != null &&
                      (_profileImageURL ?? '').isNotEmpty)
                  ? Image.network(
                      "http://dubai.applypressure.co.uk/profile_pics/$_profileImageURL")
                  : const SizedBox(),
            ),
          ),
        ],
        /*   bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildFromDateTimeRow(selectedFromDates, selectedToDates)),*/
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _allBookings.isEmpty
              ? const Center(
                  child: Text('No Booking Found'),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                  itemBuilder: (c, i) {
                    return getStackItem(i: i);
                  },
                  separatorBuilder: (c, i) {
                    return const SizedBox(
                      height: 25,
                    );
                  },
                  itemCount: _allBookings.length),
    );
  }

  Widget _buildFromDateTimeRow(
    DateTime? selectedFromDate,
    DateTime? selectedToDate,
  ) {
    String selectedFromDate =
        DateFormat('dd  MMM ').format(selectedFromDates ?? DateTime.now());
    String selectedTODate =
        DateFormat('dd  MMM ').format(selectedToDates ?? DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today,
          color: AppColors.kPrimary,
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Text(selectedFromDate.toString()),
          onTap: () {
            _selectFromDate(context);
          },
        ),
        Text('    -     '),
        GestureDetector(
          child: Text(selectedTODate.toString()),
          onTap: () {
            _selectToDate(context);
          },
        ),
      ],
    );
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
      });
    });
  }

  Widget getStackItem({required int i}) {
    return InkWell(
      onTap: () async {
        HotelsModel? hotelsModel = await _getHotelOfBooking(_allBookings[i]);
        if (hotelsModel != null) {
          await AppNavigation().push(
              context,
              MakeInqury(
                hotelModel: hotelsModel,
                myBookingsModel: _allBookings[i],
              ));

          _init();
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.black,
                    elevation: 1,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      margin:
                          const EdgeInsets.only(left: 35, top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Text(
                            _allBookings[i].entityType ?? '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.kPrimary,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '${_allBookings[i].adults?.toString() ?? ''} Adults')
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.kPrimary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '${_allBookings[i].bookDate?.toString() ?? ''}- ${_allBookings[i].bookTime?.toString() ?? ''}')
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 120,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        (_allBookings[i].confirmed ?? false)
                            ? 'Confirmed'
                            : 'Pending',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: (_allBookings[i].confirmed ?? false)
                        ? Colors.green
                        : AppColors.kPrimary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    ) /*Image.network(
                      AppUrl.hotelsPicBaseUrl +
                          (_customModelBookingHotel[i].hotelsModel.imageUrl ??
                              ''),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    )*/
                    ,
                  )))
        ],
      ),
    );
  }

  _getMyBookings() async {
    _allBookings.clear();
    _isLoading = true;
    try {
      var response = await _dio.get(
        path: AppUrl.getMyBookings,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['bookings'];

        _isLoading = false;
        products.forEach((item) async {
          var booking = MyBookingsModel.fromJson(item as Map<String, dynamic>);
          if (mounted) {
            _allBookings.add(booking);
            setState(() {});
            /*var customModel = await _getHotelOfBooking(booking);
            if (customModel != null) {
              _customModelBookingHotel.add(customModel);
              _isLoading = false;
              if (mounted) {
                setState(() {});
              }
            }*/
          } else {
            return;
          }
        });
      } else {
        if (responseData != null && mounted) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
          return;
        } else {
          if (mounted) {
            errorDialog(
                context, "Error", "Something went wrong please try again later",
                closeOnBackPress: true, neutralButtonText: "OK");
          }
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
      if (mounted) {
        errorDialog(
            context, "Error", "Something went wrong please try again later",
            closeOnBackPress: true, neutralButtonText: "OK");
      }
    }
  }

  void _init() async {
    await _getMyBookings();
    _getUserData();
  }

  Future<HotelsModel?> _getHotelOfBooking(MyBookingsModel booking) async {
    try {
      var response = await _dio.get(
        path: AppUrl.getOneHotel + booking.entityTypeId.toString(),
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['hotel'];
        HotelsModel hotelsModel = HotelsModel.fromJson(products);

        return Future.value(hotelsModel);
      } else {
        if (responseData != null && mounted) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else if (mounted) {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
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
      if (mounted) {
        errorDialog(
            context, "Error", "Something went wrong please try again later",
            closeOnBackPress: true, neutralButtonText: "OK");
      }
    }
    return null;
  }
}
