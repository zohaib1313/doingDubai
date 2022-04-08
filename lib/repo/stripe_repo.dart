

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/network.dart';
import 'package:req_fun/req_fun.dart';

import '../config/keys/pref_keys.dart';

class StripeRepo{
  static Future<dynamic> stripeInfo() async {

    return await NetworkService().get(url: AppUrl.baseUrl + AppUrl.get_stripe_key).then((response) {
      if (response.statusCode == 200) {
        var encodedOrder = json.decode(response.body);
        return encodedOrder;
      } else {
        return [];
      }
    });

  }

  Future<dynamic> payForMyBooking(int bookingId) async {
    String token ="";
    Map data = {
      'booking_id': bookingId,
    };

    await Prefs.getPrefs().then((prefs) {
      token = prefs.getString(PrefKey.AUTHORIZATION)!;
    });

    String body = json.encode(data);
    var response = await Dio().post(AppUrl.baseUrl + AppUrl.create_payment_intent, data: body, options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept':'application/json',
          'Authorization': 'Bearer $token'
        }
    ));
    return response;

  }

  static Future<dynamic> confirmPayment(int? bookingID, String paymentId) async {

    Map<String, dynamic> data = Map<String, dynamic>();
    data['booking_id'] = bookingID;
    data['payment_method'] = 'Stripe';
    data['payment_reference'] = paymentId;

    String token ="";

    await Prefs.getPrefs().then((prefs) {
      token = prefs.getString(PrefKey.AUTHORIZATION)!;
    });

    String body = json.encode(data);
    var response = await Dio().post(AppUrl.baseUrl + AppUrl.confirm_payment, data: body, options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept':'application/json',
          'Authorization': 'Bearer $token'
        }
    ));
    return response;

    // return await NetworkService().post(url: AppUrl.baseUrl + AppUrl.confirm_payment, body: data).then((response) {
    //   if (response.statusCode == 200) {
    //     var encodedOrder = json.decode(response.body);
    //     return encodedOrder;
    //   } else {
    //     return [];
    //   }
    // });
  }

}