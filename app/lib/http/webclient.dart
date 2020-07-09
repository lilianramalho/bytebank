import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../models/contact.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request');
    print('url: ${data.baseUrl}');
    print('body: ${data.body}');
    print('headers: ${data.headers}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response');
    print('body: ${data.body}');
    print('headers: ${data.headers}');
    return data;
  }
}

Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);

const String baseUrl = 'http://192.168.1.53:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Response response =
      await client.get(baseUrl).timeout(Duration(seconds: 5));

  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = List();
  for (Map<String, dynamic> transactionsJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionsJson['contact'];
    Transaction transaction = Transaction(transactionsJson['value'],
        Contact(0, contactJson['name'], contactJson['accountNumber']));
    transactions.add(transaction);
  }
  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  final Map<String, dynamic> transactionsMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber,
    }
  };

  final String transactionJson = jsonEncode(transactionsMap);

  final Response response = await client.post(baseUrl,
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson);

  Map<String, dynamic> json = jsonDecode(response.body);

  final Map<String, dynamic> contactJson = json['contact'];
  return Transaction(
      json['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ));
}
