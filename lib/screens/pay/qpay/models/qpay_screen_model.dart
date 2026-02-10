import 'package:nuPro/screens/pay/qpay/models/qpay_model.dart';

class QpayScreenModel {
  final String title;
  final String invoice;
  final List<QpayModel> urls;
  final List<QpayInfoModel> info;
  final int paymentID;

  QpayScreenModel({
    required this.title,
    required this.invoice,
    required this.info,
    required this.urls,
    required this.paymentID,
  });
}

class QpayInfoModel {
  final String title;
  final String value;

  QpayInfoModel({
    required this.title,
    required this.value,
  });
}
