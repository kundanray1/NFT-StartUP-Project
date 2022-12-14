import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/contract_linking.dart';
import 'package:my_app/createNFT_linking.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractNFTLinking>(context);
    final _messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // ignore: unnecessary_new
      body: new Container(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              color: Color.fromARGB(255, 255, 251, 216),
              alignment: Alignment.center,

              // ignore: prefer_const_constructors
              child: Text(
                'Create NFT',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter the Medicine Name To Create NFT'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        print('hi');
                        contractLink.createURI(_messageController.text);
                        _messageController.clear();
                      },
                      child: Text(
                        'CREATE',
                      ),
                      style: TextButton.styleFrom(
                          textStyle:
                              const TextStyle(decorationColor: Colors.white),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightBlue),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      child: new Container(
                        child: Column(
                          children: [
                            ...contractLink.deployedURIs!
                                .map((e) => VStack([
                                      e.text
                                          .make()
                                          .box
                                          .p20
                                          .width(400)
                                          .roundedSM
                                          .margin(
                                              EdgeInsets.symmetric(vertical: 5))
                                          .outerShadowXl
                                          .color(Vx.randomColor)
                                          .make()
                                    ]))
                                .toList(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
