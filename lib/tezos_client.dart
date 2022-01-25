import 'package:dio/dio.dart';
import 'package:tezart/tezart.dart';
import 'package:tezos_dapp/faucet.dart';
import 'package:tezos_dapp/pet.dart';

const url = "https://hangzhounet.api.tez.ie";
const contractAddress = "KT1CEXMfX2NGbJgerP49uZNP87uacJDWRYyS";
const storage =
    "https://api.hangzhou2net.tzkt.io/v1/contracts/KT1CEXMfX2NGbJgerP49uZNP87uacJDWRYyS/storage";

Keystore keyStoreFromFaucet(Faucet faucet) {
  return Keystore.fromMnemonic(faucet.mnemonic,
      email: faucet.email, password: faucet.password);
}

Future<void> buy(Faucet faucet, Pet pet) async {
  print(pet);
  enableTezartLogger();
  final keyStore = keyStoreFromFaucet(faucet);
  final client = TezartClient(url);
  final contract = Contract(
      contractAddress: contractAddress, rpcInterface: client.rpcInterface);

  final callOperations = await contract.callOperation(
      entrypoint: 'buy',
      source: keyStore,
      params: pet.id,
      amount: pet.price,
      customFee: 400000,
      customGasLimit: 4000,
      customStorageLimit: 1000);

  await callOperations.execute();
}

Future<List<Pet>> fetchPets() async {
  List<Pet> pets = <Pet>[];
  try {
    Response response = await Dio().get(storage);
    Map petsList = response.data['pets'] as Map;
    pets = petsList.values.map((e) => Pet.fromJson(e)).toList();
  } catch (e) {
    print(e);
  }
  return pets;
}
