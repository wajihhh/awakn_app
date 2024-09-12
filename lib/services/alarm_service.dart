import 'dart:developer';

import 'package:awakn/models/alarm_feed_response.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/models/alarm_setup_model.dart';
import 'package:awakn/models/category_response.dart';
import 'package:awakn/models/objectives_response.dart';
import 'package:awakn/services/exception_handler.dart';
import 'package:awakn/services/http/api.dart';
import 'package:awakn/services/http/api_constants.dart';
import 'package:awakn/utils/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmService {
  final Api _api = Api();

  Future<List<AlarmFeed>> getAlarmFeedList(List<String> ids) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Response response = await dio.post(
        ApiConstants.getFeedTimeline,
        data: {
          "objective_id": ids,
        },
      );
      return AlarmFeed.fromJsonList(response.data);
    } on Exception catch (e) {
      debugPrint(e.toString());
      // Not to show error on API failure
      // ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<AlarmSetupResponse?> setupAlarm() async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      var response = await dio.get(ApiConstants.setupAlarm);
      AlarmSetupResponse result = AlarmSetupResponse.fromJson(response.data);
      globalCache.alarmSetupResponse = result;
      return result;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<AlarmObject?> getAlarmById(String? id) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      var response = await dio.get('${ApiConstants.alarms}/$id');
      AlarmObject alarm = AlarmObject.fromJson(response.data);

      return alarm;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<AlarmObject>> getAlarmsList() async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Response response = await dio.get(
        ApiConstants.alarms,
      );
      return AlarmObject.fromJsonList(response.data);
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<CategoryDto>> getCategoriesList() async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Response response = await dio.get(
        ApiConstants.category,
      );
      return CategoryDto.fromJsonList(response.data);
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<Objective?> addObjective(
    // String title,
    String overview,
  ) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Response response = await dio.post(
        ApiConstants.objectives,
        data: {
          "overview": overview,
          // "title": title,
        },
      );
      return Objective.fromJson(response.data);
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Objective?> getObjectiveById(String? id) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      var response = await dio.get('${ApiConstants.objectives}/$id');
      Objective objective = Objective.fromJson(response.data);
      return objective;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<ObjectivesResponse?> getObjectivesList({
    String? categoryId,
    String? search,
  }) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Map<String, dynamic>? queryParameters = {};
      if (categoryId != null) {
        queryParameters['category'] = categoryId;
      }
      if (search != null) {
        queryParameters['search'] = search;
      }
      Response response = await dio.get(ApiConstants.objectives,
          queryParameters: queryParameters);
      return ObjectivesResponse.fromJson(response.data);
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> addFavouriteObjective(String id) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.post(
        ApiConstants.favourite,
        data: {"objectiveId": id},
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> removeFavouriteObjective(String id) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.delete(
        ApiConstants.favourite,
        data: {
          "objectiveId": id,
        },
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<List<Objective>> getFavouriteObjectivesList() async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      Response response = await dio.get(
        ApiConstants.favourite,
      );
      return Objective.fromJsonList(response.data);
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<AlarmObject?> addAlarm({
    required String title,
    required String note,
    required bool repeat,
    required List colorTags,
    required String time,
    required bool status,
    required String type,
    required List<String> objectiveIds,
    required List interval,
    required bool isUpdate,
    required String tune,
    String? alarmId,
  }) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      var response = isUpdate
          ? await dio.patch(
              '${ApiConstants.alarms}/$alarmId',
              data: {
                "tune": tune,
                "title": title, // "string",
                "note": note, // "string",
                "repeat": repeat, //true,
                "color_tags": colorTags, //["string"],
                "time": time, // "2023-12-27T02:22:06.830Z",
                "status": status, // true,
                "type": type, // "wake-up",
                "objectiveId": objectiveIds, //["string"],
                "interval": interval,
              },
            )
          : await dio.post(
              ApiConstants.alarms,
              data: {
                "title": title, // "string",
                "note": note, // "string",
                "repeat": repeat, //true,
                "color_tags": colorTags, //["string"],
                "time": time, // "2023-12-27T02:22:06.830Z",
                "status": status, // true,
                "type": type, // "wake-up",
                "objectiveId": objectiveIds, //["string"],
                "interval": interval,
                "tune": tune,
              },
            );
      AlarmObject alarm = AlarmObject.fromJson(response.data);
      return alarm;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> deleteAlarm(String id) async {
    try {
      Dio dio = await _api.createDio(hasAuth: true);
      await dio.delete(
        '${ApiConstants.alarms}/$id',
      );
      return true;
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
