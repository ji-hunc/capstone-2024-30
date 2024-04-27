import 'dart:convert';

import 'package:capstone_front/models/api_response.dart';
import 'package:capstone_front/models/notice_model.dart';
import 'package:capstone_front/models/notice_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NoticeService {
  static String baseUrl = dotenv.get('BASE_URL');

  static Future<NoticesResponse> getNotices(
      int cursor, String type, String language) async {
    var query = 'type=$type&language=$language&cursor=$cursor';
    final url = Uri.parse('$baseUrl/announcement?$query');
    final response = await http.get(url);

    List<NoticeModel> noticeInstances = [];

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodedBody);
      final ApiResponse apiResponse = ApiResponse(
        success: jsonData['success'],
        message: jsonData['message'],
        response: jsonData['response'],
      );
      final List<dynamic> notices = apiResponse.response['announcements'];

      for (var notice in notices) {
        noticeInstances.add(NoticeModel.fromJson(notice));
      }

      var res = NoticesResponse(
        notices: noticeInstances,
        lastCursorId: jsonData.response['lastCursorId'],
        hasNext: jsonData.response['hasNext'],
      );

      return res;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load notices');
    }
  }

  static Future<NoticeModel> getNoticeDetailById(int id) async {
    final url = Uri.parse('$baseUrl/announcement/$id');
    final response = await http.get(url);

    final String decodedBody = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(decodedBody);
    final ApiResponse apiResponse = ApiResponse(
      success: jsonData['success'],
      message: jsonData['message'],
      response: jsonData['response'],
    );

    if (response.statusCode == 200) {
      var detail = NoticeModel.fromJson(apiResponse.response);

      return detail;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Request failed with status: ${apiResponse.message}.');
      throw Exception('Failed to load noticeDetail');
    }
  }
}
