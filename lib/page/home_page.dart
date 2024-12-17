import 'package:bank/apiservice/api_service.dart';
import 'package:bank/model/transaction_model.dart';
import 'package:bank/model/user_model.dart';
import 'package:bank/page/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? user;
  List<TransactionModel>? transaction;
  final ApiService service = ApiService();

  Future<void> setUp() async {
    try {
      user = await service.getUserAccount();
      transaction = await service.getTransaction();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }

  @override
  void initState() {
    setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Abc'),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  var message = await service.logout();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninPage(),
                      ));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: EasyRefresh.builder(
        onRefresh: () async {
          await setUp();
          return IndicatorResult.success;
        },
        onLoad: () async {
          await setUp();
          return IndicatorResult.success;
        },
        childBuilder: (context, physics) {
          return ListView(
            physics: physics,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            children: [
              Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user?.name}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text('${user?.email}'),
                      const SizedBox(height: 8),
                      Text(
                        'Balance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${user?.balance}',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        var amoutControl = TextEditingController();
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: amoutControl,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                      labelText: 'Top Up Amount'),
                                ),
                                const SizedBox(height: 8),
                                FilledButton(
                                    onPressed: () async {
                                      try {
                                        int amount =
                                            int.parse(amoutControl.text);
                                        var message =
                                            await service.topUp(amount);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                        Navigator.pop(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    },
                                    child: const Text('Top Up')),
                              ],
                            ),
                          ),
                        );
                      },
                    ).then(
                      (value) => setState(() {
                        setUp();
                      }),
                    );
                  },
                  child: const Text('Top Up')),
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transaction?.length ?? 0,
                itemBuilder: (context, index) {
                  var transData = transaction![index];
                  return ListTile(
                    leading: transData.type == 'payment'
                        ? const Icon(Icons.arrow_upward)
                        : const Icon(Icons.arrow_downward),
                    title: Text(transData.amount.toString()),
                    trailing: Chip(label: Text(transData.type ?? 'unkown')),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
