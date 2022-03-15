import 'package:doingdubai/config/app_urls.dart';
import 'package:doingdubai/config/dio/app_dio.dart';
import 'package:doingdubai/config/keys/response_code.dart';
import 'package:doingdubai/model/hotels_model.dart';
import 'package:doingdubai/src/ui/pages/inqury/make_inqury.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

class AllHotelsPage extends StatefulWidget {
  const AllHotelsPage({Key? key}) : super(key: key);

  @override
  _AllHotelsPageState createState() => _AllHotelsPageState();
}

class _AllHotelsPageState extends State<AllHotelsPage> {
  late AppDio _dio;
  bool _isFav = false;
  TextEditingController searchController = TextEditingController();
  List<HotelsModel> _myHotelsList = [];
  bool _loadingHotelsList = true;

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
            "All Hotels",
            style: TextStyle(color: AppColors.kPrimary),
          ),
          elevation: 0,
          // iconTheme: const IconThemeData(color: Colors.black),
          // backgroundColor: Colors.white,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(4),
          //     child: Image.asset(AppImages.profileImage),
          //   )
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: _myHotelsList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimary,
                    ),
                  )
                : ListView.builder(
                    itemCount: _myHotelsList.length,
                    itemBuilder: (context, index) {
                      var item = _myHotelsList[index];
                      return GestureDetector(
                        onTap: () {
                          AppNavigation()
                              .push(context, MakeInqury(hotelModel: item));
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
                                          'http://dubai.applypressure.co.uk/images/hotelpics/${item.imageUrl}',
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
                                              ('${item.hotel}'),
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
      itemCount: _myHotelsList.length,
      itemBuilder: (context, index) {
        var item = _myHotelsList[index];
        return Text("ok");
      },
    );
  }

  _init() async {
    await _getAllProductsList();
  }

  _getAllProductsList() async {
    try {
      var response = await _dio.get(
        path: AppUrl.getAllHotels,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        _loadingHotelsList = false;
        var products = responseData['data']['hotels'];
        List<HotelsModel> hotelsTempList = [];
        products.forEach((item) async {
          hotelsTempList.add(HotelsModel.fromJson(item));
        });
        setState(() {
          _myHotelsList = hotelsTempList;
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
}
