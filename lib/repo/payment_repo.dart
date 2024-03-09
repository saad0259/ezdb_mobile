import 'package:dio/dio.dart';

import '../models/payment.dart';
import 'api_helper.dart';

class PaymentRepo {
  static final PaymentRepo instance = PaymentRepo();
  final String paymentPath = '/payments';

  Future<String> createPaymentIntent(PaymentModel payment) {
    return executeSafely(() async {
      final Request request = Request(paymentPath, payment.toMap());
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
