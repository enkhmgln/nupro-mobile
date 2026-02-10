import 'package:g_json/g_json.dart';

class FagsModel {
  final int id;
  final String question;
  final String answer;

  FagsModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        question = json['question'].stringValue,
        answer = json['answer'].stringValue;
}
