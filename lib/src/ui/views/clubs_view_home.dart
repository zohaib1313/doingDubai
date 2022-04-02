import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/clubs_main_model.dart';
import 'package:dubai_screens/model/clubs_model.dart';
import 'package:dubai_screens/network_calls.dart';
import 'package:dubai_screens/src/ui/pages/inqury/make_inqury.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../config/app_urls.dart';
import '../../../model/custom_inquiry_model.dart';
import '../../utils/nav.dart';

class ClubsViewHome extends StatefulWidget {
  ClubsViewHome({Key? key}) : super(key: key);

  @override
  _ClubsViewHomeState createState() => _ClubsViewHomeState();
}

class _ClubsViewHomeState extends State<ClubsViewHome> {
  late AppDio _dio;

  List<ClubsModel> itemList = [];
  bool _loading = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _init() async {
    await _getListing();
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
                      'Clubs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  itemList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemList.length,
                          itemBuilder: (context, index) {
                            return getInfoCardItem(itemList[index]);
                          })
                      : const Center(
                          child: Text('No Data Found'),
                        )
                ],
              )
      ],
    );
  }

  _getListing() async {
    try {
      var response = await _dio.get(
        path: 'all-clubs',
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loading = false;
        var products = responseData['data']['clubs'];
        List<ClubsModel> tempList = [];

        await products.forEach((item) async {
          var model = ClubsModel.fromJson(item);
          tempList.add(model);
        });

        setState(() {
          itemList = tempList;
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

  Widget getInfoCardItem(ClubsModel club) {
    return GestureDetector(
      onTap: () async {
        ClubsMainModel? model =
            await NetworkCalls.getOneClub((club.id ?? -1).toString(), context);
        await AppNavigation().push(
            context,
            MakeInqury(
              customModel: CustomInquiryModel(
                id: model?.id ?? -1,
                imageUrl: AppUrl.clubPicBaseUrl + (model?.imageUrl ?? ''),
                key: 'club',
                name: model?.club ?? '',
                amenities: model?.amenities ?? '',
                adults: model?.adults,
                checkins: model?.checkins,
                address: model?.address,
                description: model?.description,
                dressCode: model?.dressCode,
                rating: model?.rating,
                openingHours: model?.openingHours,
                price: model?.price,
                inquiry_price: model?.inquiryPrice,
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
                      'http://dubai.applypressure.co.uk/images/clubpics/${club.imageUrl}',
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
                            club.club ?? '',
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
                              club.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          Text(
                            club.address ?? '',
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
                        club.price ?? "£",
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
