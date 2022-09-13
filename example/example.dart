import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:remitta_flutter_inline/remitta_flutter_inline.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Example Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _controller;
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example App')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Enter RRR'),
                controller: _controller,
                validator: (_) => _controller.text.isEmpty ? 'RRR is required' : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final FormState? form = _formKey.currentState;
                if (form!.validate()) {
                  _initializePayment(context, _controller.text);
                }
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  _initializePayment(BuildContext context, String rrr) async {
    PaymentRequest request = PaymentRequest(
      environment: RemittaEnvironment.demo,
      rrr: rrr,
      key: 'enter your key here',
    );

    RemittaPayment remitta = RemittaInlinePayment(
      buildContext: context,
      paymentRequest: request,
      customizer: Customizer(),
    );

    PaymentResponse response = await remitta.initiatePayment();
    if (response.code != null && response.code == '00') {
      // transaction successful
      // verify transaction status before providing value
    } else {
      // transaction not successful.
    }
    log(response.toString());
  }
}
