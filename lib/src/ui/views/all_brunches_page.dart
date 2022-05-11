import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/brunches_model.dart';
import 'package:dubai_screens/model/clubs_model.dart';
import 'package:dubai_screens/model/events_model.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../../model/custom_inquiry_model.dart';
import '../../utils/nav.dart';
import '../pages/inqury/make_inqury.dart';

class AllBrunchesPage extends StatefulWidget {
  const AllBrunchesPage({Key? key}) : super(key: key);

  @override
  _AllBrunchesPageState createState() => _AllBrunchesPageState();
}

class _AllBrunchesPageState extends State<AllBrunchesPage> {
  late AppDio _dio;
  bool _isFav = false;
  TextEditingController searchController = TextEditingController();
  List<BrunchesModel> _listMain = [];
  bool _isLoading = true;

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
            "All Brunches",
            style: TextStyle(color: AppColors.kPrimary),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.kPrimary,
              ),
            )
                : ListView.builder(
              itemCount: _listMain.length,
              itemBuilder: (context, index) {
                var item = _listMain[index];
                return GestureDetector(
                  onTap: () async {
                    var model = item;
                    await AppNavigation().push(
                        context,
                        MakeInqury(
                          customModel: CustomInquiryModel(
                            id: model.id,
                            imageUrl: AppUrl.brunchpicsPicBaseUrl +
                                (model.imageUrl ?? ''),
                            key: 'brunch',
                            name: model.brunch,
                            latitude: model.latitude,
                            longitude: model.longitude,
                            amenities: model.amenities,
                            adults: false,
                            checkins: model.checkins,
                            address: model.address,
                            description: model.description,
                            dressCode: model.dressCode,
                            rating: model.rating,
                            menuOptions: model.amenities,
                            openingHours: model.openingHours,
                            price: model.price,
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
                                    'http://dubai.applypressure.co.uk/images/brunchpics/${item.imageUrl}',
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
                                        ('${item.brunch}'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.whiteColor),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "${item.address}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
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
      itemCount: _listMain.length,
      itemBuilder: (context, index) {
        var item = _listMain[index];
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
        path: 'all-brunches',
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _isLoading = false;
        var products = responseData['data']['brunches'];
        List<BrunchesModel> tempList = [];

        await products.forEach((item) async {
          var model = BrunchesModel.fromJson(item);
          tempList.add(model);
        });

        setState(() {
          _listMain = tempList;
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
