import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractNFTLinking extends ChangeNotifier {
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
  ContractFunction? _tokenId;
  ContractFunction? _setMessage;
  ContractFunction? _CreateTokenURI;
  // ContractFunction? _GetTokenURI;
  ContractFunction? _GetAllURIs;
  List<String>? deployedURIs;
  String? deployedURI;
  ContractNFTLinking() {
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
        await rootBundle.loadString('build/contracts/CreateNFT.json');
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
        EthereumAddress.fromHex("0x56Af80F9FA2aB54E307b72Ea47b996e40D722AE0");
    print(_contractAddress);
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, 'CreateNFT'), _contractAddress!);
    print(_contract);
    _tokenId = _contract!.function('_tokenId');
    _GetAllURIs = _contract!.function('getAllTokenURIs');
    _CreateTokenURI = _contract!.function('CreateTokenURI');
    print(_tokenId);

    // _CreateTokenURI = _contract!.function('CreateTokenURI');
    // _GetTokenURI = _contract!.function('GetTokenURI');

    _GetAllURIs = _contract!.function('getAllTokenURIs');

    // print(_setMessage);
    getAllURI();
  }

  getAllURI() async {
    final URIS = await _web3client!
        .call(contract: _contract!, function: _GetAllURIs!, params: []);

    deployedURIs = (URIS[0] as List<dynamic>).map((e) => e.toString()).toList();
    print(deployedURIs);
    // deployedURI = URIS[0];
    isLoading = false;
    notifyListeners();
  }

  createURI(String uri) async {
    isLoading = true;
    notifyListeners();
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _CreateTokenURI!,
            parameters: [uri]));
    getAllURI();
  }

  // setMessage(String messages) async {
  //   isLoading = true;
  //   notifyListeners();
  //   print(_credentials);
  //   print(_contract);
  //   print(messages);
  //   await _web3client!.sendTransaction(
  //       _credentials!,
  //       Transaction.callContract(
  //           contract: _contract!,
  //           function: _setMessage!,
  //           parameters: [messages]));
  // }
}
