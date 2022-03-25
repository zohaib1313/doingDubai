import 'package:dubai_screens/model/hotels_model.dart';

import 'my_bookings_model.dart';

class HotelAndBookingModel {
  MyBookingsModel bookingsModel;
  HotelsModel hotelsModel;

  HotelAndBookingModel(
      {required this.bookingsModel, required this.hotelsModel});
}
