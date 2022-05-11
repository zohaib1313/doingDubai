import 'dart:async';

import 'package:dubai_screens/config/app_urls.dart';
import 'package:dubai_screens/config/dio/app_dio.dart';
import 'package:dubai_screens/config/keys/response_code.dart';
import 'package:dubai_screens/model/brunches_model.dart';
import 'package:dubai_screens/model/clubs_main_model.dart';
import 'package:dubai_screens/model/custom_booking_model.dart';
import 'package:dubai_screens/model/events_main_model.dart';
import 'package:dubai_screens/model/hotels_model.dart';
import 'package:dubai_screens/model/night_life_model.dart';
import 'package:dubai_screens/model/restaurant_main_model.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/land_mark_main_model.dart';
import 'model/transporter_main_model.dart';

class NetworkCalls {
  static Future<HotelsModel?> getOneHotel(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: AppUrl.getOneHotel + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['hotel'];
        HotelsModel hotelsModel = HotelsModel.fromJson(products);

        return Future.value(hotelsModel);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<ClubsMainModel?> getOneClub(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-club/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['club'];
        ClubsMainModel model = ClubsMainModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<BrunchesModel?> getOneBrunch(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-brunch/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['brunch'];
        BrunchesModel model = BrunchesModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<RestaurantMainModel?> getOneRestaurant(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-restaurant/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['restaurant'];
        RestaurantMainModel model = RestaurantMainModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<TransporterMainModel?> getOneTransporter(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-transporter/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['transporter'];
        TransporterMainModel model = TransporterMainModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<LandmarkMainModel?> getOneLandmark(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-landmark/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['landmark'];
        LandmarkMainModel model = LandmarkMainModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<EventsMainModel?> getOneEvent(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-event/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['event'];
        EventsMainModel model = EventsMainModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static Future<NightLifeModel?> getOneNightLife(
      String id, BuildContext context) async {
    try {
      var response = await AppDio(context).get(
        path: 'get-night-life/' + id,
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        var products = responseData['data']['club'];
        NightLifeModel model = NightLifeModel.fromJson(products);

        return Future.value(model);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }

  static FutureOr<bool>? showConfirmExit(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text('Confirm'),
        content: const Text('Are you sure to exit'),
        actions: <Widget>[
          FlatButton(
            child: const Text('NO'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: 16),
          FlatButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  static void openMap({required double lat, required double lng}) async {
    if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(lat, lng),
        title: '',
        description: '',
      );
    }
  }

  static Future<bool?> cancelBooking(
      CustomBookingModel model, BuildContext context) async {
    try {
      var response = await AppDio(context).delete(
        path: 'bookings-delete/' + model.id.toString(),
      );
      var responseStatusCode = response.statusCode;
      var responseData = response.data;
      if (responseStatusCode == StatusCode.OK) {
        return Future.value(true);
      } else {
        if (response.data != null) {
          errorDialog(context, 'Error', responseData['message'],
              closeOnBackPress: true, neutralButtonText: "OK");
        } else {
          errorDialog(
              context, "Error", "Something went wrong please try again later",
              closeOnBackPress: true, neutralButtonText: "OK");
        }
      }
    } catch (e, s) {
      print(
          "ERROR 0 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(e);
      print(
          "ERROR 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(s);
      print(
          "ERROR 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

      errorDialog(
          context, "Error", "Something went wrong please try again later",
          closeOnBackPress: true, neutralButtonText: "OK");
    }
    return null;
  }
}
