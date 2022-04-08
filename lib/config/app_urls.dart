class AppUrl {
  static const String baseUrl = "http://dubai.applypressure.co.uk/api/";

  static const String loginUrl = "login";
  static const String logoutUrl = "logout";
  static const String signUpUrl = "register";
  static const String updateProfile = "update-myprofile";
  static const String searchList = "search";
  static const String signUpAnonymousUrl = "/auth/anonymous";
  static const String fileUpload = "/files/upload";
  static const String contacts = "";
  static const String getAllHotels = "all-hotels";
  static const String submitPersonality = "submit-personality";
  static const String bookingsCreate = "bookings-create";
  static const String getMyBookings = 'all-my-bookings';
  static const String getLuxuryHotels = 'luxury-hotels';
  static const String getPopularHotels = 'popular-hotels';
  static var actionBooking = 'action-booking';
  static var getOneHotel = 'get-hotel/';
  static const String recommended_bookings = 'recommended-bookings';
  static const String bookingUpdate = 'bookings-update/';
  static const get_stripe_key = "get-stripe-key";
  static const create_payment_intent = "make-stripe-intent";
  static const confirm_payment =  "subscribe-plan";

  //////images//////
  static const String hotelsPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/hotelpics/';

  static const String restaurantPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/restaurantpics/';

  static const String eventPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/eventpics/';

  static const String clubPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/clubpics/';

  static const String transportPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/transportpics/';

  static const String landMarkPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/landmarkpics/';
}
