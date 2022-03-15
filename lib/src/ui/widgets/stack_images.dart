import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/images.dart';
import 'package:flutter/material.dart';

class StackImages extends StatelessWidget {
  const StackImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.selfie1), fit: BoxFit.cover),
              color: const Color(0xffb6b6b6),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.kPrimary, width: 1)),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.selfie2),fit: BoxFit.cover
                  ),
                  color: const Color(0xffb6b6b6),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.kPrimary, width: 1)),
            )),
        Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.selfie4),fit: BoxFit.cover
                  ),
                  color: const Color(0xffb6b6b6),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.kPrimary, width: 1)),
            )),
      ],
    );
  }
}
