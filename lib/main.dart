import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _transaction = [
    Transactions(
      id: 't1',
      title: 'Novo Tênis de corrida',
      value: 300.10,
      date: DateTime.now(),
    ),
    Transactions(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.30,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Pessoais'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            child: Text('Gráfico'),
          ),
          Column(
            children: _transaction.map((tr) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      child: Text(tr.value.toString()),
                    ),
                    Column(
                      children: [
                        Text(tr.title),
                        Text(
                          tr.date.toString(),
                        )
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
