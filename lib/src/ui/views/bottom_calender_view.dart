import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/model/custom_booking_model.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:req_fun/req_fun.dart';

import '../../../config/app_urls.dart';
import '../../../config/keys/response_code.dart';
import '../../../model/clubs_main_model.dart';
import '../../../model/custom_inquiry_model.dart';
import '../../../model/events_main_model.dart';
import '../../../model/land_mark_main_model.dart';
import '../../../model/restaurant_main_model.dart';
import '../../../network_calls.dart';
import '../../utils/nav.dart';
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
  final List<CustomBookingModel> _allBookings = [];

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
        await gotoScreen(_allBookings[i]);
        _init();
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
                            _allBookings[i].name ?? ''.toUpperCase(),
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
                        ((_allBookings[i].confirmed ?? 0) == 1)
                            ? 'Confirmed'
                            : 'Pending',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ((_allBookings[i].confirmed ?? 0) == 1)
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
                    child: /* Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    ) */
                        Image.network(
                      (_allBookings[i].imageUrl ?? ''),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
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
        Map<String, List<dynamic>> map = {};
        var reco_hotel = responseData['data']['hotel_bookings'];
        if (reco_hotel != null) {
          map['hotel'] = reco_hotel;
        }
        var reco_club = responseData['data']['club_bookings'];
        if (reco_club != null) {
          map['club'] = reco_club;
        }
        var reco_event = responseData['data']['event_bookings'];
        if (reco_event != null) {
          map['event'] = reco_event;
        }
        var reco_landmark = responseData['data']['landmark_bookings'];
        if (reco_landmark != null) {
          map['landmark'] = reco_landmark;
        }
        var reco_restaurant = responseData['data']['restaurant_bookings'];
        if (reco_restaurant != null) {
          map['restaurant'] = reco_restaurant;
        }
        var reco_transporter = responseData['data']['transport_bookings'];
        if (reco_transporter != null) {
          map['transporter'] = reco_transporter;
        }

        for (var element in map.entries) {
          for (var element2 in element.value) {
            CustomBookingModel customBookingModel =
                CustomBookingModel.fromJson(element2);
            customBookingModel.key = element.key;
            customBookingModel.imageUrl =
                'http://dubai.applypressure.co.uk/images/${customBookingModel.key}pics/${element2['image_url']}';
            customBookingModel.name = element2[customBookingModel.key];
            _allBookings.add(customBookingModel);
          }
        }
        _isLoading = false;
        setState(() {});
        /*    products?.forEach((item) async {
          var booking = MyBookingsModel.fromJson(item as Map<String, dynamic>);
          if (mounted) {
            _allBookings.add(booking);
            setState(() {});
            */ /*var customModel = await _getHotelOfBooking(booking);
            if (customModel != null) {
              _customModelBookingHotel.add(customModel);
              _isLoading = false;
              if (mounted) {
                setState(() {});
              }
            }*/ /*
          } else {
            return;
          }
        });*/
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

  gotoScreen(CustomBookingModel customBookingModel) async {
    switch (customBookingModel.key) {
      case 'hotel':
        _isLoading = true;
        HotelsModel? hotelsModel = await NetworkCalls.getOneHotel(
            customBookingModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        return AppNavigation().push(
            context,
            MakeInqury(
              myBookingsModel: customBookingModel,
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                imageUrl: customBookingModel.imageUrl,
                key: customBookingModel.key,
                name: customBookingModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: hotelsModel?.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                menuOptions: hotelsModel?.menuOptions,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiry_price,
              ),
            ));

      case 'club':
        _isLoading = true;
        ClubsMainModel? hotelsModel = await NetworkCalls.getOneClub(
            customBookingModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        return await AppNavigation().push(
            context,
            MakeInqury(
              myBookingsModel: customBookingModel,
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                imageUrl: customBookingModel.imageUrl,
                key: customBookingModel.key,
                name: customBookingModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: hotelsModel?.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));

      case 'restaurant':
        _isLoading = true;
        RestaurantMainModel? hotelsModel = await NetworkCalls.getOneRestaurant(
            customBookingModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        return AppNavigation().push(
            context,
            MakeInqury(
              myBookingsModel: customBookingModel,
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                imageUrl: customBookingModel.imageUrl,
                key: customBookingModel.key,
                name: customBookingModel.name,
                amenities: hotelsModel?.amenities,
                checkins: hotelsModel?.checkins,
                address: hotelsModel?.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                menuOptions: hotelsModel?.menuOptions,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
      case 'event':
        _isLoading = true;
        EventsMainModel? hotelsModel = await NetworkCalls.getOneEvent(
            customBookingModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        return AppNavigation().push(
            context,
            MakeInqury(
              myBookingsModel: customBookingModel,
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                imageUrl: customBookingModel.imageUrl,
                key: customBookingModel.key,
                name: customBookingModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: hotelsModel?.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
      case 'landmark':
        _isLoading = true;
        LandmarkMainModel? hotelsModel = await NetworkCalls.getOneLandmark(
            customBookingModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        return AppNavigation().push(
            context,
            MakeInqury(
              myBookingsModel: customBookingModel,
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                imageUrl: customBookingModel.imageUrl,
                key: customBookingModel.key,
                name: customBookingModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: hotelsModel?.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
    }
  }
}
