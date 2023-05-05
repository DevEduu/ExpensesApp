import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final void Function(String) onRemove;
  const TransactionList(this.transactions, this.onRemove, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraits) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: transactions.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      const Text('Nem uma transação cadastrada'),
                      SizedBox(
                        height: constraits.maxHeight * 0.05,
                      ),
                      SizedBox(
                        height: constraits.maxHeight * 0.50,
                        child: Image.asset(
                          'lib/assets/img/waiting.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (ctx, index) {
                    final tr = transactions[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 5.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FittedBox(
                              child: Text(
                                'R\$${tr.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          tr.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          DateFormat('d MMM y').format(tr.date),
                        ),
                        trailing: MediaQuery.of(context).size.width > 480
                            ? TextButton.icon(
                                onPressed: () => onRemove(tr.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Excluir',
                                  style: TextStyle(color: Colors.red),
                                ))
                            : IconButton(
                                onPressed: () => onRemove(tr.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    );
                  }),
        );
      },
    );
  }
}
