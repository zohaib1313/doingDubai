import 'package:dubai_screens/src/ui/pages/inqury/submit_inqury.dart';
import 'package:dubai_screens/src/ui/widgets/buttons.dart';
import 'package:dubai_screens/src/ui/widgets/stack_images.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/src/utils/images.dart';
import 'package:dubai_screens/src/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

import '../../../../config/app_urls.dart';
import '../../../../model/hotels_model.dart';

class MakeInqury extends StatefulWidget {
  HotelsModel? hotelModel;

  MakeInqury({Key? key, required this.hotelModel}) : super(key: key);

  @override
  _MakeInquryState createState() => _MakeInquryState();
}

class _MakeInquryState extends State<MakeInqury> {
  List<String>? chips = [];

  @override
  void initState() {
    super.initState();
    chips = widget.hotelModel?.amenities?.split(",").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStarRow(),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Text(
                widget.hotelModel?.address ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            _buildImageContainer(),
            _buildChipsList(),
            Text(
              'Description',
              style: TextStyle(color: AppColors.kPrimary, fontSize: 18),
            ),
            _buildDescriptionText(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Recently Booked',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                StackImages()
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(widget.hotelModel?.price ?? ''),
                    ),
                    Expanded(
                      flex: 2,
                      child: AuthButton(
                          text: 'Make Inquiry',
                          textColor: AppColors.blackColor,
                          onTap: () {
                            AppNavigation().push(
                                context,
                                SubmitInqury(
                                  hotelModel: widget.hotelModel,
                                ));
                          }),
                    )
                  ],
                ))
          ],
        ),
        padding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 40),
        child: Text(
          widget.hotelModel?.description ?? '',
          style: TextStyle(
            color: AppColors.whiteColor,
            height: 1.5,
            fontSize: 16,
          ),
        ));
  }

  Widget _buildImageContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: widget.hotelModel!.id! == -1

                  ///setting temporary
                  ? Image.asset(
                      widget.hotelModel!.imageUrl!,
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                    ).image
                  : Image.network(AppUrl.hotelsPicBaseUrl +
                          (widget.hotelModel?.imageUrl ?? ''))
                      .image,
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20)),
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blackColor,
              ),
              child: Image.asset(AppImages.send))),
    );
  }

  Widget _buildStarRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.hotelModel?.hotel ?? '-',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Row(
          children: [
            for (int i = 0; i < (widget.hotelModel?.rating ?? '0').toInt(); i++)
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Icon(
                  Icons.star,
                  size: 20,
                  color: AppColors.kPrimary,
                ),
              )
          ],
        )
      ],
    );
  }

  Widget _buildChipsList() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Chip(
              backgroundColor: AppColors.kPrimary,
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  chips![i],
                  style: TextStyle(color: AppColors.blackColor),
                ),
              ));
        },
        itemCount: chips?.length ?? 0,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 18,
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
