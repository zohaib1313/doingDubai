// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:doingdubai/config/app_urls.dart';
import 'package:doingdubai/config/dio/app_dio.dart';
import 'package:doingdubai/config/keys/pref_keys.dart';
import 'package:doingdubai/config/keys/response_code.dart';
import 'package:doingdubai/model/hotel_model.dart';
import 'package:doingdubai/model/hotels_model.dart';
import 'package:doingdubai/src/ui/pages/inqury/make_inqury.dart';
import 'package:doingdubai/src/ui/views/all_hotels_page.dart';
import 'package:doingdubai/src/ui/views/profile_page_bottom.dart';
import 'package:doingdubai/src/ui/widgets/decrated_text_field.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/images.dart';
import 'package:doingdubai/src/utils/nav.dart';
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
  List<HotelsModel> _myHotelsList = [];
  List<HotelsModel> _HotelsSearchList = [];
  bool _loadingHotelsList = true;
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
            _buildClubsHorizontal(),
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
            for (int i = 0; i < hotelList.length; i++) _buildVerticalList(i)
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalList(int i) {
    return GestureDetector(
      onTap: () {
        AppNavigation().push(
          context,
          MakeInqury(
            ///setting temporary with dummy
            hotelModel: HotelsModel(
                hotel: hotelList[i].hotelName,
                amenities: 'Bar,Wifi,Cam',
                imageUrl: hotelList[i].hotelImage,
                id: -1,
                address: 'Dubai,United Arab Emirates'),
          ),
        );
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
                    child: Image.asset(
                      hotelList[i].hotelImage,
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
                            hotelList[i].hotelName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.whiteColor),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Four Seasons Resort Dubai at Jumeirah Beach offers..",
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
                                fontSize: 16, color: AppColors.kPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 5, top: 15),
                      child: Text(
                        "\£",
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
                    if (v.length > 2) {
                      _getSearchList(v);
                    } else if (v.length <= 2) {
                      print(_myHotelsList);
                      _HotelsSearchList = _myHotelsList;
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

  Widget _buildClubsHorizontal() {
    return _loadingHotelsList == true
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
            child: _HotelsSearchList.length > 0
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    itemCount: _HotelsSearchList.length,
                    itemBuilder: (c, i) {
                      var item = _HotelsSearchList[i];
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
                                                  '${AppUrl.imageBaseUrl}${item.imageUrl}'),
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
                                              _myHotelsList[i].isFavourite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: AppColors.kPrimary,
                                            ),
                                            onTap: () {
                                              _myHotelsList[i].isFavourite =
                                                  !_myHotelsList[i].isFavourite;
                                              setState(() {});
                                            },
                                          ),
                                          alignment: Alignment.topRight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
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
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 5,
                                          top: 8,
                                          bottom: 8),
                                      child: Text(
                                        'Dubai,UAE',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < 5; i++)
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
                : Center(
                    child: Text('No Result Found'),
                  ),
          );
  }

  _init() async {
    await _getAllProductsList();
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
          _HotelsSearchList = _myHotelsList;
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
    try {
      var response = await _dio.post(path: AppUrl.searchList, data: {
        "query": text,
      });

      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['hotels'];
        print(products);
        List<HotelsModel> hotelsTempList = [];
        products.forEach((item) async {
          hotelsTempList.add(HotelsModel.fromJson(item));
        });
        setState(() {
          _HotelsSearchList = hotelsTempList;
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
