// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/src/ui/pages/search_result_page.dart';
import 'package:dubai_screens/src/ui/views/brunch_view_home.dart';
import 'package:dubai_screens/src/ui/views/clubs_view_home.dart';
import 'package:dubai_screens/src/ui/views/events_view_home.dart';
import 'package:dubai_screens/src/ui/views/landmarks_view_home.dart';
import 'package:dubai_screens/src/ui/views/night_life_home.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/ui/views/transporters_view_home.dart';
import 'package:dubai_screens/src/ui/widgets/decrated_text_field.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:dubai_screens/widgets/other/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../pages/home_page.dart';
import '../widgets/buttons.dart';
import 'hotels_home_views.dart';
import 'resturants_view_home.dart';

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({Key? key}) : super(key: key);

  @override
  _BottomHomePageState createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  TextEditingController searchController = TextEditingController();

  String? _profileImageURL;

  String? _userName;
  List<String> filterList = [
    'Hotels',
    'Beach Clubs',
    'Events',
    'Restaurants',
    'Brunches',
    'Landmarks',
    'Transporters',
    'Nightlife',
  ];
  int selectedFilter = 0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (builder) => HomePage(
                    currentIndex: 0,
                  ),
                ),
              );
            },
            child:
                Icon(Icons.arrow_back_outlined, color: AppColors.primaryColor)),
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const ProfilePageBottom()));
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: (_profileImageURL != null &&
                      (_profileImageURL ?? '').isNotEmpty)
                  ? Image.network(
                      "http://dubai.applypressure.co.uk/profile_pics/$_profileImageURL")
                  : const SizedBox(),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Best ${filterList[selectedFilter]} in Dubai',
                  style: TextStyle(
                    color: AppColors.kPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
            _buildSearch(),
            IndexedStack(
              index: selectedFilter,
              children: [
                HotelsView(),
                ClubsViewHome(),
                EventsViewHome(),
                ResturantViewHome(),
                BrunchViewHome(),
                LandMarksViewHome(),
                TransportersViewHome(),
                NightLifeViewHome(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
              child: SearchField(
                  onChange: (v) {
                    /*  if (v.length > 2) {
                      _getSearchList(v);
                    } else if (v.length <= 2 || v.isEmpty) {
                      _luxuryHotelsSearchList = _luxuryAllHotels;
                      _popularHotelsSearchList = _popularAllHotels;
                      setState(() {});
                    }*/
                  },
                  controller: searchController,
                  onSaved: (query) {
                    print(query);
                    if (searchController.text.isNotEmpty) {
                      AppNavigation().push(context,
                          SearchResultPage(searchController.text.toString()));
                      searchController.clear();
                    }
                  },
                  hintText: 'Search for ${filterList[selectedFilter]}')),
          const SizedBox(
            width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () {
                AppBottomSheet.appMaterialBottomSheet(context, list: [
                  ListTile(
                    title: const Icon(
                      Icons.maximize_rounded,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      pop();
                    },
                  ),
                  const Center(
                      child: Text(
                    "Filter",
                    style: TextStyle(fontSize: 20),
                  )),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(18.0),
                          margin: const EdgeInsets.only(
                              bottom: 18.0, left: 20, right: 20, top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryColor),
                            color: selectedFilter == index
                                ? AppColors.primaryColor
                                : AppColors.blackColor,
                          ),
                          child: InkWell(
                            onTap: () {
                              selectedFilter = index;
                              pop();
                              setState(() {});
                            },
                            child: Center(
                              child: Text(
                                filterList[index],
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 16)
                ]);
              },
              child: Text(
                "Change Category",
                style: TextStyle(fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
        _userName = prefs.getString(PrefKey.FIRST_NAME)!;
      });
    });
  }
}
