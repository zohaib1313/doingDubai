import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../model/hotels_model.dart';
import '../../utils/colors.dart';
import '../../utils/nav.dart';
import '../pages/inqury/make_inqury.dart';

class RecommendedBooking extends StatefulWidget {
  const RecommendedBooking({Key? key}) : super(key: key);

  @override
  _RecommendedBookingState createState() => _RecommendedBookingState();
}

class _RecommendedBookingState extends State<RecommendedBooking> {
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
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        // backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Recommended Bookings',
                  style: TextStyle(color: AppColors.kPrimary, fontSize: 20),
                ),
              )),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: __hotelsList.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 33,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.5),
              itemBuilder: (c, i) {
                return GestureDetector(
                    onTap: () {
                      AppNavigation().push(
                        context,
                        MakeInqury(
                          hotelModel: __hotelsList[i],
                        ),
                      );
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
                                AppUrl.hotelsPicBaseUrl +
                                    (__hotelsList[i].imageUrl ?? ''),
                                height: 130,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  __hotelsList[i].hotel ?? '',
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
                                  __hotelsList[i].description ?? '',
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
                                      __hotelsList[i].price ?? '',
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
                                        __hotelsList[i].rating ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style:
                                            const TextStyle(color: Colors.grey),
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
  List<HotelsModel> __hotelsList = [];

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
    __hotelsList.clear();
    _isLoading = true;
    try {
      var response = await _dio.get(
        path: AppUrl.recommended_bookings,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['recommendations'];

        /*await Future.forEach(products, (item) async {
          var booking = item as Map<String, dynamic>;
          var customModel = await _getHotelOfBooking(booking['entity_id']);
          if (customModel != null) {
            __hotelsList.add(customModel);
          }
        });*/

        products.forEach((item) async {
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
        });

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

  Future<HotelsModel?> _getHotelOfBooking(String id) async {
    try {
      var response = await _dio.get(
        path: AppUrl.getOneHotel + id,
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
    return null;
  }
}
