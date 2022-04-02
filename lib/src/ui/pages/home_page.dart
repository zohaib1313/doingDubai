import 'package:dubai_screens/src/ui/views/bottom_calender_view.dart';
import 'package:dubai_screens/src/ui/views/home_page_bottom.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:dubai_screens/widgets/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../views/recommended_booking.dart';

class HomePage extends StatefulWidget {
  int currentIndex = 0;

  HomePage({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
  }

  onChange(int index) {
    _currentIndex = index;
    setState(() {});
  }

  final List<Widget> _widgets = [
    const BottomHomePage(),
    const RecommendedBooking(),
    const BookingsAndConfirmationsBottom(),
    const ProfilePageBottom()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: const Text('Yes, exit'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _widgets[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.white,
            onTap: onChange,
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.kPrimary,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: SvgViewer(
                  svgPath: 'assets/svgs/home.svg',
                  color: _currentIndex == 0 ? AppColors.kPrimary : Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgViewer(
                  svgPath: 'assets/svgs/filter.svg',
                  color: _currentIndex == 1 ? AppColors.kPrimary : Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgViewer(
                  svgPath: 'assets/svgs/file.svg',
                  color: _currentIndex == 2 ? AppColors.kPrimary : Colors.white,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgViewer(
                  svgPath: 'assets/svgs/profileIcon.svg',
                  color: _currentIndex == 3 ? AppColors.kPrimary : Colors.white,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
