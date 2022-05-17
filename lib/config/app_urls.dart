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
  static const String personality_bookings = 'auto-recommended-bookings';
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

  static const String nightLifePicBaseUrl =
      'http://dubai.applypressure.co.uk/images/nightlifepics/';


  static const String brunchpicsPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/brunchpics/';


  static const String landMarkPicBaseUrl =
      'http://dubai.applypressure.co.uk/images/landmarkpics/';

  static String termsAndConditions='''1. When you book an accommodation with Doing Dubai, Doing Dubai is responsible for the Platform, but not the Travel Experience itself.

2. When you book a rental car or private or public transportation, Doing Dubai is responsible for the Platform, but not the Travel Experience itself.

3. We work with companies that provide local support services. They don’t:

    • Control or manage our platform.
    • Have their own Platform.
    • Have any legal or contractual relationship with you.
    • Provide Travel Experiences.
    • Represent us, enter into contracts, or accept legal documents in our name.
    • Operate as our “process or service agents.”

4. Our Platform
    • We take reasonable care in providing for our Platform, but we can’t guarantee that everything on it is accurate (we get information from the Service Providers). To the extent permitted by law, we can’t be held responsible for any errors, any interruptions, or any missing bits of information; though we will do everything we can to correct/fix them as soon as we can.

    • Our Platform is not a recommendation or endorsement of any Service Provider or its products, services, facilities, vehicles, etc.

    • To make a Booking, you need to create an Account. Make sure all your info (including payment and contact details) is correct and up to date. You’re responsible for anything that happens with your Account, so don’t let anyone else use it and keep your username and password secret.


5. Unless otherwise indicated, you need to be at least 16 to use the Platform.''';
}
