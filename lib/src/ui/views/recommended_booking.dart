import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/model/booking.dart';
import 'package:dubai_screens/model/hotel_model.dart';
import 'package:flutter/material.dart';

import '../../../model/hotels_model.dart';
import '../../utils/colors.dart';
import '../../utils/nav.dart';
import '../pages/inqury/make_inqury.dart';

class RecommendedBooking extends StatefulWidget {
  const RecommendedBooking({Key? key}) : super(key: key);

  @override
  _RecommendedBookingState createState() => _RecommendedBookingState();
}

class _RecommendedBookingState extends State<RecommendedBooking> {
  bool _loading = true;
  late AppDio _dio;
  List<Bookings> bookingList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
        // backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Recommended Bookings',
                  style: TextStyle(color: AppColors.kPrimary, fontSize: 20),
                ),
              )),
        ),
      ),
      body: GridView.builder(
        itemCount: hotelList.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 33,
            crossAxisSpacing: 10,
            childAspectRatio: 0.5),
        itemBuilder: (c, i) {
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
              child: Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                        ),
                        child: Image.asset(
                          hotelList[i].hotelImage,
                          height: 130,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            hotelList[i].hotelName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 12, left: 12, right: 12),
                          child: Text(
                            "Immerse yourself in a clubbing experience..",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 12, right: 12, left: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "\£",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, color: AppColors.kPrimary),
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "4.8",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Icon(
                                  Icons.star,
                                  color: AppColors.kPrimary,
                                  size: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.12, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              color: AppColors.kPrimary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Make Inquiry',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
