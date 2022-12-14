import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545";
  final String _privateKey =
      "c03a77c8f526bbfb69422866ed0061465699ed01e95b2bcfd5cb7bd1a4eec0cd";

  Web3Client? _web3client;
  bool isLoading = false;

  String? _abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;
  ContractFunction? greetings;
  ContractFunction? _setMessage;

  String? deployedName;
  ContractLinking() {
    setup();
  }

  setup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    String abiStringfile =
        await rootBundle.loadString('build/contracts/HelloWorld.json');
    final jsonAbi = jsonDecode(abiStringfile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    print(_abiCode);

    // _contractAddress =
    //     EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    // print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(
        "c03a77c8f526bbfb69422866ed0061465699ed01e95b2bcfd5cb7bd1a4eec0cd");
    print(_credentials);
    // _contractAddress = await _credentials?.extractAddress();
    _contractAddress =
        EthereumAddress.fromHex("0x5D7eAf66A0e3fc0968E60F76559112F95458C2e5");
    print(_contractAddress);
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, 'HelloWorld'), _contractAddress!);
    print(_contract);
    greetings = _contract!.function('greetings');
    // print(greetings);

    _setMessage = _contract!.function('setMessage');
    // print(_setMessage);
    getMessage();
  }

  getMessage() async {
    final mygreetings = await _web3client!
        .call(contract: _contract!, function: greetings!, params: []);

    deployedName = mygreetings[0];
    isLoading = false;
    notifyListeners();
  }

  setMessage(String messages) async {
    isLoading = true;
    notifyListeners();
    print(_credentials);
    print(_contract);
    print(messages);
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setMessage!,
            parameters: [messages]));
    getMessage();
  }
}
