import 'package:dubai_screens/config/keys/pref_keys.dart';
import 'package:dubai_screens/src/ui/views/profile_page_bottom.dart';
import 'package:dubai_screens/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:req_fun/req_fun.dart';

import '../../../model/hotel_model.dart';

class BookingsAndConfirmationsBottom extends StatefulWidget {
  const BookingsAndConfirmationsBottom({Key? key}) : super(key: key);

  @override
  _BookingsAndConfirmationsBottomState createState() =>
      _BookingsAndConfirmationsBottomState();
}

class _BookingsAndConfirmationsBottomState
    extends State<BookingsAndConfirmationsBottom> {
  DateTime? selectedFromDates;
  String? _profileImageURL;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedFromDates = picked;
      });
    }
  }

  DateTime? selectedToDates;

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedToDates = picked;
      });
    }
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Bookings & Confirmations',
          style: TextStyle(color: AppColors.kPrimary),
        ),
        centerTitle: true,
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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildFromDateTimeRow(selectedFromDates, selectedToDates)),
      ),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
          itemBuilder: (c, i) {
            return getStackItem(
                i: i,
                title: hotelList[i].hotelName,
                img: hotelList[i].hotelImage);
          },
          separatorBuilder: (c, i) {
            return const SizedBox(
              height: 25,
            );
          },
          itemCount: hotelList.length),
    );
  }

  Widget _buildFromDateTimeRow(
    DateTime? selectedFromDate,
    DateTime? selectedToDate,
  ) {
    String selectedFromDate =
        DateFormat('dd  MMM ').format(selectedFromDates ?? DateTime.now());
    String selectedTODate =
        DateFormat('dd  MMM ').format(selectedToDates ?? DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today,
          color: AppColors.kPrimary,
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Text(selectedFromDate.toString()),
          onTap: () {
            _selectFromDate(context);
          },
        ),
        Text('    -     '),
        GestureDetector(
          child: Text(selectedTODate.toString()),
          onTap: () {
            _selectToDate(context);
          },
        ),
      ],
    );
  }

  _getUserData() async {
    await Prefs.getPrefs().then((prefs) {
      setState(() {
        _profileImageURL = prefs.getString(PrefKey.PROFILE_PICTURE);
      });
    });
  }

  Widget getStackItem({required int i, required String title, required img}) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.black,
                    elevation: 1,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      margin:
                          const EdgeInsets.only(left: 35, top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.kPrimary,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text('2 Adults')
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.kPrimary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Feb 1 - 12:00 AM')
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 120,
                  decoration: BoxDecoration(
                    color: i % 2 == 0 ? Colors.green : AppColors.kPrimary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        i % 2 == 0 ? 'Confirmed' : 'Pending',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  )))
        ],
      ),
    );
  }
}
