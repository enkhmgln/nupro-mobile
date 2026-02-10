import 'package:nuPro/library/client/client.dart';

class PaymentApi extends IOClient {
  Future<IOResponse> paymentCreateInvoice({required int id}) async {
    final path = '/api/payments/$id/create-invoice';
    return sendPostRequest(path);
  }

  Future<IOResponse> paymentsDetailInfo({required int id}) async {
    final path = '/api/payments/$id';
    return sendGetRequest(path);
  }

  Future<IOResponse> paymentListHistory() async {
    const path = '/api/payments/list';
    return sendGetRequest(path);
  }

  Future<IOResponse> paymentCheck({required int id}) async {
    final path = '/api/payments/$id/check-status';
    return sendGetRequest(path);
  }
}
