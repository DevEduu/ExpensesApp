import 'package:expenses/components/Transaction_form.dart';
import 'package:expenses/components/Transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
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
    final mediaQuery = MediaQuery.of(context);
    bool _islandscape = mediaQuery.orientation == Orientation.landscape;
    AppBar appBar = AppBar(
      centerTitle: true,
      actions: [
        if (_islandscape)
          IconButton(
              icon: Icon(
                  _showChart ? Icons.show_chart_rounded : Icons.list_rounded),
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              }),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontSize: 20 * mediaQuery.textScaleFactor,
        ),
      ),
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !_islandscape)
              SizedBox(
                height: _islandscape
                    ? availableHeight * 0.70
                    : availableHeight * 0.25,
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !_islandscape)
              SizedBox(
                height: _islandscape
                    ? availableHeight * 0.99
                    : availableHeight * 0.75,
                child: TransactionList(_transaction, _deleteTransaction),
              ),
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _openTransactionFormModal(context),
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
