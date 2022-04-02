import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/custom_inquiry_model.dart';
import 'package:dubai_screens/model/restaurant_main_model.dart';
import 'package:dubai_screens/model/restaurants_model.dart';
import 'package:dubai_screens/network_calls.dart';
import 'package:dubai_screens/src/ui/pages/inqury/make_inqury.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

class ResturantViewHome extends StatefulWidget {
  ResturantViewHome({Key? key}) : super(key: key);

  @override
  _ResturantViewHomeState createState() => _ResturantViewHomeState();
}

class _ResturantViewHomeState extends State<ResturantViewHome> {
  late AppDio _dio;

  List<Restaurants> _restaurantsList = [];
  bool _loading = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _init() async {
    await _getRestaurants();
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
        _loading == true
            ? SizedBox(
                height: 325.0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.kPrimary,
                )),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Text(
                      'Restaurants',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _restaurantsList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _restaurantsList.length,
                          itemBuilder: (context, index) {
                            return getInfoCardItem(_restaurantsList[index]);
                          })
                      : const Center(
                          child: Text('No Data Found'),
                        )
                ],
              )
      ],
    );
  }

  _getRestaurants() async {
    try {
      var response = await _dio.get(
        path: 'all-restaurants',
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loading = false;
        var products = responseData['data']['restaurants'];
        List<Restaurants> tempList = [];

        await products.forEach((item) async {
          var model = Restaurants.fromJson(item);
          tempList.add(model);
        });

        setState(() {
          _restaurantsList = tempList;
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

  Widget getInfoCardItem(Restaurants restaurant) {
    return GestureDetector(
      onTap: () async {
        RestaurantMainModel? model = await NetworkCalls.getOneRestaurant(
            (restaurant.id ?? -1).toString(), context);

        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: model?.id ?? -1,
                imageUrl: AppUrl.restaurantPicBaseUrl + (model?.imageUrl ?? ''),
                key: 'restaurant',
                name: model?.restaurant ?? '',
                amenities: model?.amenities ?? '',
                checkins: model?.checkins,
                inquiry_price: model?.inquiryPrice,
                address: model?.address,
                description: model?.description,
                dressCode: model?.dressCode,
                rating: model?.rating,
                menuOptions: model?.menuOptions,
                openingHours: model?.openingHours,
                price: model?.price,
              ),
            ));
      },
      child: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
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
                      'http://dubai.applypressure.co.uk/images/restaurantpics/${restaurant.imageUrl}',
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
                            restaurant.restaurant ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.whiteColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              restaurant.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          Text(
                            restaurant.address ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16, color: AppColors.kPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 5, top: 15),
                      child: Text(
                        restaurant.price ?? "£",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            TextStyle(fontSize: 16, color: AppColors.kPrimary),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
