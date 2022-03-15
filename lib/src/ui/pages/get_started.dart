import 'package:doingdubai/src/ui/pages/auth/sign_in.dart';
import 'package:doingdubai/src/ui/pages/auth/sign_up.dart';
import 'package:doingdubai/src/ui/widgets/buttons.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:doingdubai/src/utils/const.dart';
import 'package:doingdubai/src/utils/images.dart';
import 'package:doingdubai/src/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(

        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 60),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.getStarted), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              _buildWelcomeContainer(),
              const Spacer(),
              AuthButton(
                  text: 'Sign In',
                  onTap: () {
                    push(SignInPage());
                    // AppNavigation().push(context, const SignInPage());
                  }),
              const SizedBox(
                height: 20,
              ),
              AuthButton(
                text: 'Sign Up',
                onTap: () {
                  push(SignUpPage());
                },
                backGroundColor: Colors.white,
                textColor: AppColors.kPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "WELCOME TO DUBAI",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            getStarted,
            style: const TextStyle(
              fontSize: 17,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
