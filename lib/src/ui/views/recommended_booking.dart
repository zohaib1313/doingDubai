import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/brunches_model.dart';
import 'package:dubai_screens/model/clubs_main_model.dart';
import 'package:dubai_screens/model/custom_inquiry_model.dart';
import 'package:dubai_screens/model/custom_recomdended_model.dart';
import 'package:dubai_screens/model/events_main_model.dart';
import 'package:dubai_screens/model/land_mark_main_model.dart';
import 'package:dubai_screens/model/night_life_model.dart';
import 'package:dubai_screens/model/restaurant_main_model.dart';
import 'package:dubai_screens/network_calls.dart';
import 'package:dubai_screens/src/ui/pages/inqury/make_inqury.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../model/hotels_model.dart';
import '../../../model/transporter_main_model.dart';
import '../../utils/colors.dart';

class RecommendedBooking extends StatefulWidget {
  const RecommendedBooking({Key? key}) : super(key: key);

  @override
  _RecommendedBookingState createState() => _RecommendedBookingState();
}

class _RecommendedBookingState extends State<RecommendedBooking> {
  final List<CustomRecomededModel> _customList = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Recommended Bookings',
          style: TextStyle(color: AppColors.kPrimary, fontSize: 20),
        ),
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        // backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _customList.isEmpty
              ? const Center(
                  child: Text("No Record Found"),
                )
              : GridView.builder(
                  itemCount: _customList.length,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 33,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.5),
                  itemBuilder: (c, i) {
                    return GestureDetector(
                        onTap: () async {
                          CustomRecomededModel customRecomededModel =
                              _customList[i];

                          gotoScreen(customRecomededModel);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    topLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    (_customList[i].imageUrl ?? ''),
                                    height: 130,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      _customList[i].name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, left: 12, right: 12),
                                    child: Text(
                                      _customList[i].description ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12, right: 12, left: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          /* _customList[i].price ??*/
                                          '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.kPrimary),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _customList[i].rating ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: AppColors.kPrimary,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13.12, horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        color: AppColors.kPrimary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Make Inquiry',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                ),
    );
  }

  bool _isLoading = true;
  late AppDio _dio;

  @override
  void initState() {
    _dio = AppDio(context);
    _init();
    super.initState();
  }

  void _init() async {
    await _getMyBookings();
  }

  _getMyBookings() async {
    _customList.clear();
    _isLoading = true;
    try {
      var response = await _dio.get(
        path: AppUrl.personality_bookings,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        Map<String, List<dynamic>> map = {};

        var reco_hotel = responseData['data']['reco_hotel'];
        if (reco_hotel != null) {
          map['hotel'] = reco_hotel;
        }

        var reco_club = responseData['data']['reco_club'];
        if (reco_club != null) {
          map['club'] = reco_club;
        }

        var reco_event = responseData['data']['reco_event'];
        if (reco_event != null) {
          map['event'] = reco_event;
        }

        var reco_landmark = responseData['data']['reco_landmark'];
        if (reco_landmark != null) {
          map['landmark'] = reco_landmark;
        }

        var reco_restaurant = responseData['data']['reco_restaurant'];
        if (reco_restaurant != null) {
          map['restaurant'] = reco_restaurant;
        }
        var reco_transporter = responseData['data']['reco_transporter'];
        if (reco_transporter != null) {
          map['transporter'] = reco_transporter;
        }
        for (var element in map.entries) {
          for (var element2 in element.value) {
            CustomRecomededModel customRecomededModel =
                CustomRecomededModel.fromJson(element2);
            customRecomededModel.key = element.key;
            customRecomededModel.imageUrl =
                'http://dubai.applypressure.co.uk/images/${customRecomededModel.key}pics/${element2['image_url']}';
            customRecomededModel.name = element2[customRecomededModel.key];
            _customList.add(customRecomededModel);
          }
        }

        /* products.forEach((item) async {
          var booking = item as Map<String, dynamic>;
          if (mounted) {
            var customModel = await _getHotelOfBooking(booking['entity_id']);
            if (customModel != null) {
              __hotelsList.add(customModel);
              _isLoading = false;
              if (mounted) {
                setState(() {});
              }
            }
          } else {
            return;
          }
        });*/

        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      } else {
        if (responseData != null) {
          if (mounted) {
            errorDialog(context, 'Error', responseData['message'],
                closeOnBackPress: true, neutralButtonText: "OK");
            return;
          }
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

  void gotoScreen(CustomRecomededModel customRecomededModel) async {
    switch (customRecomededModel.key) {
      case 'hotel':
        _isLoading = true;
        HotelsModel? hotelsModel = await NetworkCalls.getOneHotel(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                menuOptions: hotelsModel?.menuOptions,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiry_price,
              ),
            ));
        break;

      case 'club':
        _isLoading = true;
        ClubsMainModel? hotelsModel = await NetworkCalls.getOneClub(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;
      case 'restaurant':
        _isLoading = true;
        RestaurantMainModel? hotelsModel = await NetworkCalls.getOneRestaurant(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                menuOptions: hotelsModel?.menuOptions,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;
      case 'event':
        _isLoading = true;
        EventsMainModel? hotelsModel = await NetworkCalls.getOneEvent(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;
      case 'landmark':
        _isLoading = true;
        LandmarkMainModel? hotelsModel = await NetworkCalls.getOneLandmark(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;

      case 'nightlife':
        _isLoading = true;
        NightLifeModel? hotelsModel = await NetworkCalls.getOneNightLife(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: hotelsModel?.adults,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;

      case 'brunch':
        _isLoading = true;
        BrunchesModel? hotelsModel = await NetworkCalls.getOneBrunch(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: hotelsModel?.amenities,
                adults: false,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode: hotelsModel?.dressCode,
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.openingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;
      case 'transporter':
        _isLoading = true;
        TransporterMainModel? hotelsModel = await NetworkCalls.getOneTransporter(
            customRecomededModel.id.toString(), context);
        _isLoading = false;
        setState(() {});
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: hotelsModel?.id,
                latitude: hotelsModel?.latitude,
                longitude: hotelsModel?.longitude,
                imageUrl: customRecomededModel.imageUrl,
                key: customRecomededModel.key,
                name: customRecomededModel.name,
                amenities: '',
                adults: false,
                checkins: hotelsModel?.checkins,
                address: customRecomededModel.address,
                description: hotelsModel?.description,
                dressCode:'',
                rating: hotelsModel?.rating,
                openingHours: hotelsModel?.operatingHours,
                price: hotelsModel?.price,
                inquiry_price: hotelsModel?.inquiryPrice,
              ),
            ));
        break;
    }
  }
}
