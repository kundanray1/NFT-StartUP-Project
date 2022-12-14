import 'package:flutter/material.dart';
import 'package:my_app/MyHomePage.dart';
import 'package:my_app/contract_linking.dart';
import 'package:my_app/createNFT_linking.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractNFTLinking>(
        create: (context) => ContractNFTLinking(),
        child: MaterialApp(
          title: 'Flutter Calculator',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'NFT'),
        ));
  }
}

// @override
// Widget build(BuildContext context) {
//   final contractLink = Provider.of<ContractLinking>(context);
//   final _messageController = TextEditingController();
//   return Scaffold(
//     appBar: AppBar(title: const Text('Flutter Dapp')),
//     body: Container(
//       padding: EdgeInsets.all(16),
//       child: Center(
//           child: contractLink.isLoading
//               ? const CircularProgressIndicator()
//               : SingleChildScrollView(
//                   child: Form(
//                       child: Column(
//                     children: <Widget>[
//                       Text(
//                           "welcome to hello worldApp${contractLink.deployedName}"),
//                       TextFormField(
//                         controller: _messageController,
//                         decoration: InputDecoration(hintText: "Enter Message"),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton(
//                           onPressed: () {
//                             contractLink.setMessage(_messageController.text);
//                             _messageController.clear();
//                           },
//                           child: Text("Set Text"))
//                     ],
//                   )),
//                 )),
//     ),
//   );
// }

