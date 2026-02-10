import 'package:nuPro/library/client/io_client.dart';
import 'package:nuPro/library/client/io_response.dart';

class RatingApi extends IOClient {
  // Future<IOResponse> getRatingForCall({required int callId}) async {
  //   final url = '/api/ratings/check?call_id=$callId';
  //   return sendGetRequest(url);
  // }

  Future<IOResponse> submitRating({
    required int id,
    required int rating,
    required String comment,
  }) async {
    const url = '/api/ratings/submit';
    final data = {
      'call_id': id,
      'rating': rating,
      'comment': comment,
    };
    return sendPostRequest(url, data: data);
  }

  // Future<IOResponse> getRatingList({
  //   required int limit,
  //   required int page,
  // }) async {
  //   const url = '/api/ratings/list';
  //   return sendGetRequest(url);
  // }
}
