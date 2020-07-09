import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/centered_message.dart';
import 'package:bytebank/widgets/loarding.dart';
import 'package:flutter/material.dart';

import '../models/contact.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: Container(
          child: FutureBuilder<List<Transaction>>(
              future: Future.delayed(Duration(seconds: 1))
                  .then((value) => findAll()),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    Progress();
                    break;
                  case ConnectionState.waiting:
                    Progress();
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final List<Transaction> transactions = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final Transaction transaction = transactions[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.monetization_on),
                              title: Text(
                                transaction.value.toString(),
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                transaction.contact.accountNumber.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: transactions.length,
                      );
                    } else {
                      CenteredMessage('Não há dados');
                    }

                    break;

                  default:
                    CenteredMessage('Unknow error');
                    break;
                }
              }),
        ));
  }
}
