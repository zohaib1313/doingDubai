import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/ui/views/all_hotels_page.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../../../model/custom_inquiry_model.dart';
import '../../utils/nav.dart';
import '../pages/inqury/make_inqury.dart';

class HotelsView extends StatefulWidget {
  HotelsView({Key? key}) : super(key: key);

  @override
  _HotelsViewState createState() => _HotelsViewState();
}

class _HotelsViewState extends State<HotelsView> {
  late AppDio _dio;

  TextEditingController searchController = TextEditingController();
  List<HotelsModel> _luxuryAllHotels = [];
  List<HotelsModel> _popularAllHotels = [];
  bool _loadingLuxuryHotels = true;
  bool _loadingPopularHotels = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _init() async {
    await _getAllLuxuryHotels();
    await _getAllPopularHotel();
  }

  @override
  void initState() {
    super.initState();
    _dio = AppDio(context);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Expanded(
                  child: Text(
                    'Luxury Hotels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    push(const AllHotelsPage());
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.kPrimary,
                    ),
                  )),
            ],
          ),
        ),
        _loadingLuxuryHotels == true
            ? SizedBox(
                height: 325.0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.kPrimary,
                )),
              )
            : SizedBox(
                height: 325.0,
                child: _luxuryAllHotels.isNotEmpty
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        itemCount: _luxuryAllHotels.length,
                        itemBuilder: (c, i) {
                          var item = _luxuryAllHotels[i];
                          return GestureDetector(
                              onTap: () async {
                                _loadingLuxuryHotels = true;

                                HotelsModel? hotelsModel = _luxuryAllHotels[i];
                                _loadingLuxuryHotels = false;
                                setState(() {});
                                await AppNavigation().push(
                                    context,
                                    MakeInqury(
                                      customModel: CustomInquiryModel(
                                        id: hotelsModel.id,
                                        imageUrl: AppUrl.hotelsPicBaseUrl +
                                            (hotelsModel.imageUrl ?? ''),
                                        key: 'hotel',
                                        name: hotelsModel.hotel,
                                        latitude: hotelsModel.latitude,
                                        longitude: hotelsModel.longitude,
                                        amenities: hotelsModel.amenities,
                                        adults: hotelsModel.adults,
                                        checkins: hotelsModel.checkins,
                                        address: hotelsModel.address,
                                        description: hotelsModel.description,
                                        dressCode: hotelsModel.dressCode,
                                        rating: hotelsModel.rating,
                                        menuOptions: hotelsModel.menuOptions,
                                        openingHours: hotelsModel.openingHours,
                                        price: hotelsModel.price,
                                        inquiry_price:
                                            hotelsModel.inquiry_price,
                                      ),
                                    ));
                              },
                              child: Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  elevation: .8,
                                  child: Container(
                                    width: 210,
                                    decoration: BoxDecoration(
                                        color: AppColors.blackColor,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xffc4c4c4),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${AppUrl.hotelsPicBaseUrl}${item.imageUrl}'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(12),
                                                      topLeft:
                                                          Radius.circular(12))),
                                          height: 180,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Align(
                                              child: GestureDetector(
                                                child: Icon(
                                                  _luxuryAllHotels[i]
                                                          .isFavourite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: AppColors.kPrimary,
                                                ),
                                                onTap: () {
                                                  _luxuryAllHotels[i]
                                                          .isFavourite =
                                                      !_luxuryAllHotels[i]
                                                          .isFavourite;
                                                  setState(() {});
                                                  _markFavourite(
                                                      _luxuryAllHotels[i]);
                                                },
                                              ),
                                              alignment: Alignment.topRight,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "${item.hotel}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: AppColors.whiteColor),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 5,
                                              top: 8,
                                              bottom: 8),
                                          child: Text(
                                            item.address ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      (item.rating ?? '0')
                                                          .toInt();
                                                  i++)
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: Icon(
                                                      Icons.star,
                                                      color: AppColors.kPrimary,
                                                      size: 20,
                                                    )),
                                            ],
                                          ),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                  )));
                        },
                        separatorBuilder: (c, i) {
                          return const SizedBox(
                            width: 20,
                          );
                        },
                      )
                    : const Center(
                        child: Text('No Result Found'),
                      ),
              ),
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 20, bottom: 15),
          child: Text(
            'Popular Hotels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        for (int i = 0; i < _popularAllHotels.length; i++)
          _buildPopularHotelList(i)
      ],
    );
  }

  Widget _buildPopularHotelList(int i) {
    return _loadingPopularHotels == true
        ? SizedBox(
            height: 325.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CircularProgressIndicator(
              color: AppColors.kPrimary,
            )),
          )
        : _popularAllHotels.isEmpty
            ? SizedBox(
                height: 325.0,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text('No data found')),
              )
            : GestureDetector(
                onTap: () async {
                  _loadingPopularHotels = true;

                  HotelsModel? hotelsModel = _popularAllHotels[i];
                  _loadingPopularHotels = false;
                  setState(() {});
                  await AppNavigation().push(
                      context,
                      MakeInqury(
                        customModel: CustomInquiryModel(
                          id: hotelsModel.id,
                          latitude: hotelsModel.latitude,
                          longitude: hotelsModel.longitude,
                          imageUrl: AppUrl.hotelsPicBaseUrl +
                              (hotelsModel.imageUrl ?? ''),
                          key: 'hotel',
                          name: hotelsModel.hotel,
                          amenities: hotelsModel.amenities,
                          adults: hotelsModel.adults,
                          checkins: hotelsModel.checkins,
                          address: hotelsModel.address,
                          description: hotelsModel.description,
                          dressCode: hotelsModel.dressCode,
                          rating: hotelsModel.rating,
                          menuOptions: hotelsModel.menuOptions,
                          openingHours: hotelsModel.openingHours,
                          price: hotelsModel.price,
                        ),
                      ));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: Material(
                      elevation: 1,
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.blackColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: Image.network(
                                '${AppUrl.hotelsPicBaseUrl}${_popularAllHotels[i].imageUrl}',
                                width: 120,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      _popularAllHotels[i].hotel ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.whiteColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        _popularAllHotels[i].description ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            height: 1.5,
                                            fontSize: 16,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    Text(
                                      _popularAllHotels[i].address ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.kPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, top: 15),
                                child: Text(
                                  _popularAllHotels[i].price ?? "\£",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16, color: AppColors.kPrimary),
                                )),
                          ],
                        ),
                      ),
                    )),
              );
  }

  _getAllLuxuryHotels() async {
    try {
      var response = await _dio.get(
        path: AppUrl.getLuxuryHotels,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loadingLuxuryHotels = false;
        var products = responseData['data']['hotels'];
        List<HotelsModel> luxuryHotelsListTemp = [];

        await products.forEach((item) async {
          var hotel = HotelsModel.fromJson(item);
          luxuryHotelsListTemp.add(hotel);
        });

        setState(() {
          _luxuryAllHotels = luxuryHotelsListTemp;
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

  _getAllPopularHotel() async {
    try {
      var response = await _dio.get(
        path: AppUrl.getPopularHotels,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loadingPopularHotels = false;
        var products = responseData['data']['hotels'];
        List<HotelsModel> temp = [];

        await products.forEach((item) async {
          var hotel = HotelsModel.fromJson(item);
          temp.add(hotel);
        });

        setState(() {
          _popularAllHotels = temp;
        });
      } else {
        if (responseData != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
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

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
  }

  void _markFavourite(HotelsModel luxuryAllHotel) async {
    _loadingLuxuryHotels = true;
    setState(() {});
    if (luxuryAllHotel.isFavourite) {
      ///add to fav
      try {
        var response = await _dio.post(
          path: 'favorite-listing',
          data: {
            'entity': 'hotels',
            'entity_type_id': luxuryAllHotel.id,
            'favorite': '1',
          },
        );
        _loadingLuxuryHotels = false;
        setState(() {});
        var responseStatusCode = response.statusCode;
        var responseData = response.data;
        if (responseStatusCode == StatusCode.OK) {
        } else {
          if (responseData != null) {
            errorDialog(context, 'Error', responseData['message'],
                closeOnBackPress: true, neutralButtonText: "OK");
          } else {
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

        errorDialog(
            context, "Error", "Something went wrong please try again later",
            closeOnBackPress: true, neutralButtonText: "OK");
      }
    } else {
      var response = await _dio.delete(
        path: 'favorite-listing/${luxuryAllHotel.id}',
      );
      _loadingLuxuryHotels = false;
      setState(() {});
    }
  }
}
