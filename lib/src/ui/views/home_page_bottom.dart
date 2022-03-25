// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/src/ui/pages/inqury/make_inqury.dart';
import 'package:dubai_screens/src/ui/views/all_hotels_page.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/ui/widgets/decrated_text_field.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({Key? key}) : super(key: key);

  @override
  _BottomHomePageState createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  late AppDio _dio;

  TextEditingController searchController = TextEditingController();
  List<HotelsModel> _luxuryAllHotels = [];
  List<HotelsModel> _luxuryHotelsSearchList = [];
  List<HotelsModel> _popularAllHotels = [];
  List<HotelsModel> _popularHotelsSearchList = [];
  bool _loadingLuxuryHotels = true;
  bool _loadingPopularHotels = true;

  String? _profileImageURL;

  bool isCountryBtn = false;
  bool isCityBtn = false;
  bool isNameBtn = false;

  String? _userName;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => ProfilePageBottom()));
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: (_profileImageURL != null &&
                      (_profileImageURL ?? '').isNotEmpty)
                  ? Image.network(
                      "http://dubai.applypressure.co.uk/profile_pics/$_profileImageURL")
                  : SizedBox(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 30, left: 20, bottom: 15),
                child: Text(
                  "Hey, ${_userName ?? ''}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'Best Hotels in Dubai',
                  style: TextStyle(
                    color: AppColors.kPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
            _buildSearch(),
            _buildViewAll(),
            _buildLuxuryHotelListView(),
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
            for (int i = 0; i < _popularHotelsSearchList.length; i++)
              _buildPopularHotelList(i)
          ],
        ),
      ),
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
        : _popularHotelsSearchList.isEmpty
            ? SizedBox(
                height: 325.0,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text('No data found')),
              )
            : GestureDetector(
                onTap: () {
                  AppNavigation().push(
                    context,
                    MakeInqury(
                      hotelModel: _popularHotelsSearchList[i],
                    ),
                  );
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
                                '${AppUrl.hotelsPicBaseUrl}${_popularHotelsSearchList[i].imageUrl}',
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
                                      _popularHotelsSearchList[i].hotel ?? '',
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
                                        _popularHotelsSearchList[i]
                                                .description ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            height: 1.5,
                                            fontSize: 16,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    Text(
                                      _popularHotelsSearchList[i].address ?? '',
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
                                  _popularHotelsSearchList[i].price ?? "\£",
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

  Widget _buildViewAll() {
    return Padding(
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
                push(AllHotelsPage());
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppColors.kPrimary,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        children: [
          Expanded(
              child: SearchField(
                  onChange: (v) {
                    print(v);
                    if (v.length > 2) {
                      _getSearchList(v);
                    } else if (v.length <= 2 || v.isEmpty) {
                      _luxuryHotelsSearchList = _luxuryAllHotels;
                      _popularHotelsSearchList = _popularAllHotels;
                      setState(() {});
                    }
                  },
                  controller: searchController,
                  hintText: 'Search for hotels')),
          const SizedBox(
            width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                /* AppBottomSheet.appMaterialBottomSheet(context, list: [
                  ListTile(
                    title:
                        // Text("_____"),
                        Icon(
                      Icons.maximize_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      pop();
                    },
                  ),
                  ListTile(
                    title: Center(
                        child: Text(
                      "Filter for search",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RoundedButton(
                          title: "Country",
                          isFilled: isCountryBtn,
                          onPress: () {
                            pop();
                            isCountryBtn = true;
                            isCityBtn = false;
                            isNameBtn = false;
                            setState(() {});
                          },
                        ),
                        SizedBox(width: 6),
                        RoundedButton(
                          title: "City",
                          isFilled: isCityBtn,
                          onPress: () {
                            pop();
                            isCountryBtn = false;
                            isCityBtn = true;
                            isNameBtn = false;
                            setState(() {});
                          },
                        ),
                        SizedBox(width: 6),
                        RoundedButton(
                          title: "Name",
                          isFilled: isNameBtn,
                          onPress: () {
                            pop();
                            isCountryBtn = false;
                            isCityBtn = false;
                            isNameBtn = true;
                            setState(() {});
                          },
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                  ),
                  SizedBox(height: 16)
                ]);*/
              },
              child: Image.asset(
                AppImages.bottomStatsIcon,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLuxuryHotelListView() {
    return _loadingLuxuryHotels == true
        ? Container(
            height: 325.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CircularProgressIndicator(
              color: AppColors.kPrimary,
            )),
          )
        : SizedBox(
            height: 325.0,
            child: _luxuryHotelsSearchList.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    itemCount: _luxuryHotelsSearchList.length,
                    itemBuilder: (c, i) {
                      var item = _luxuryHotelsSearchList[i];
                      return GestureDetector(
                          onTap: () {
                            AppNavigation()
                                .push(context, MakeInqury(hotelModel: item));
                          },
                          child: Material(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              elevation: .8,
                              child: Container(
                                width: 210,
                                decoration: BoxDecoration(
                                    color: AppColors.blackColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xffc4c4c4),
                                          image: DecorationImage(
                                              /*  image: Image.asset(
                                          ///setting temporary as required by client
                                          hotelList[i + 2].hotelImage,
                                          width: 120,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ).image*/
                                              image: NetworkImage(
                                                  '${AppUrl.hotelsPicBaseUrl}${item.imageUrl}'),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12))),
                                      height: 180,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Align(
                                          child: GestureDetector(
                                            child: Icon(
                                              _luxuryHotelsSearchList[i]
                                                      .isFavourite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: AppColors.kPrimary,
                                            ),
                                            onTap: () {
                                              _luxuryHotelsSearchList[i]
                                                      .isFavourite =
                                                  !_luxuryHotelsSearchList[i]
                                                      .isFavourite;
                                              setState(() {});
                                            },
                                          ),
                                          alignment: Alignment.topRight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
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
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          for (int i = 0;
                                              i < (item.rating ?? '0').toInt();
                                              i++)
                                            Padding(
                                                padding: const EdgeInsets.only(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
          );
  }

  _init() async {
    await _getAllLuxuryHotels();
    await _getAllPopularHotel();
    _getUserData();
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
        _userName = prefs.getString(PrefKey.FIRST_NAME)!;
      });
    });
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
          _luxuryHotelsSearchList = _luxuryAllHotels;
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
          _popularHotelsSearchList = _popularAllHotels;
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

  _getSearchList(String text) async {
    setState(() {
      _loadingLuxuryHotels = true;
    });
    try {
      var response = await _dio.post(path: AppUrl.searchList, data: {
        "query": text,
      });

      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['hotels'];
        List<HotelsModel> luxuryHotelsListTemp = [];

        await products.forEach((item) async {
          var hotel = HotelsModel.fromJson(item);
          luxuryHotelsListTemp.add(hotel);
        });

        setState(() {
          _luxuryHotelsSearchList = luxuryHotelsListTemp;
          _loadingLuxuryHotels = false;
        });
        /*  List<HotelsModel> hotelsTempList = [];
        products.forEach((item) async {
          hotelsTempList.add(HotelsModel.fromJson(item));
        });
        setState(() {
          _luxuryHotelsSearchList = hotelsTempList;
          _loadingHotelsList = false;
        });*/
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
