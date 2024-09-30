import 'package:dio/dio.dart';

import '../models/payment.dart';
import 'api_helper.dart';
import 'repo_constants.dart';

class PaymentRepo {
  static final PaymentRepo instance = PaymentRepo();
  final String paymentPath = '/payments';

  Future<String> createPaymentIntent(PaymentModel payment, String phone) {
    return executeSafely(() async {
      final Request request = Request(paymentPath, payment.toMap(phone));
      final Response response = await request.post(baseUrl);

      return response.data['url'] ?? '';
    });
  }

  //Get payments by userId
  Future<List<PaymentModel>> getPaymentsByUserId(int userId) {
    return executeSafely(() async {
      final Request request = Request('/payments/user/$userId', {});
      final Response response = await request.get(baseUrl);

      return (response.data as List)
          .map((payment) => PaymentModel.fromJson(payment))
          .toList();
    });
  }
}
