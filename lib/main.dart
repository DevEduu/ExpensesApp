import 'package:expenses/components/Transaction_form.dart';
import 'package:expenses/components/Transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.purple[800],
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: GoogleFonts.openSans(
                fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _transaction = [];
  bool _showChart = false;
  List<Transactions> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, date) {
    final newTransaction = Transactions(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);
    setState(() {
      _transaction.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(Icons.add),
        )
      ],
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Switch(
                value: _showChart,
                onChanged: (value) {
                  setState(() {
                    _showChart = value;
                  });
                }),
            if (_showChart)
              SizedBox(
                height: availableHeight * 0.25,
                child: Chart(_recentTransactions),
              ),
            if (!_showChart)
              SizedBox(
                height: availableHeight * 0.75,
                child: TransactionList(_transaction, _deleteTransaction),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
