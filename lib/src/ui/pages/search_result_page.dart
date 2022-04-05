import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/custom_inquiry_model.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';

import '../../utils/nav.dart';
import 'inqury/make_inqury.dart';

class SearchResultPage extends StatefulWidget {
  String? query;

  SearchResultPage(this.query);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late AppDio _dio;

  List<CustomInquiryModel> itemList = [];
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
    return Scaffold(
        backgroundColor: AppColors.blackColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.kPrimary),
          title: Text("Result \"${widget.query}\""),
        ),
        body: _loading == true
            ? Center(
                child: SizedBox(
                  height: 325.0,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: AppColors.kPrimary,
                  )),
                ),
              )
            : itemList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return getInfoCardItem(itemList[index]);
                    })
                : const Center(
                    child: Text('No Data Found'),
                  ));
  }

  _getListing() async {
    try {
      var response =
          await _dio.post(path: '/search', data: {'query': widget.query});
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        Map<String, List<dynamic>> map = {};

        var reco_hotel = responseData['data']['hotels'];
        if (reco_hotel != null) {
          map['hotel'] = reco_hotel;
        }

        var reco_club = responseData['data']['clubs'];
        if (reco_club != null) {
          map['club'] = reco_club;
        }

        var reco_event = responseData['data']['events'];
        if (reco_event != null) {
          map['event'] = reco_event;
        }

        var reco_landmark = responseData['data']['landmarks'];
        if (reco_landmark != null) {
          map['landmark'] = reco_landmark;
        }

        var reco_restaurant = responseData['data']['restaurants'];
        if (reco_restaurant != null) {
          map['restaurant'] = reco_restaurant;
        }
        var reco_transporter = responseData['data']['transporters'];
        if (reco_transporter != null) {
          map['transporter'] = reco_transporter;
        }
        for (var element in map.entries) {
          for (var element2 in element.value) {
            CustomInquiryModel model = CustomInquiryModel.fromMap(element2);
            model.key = element.key;
            model.imageUrl =
                'http://dubai.applypressure.co.uk/images/${model.key}pics/${element2['image_url']}';
            model.name = element2[model.key];
            itemList.add(model);
          }
        }

        _loading = false;
        if (mounted) {
          setState(() {});
        }
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

  Widget getInfoCardItem(CustomInquiryModel item) {
    return GestureDetector(
      onTap: () async {
        await AppNavigation().push(
          context,
          MakeInqury(
            customModel: item,
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
                    child: Image.network(
                      item.imageUrl ?? '',
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
                            item.name ?? '',
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
                              item.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          Text(
                            item.address ?? '',
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
                        item.price ?? "£",
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
