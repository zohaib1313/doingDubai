import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/clubs_model.dart';
import 'package:dubai_screens/model/events_model.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../model/custom_inquiry_model.dart';
import '../../../model/landmarks_model.dart';
import '../../../model/transporters_model.dart';
import '../../utils/nav.dart';
import '../pages/inqury/make_inqury.dart';

class AllLandMarksPage extends StatefulWidget {
  const AllLandMarksPage({Key? key}) : super(key: key);

  @override
  _AllLandMarksPageState createState() => _AllLandMarksPageState();
}

class _AllLandMarksPageState extends State<AllLandMarksPage> {
  late AppDio _dio;
  bool _isFav = false;
  TextEditingController searchController = TextEditingController();
  List<LandMarksModel> itemList = [];
  bool _loading = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = AppDio(context);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blackColor,
        appBar: AppBar(
          backgroundColor: AppColors.blackColor,
          iconTheme: IconThemeData(color: AppColors.kPrimary),
          title: Text(
            "All Land Marks",
            style: TextStyle(color: AppColors.kPrimary),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: _loading
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.kPrimary,
              ),
            )
                : ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                var item = itemList[index];
                return GestureDetector(
                  onTap: () async {
                    var model = item;
                    await AppNavigation().push(
                        context,
                        MakeInqury(
                          customModel: CustomInquiryModel(
                            id: model.id ?? -1,
                            imageUrl: AppUrl.landMarkPicBaseUrl + (model.imageUrl ?? ''),
                            key: 'landmark',
                            name: model.landmark,
                            inquiry_price: model.inquiryPrice,
                            amenities: '',
                            latitude: model.latitude,
                            longitude: model.longitude,
                            checkins: model.checkins,
                            address: model.address,
                            description: model.description,
                            rating: model.rating,
                            openingHours: model.openingHours,
                            price: model.inquiryPrice,
                          ),
                        ));
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, left: 20, right: 20),
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
                                  child: /* Image.asset(
                                        ///setting temporary as required by client
                                        hotelList[index + 2].hotelImage,
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),*/
                                  Image.network(
                                    'http://dubai.applypressure.co.uk/images/landmarkpics/${item.imageUrl}',
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ('${item.landmark}'),
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
                                          "${item.address}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              height: 1.5,
                                              fontSize: 16,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        "Dubai,United Arab Emirates",
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
                                  padding: const EdgeInsets.only(
                                      right: 5, top: 15),
                                  child: Text(
                                    "\£",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.kPrimary),
                                  )),
                            ],
                          ),
                        ),
                      )),
                );
              },
            ),
          ),
        )
      // drawer: const Drawer(),
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        var item = itemList[index];
        return Text("ok");
      },
    );
  }

  _init() async {
    await _getListing();
  }

  _getListing() async {
    try {
      var response = await _dio.get(
        path: 'all-landmarks',
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loading = false;
        var products = responseData['data']['landmarks'];
        List<LandMarksModel> tempList = [];

        await products.forEach((item) async {
          var model = LandMarksModel.fromJson(item);
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
}
