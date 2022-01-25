import 'package:tezos_dapp/faucet.dart';
import 'package:tezos_dapp/pet.dart';
import 'package:tezos_dapp/tezos_client.dart';

const masterAddress = 'tz1ZDY3u3VbqPh2J4TskgLuB6GKkJg11ftyx';
const clientAddress = 'tz1USeni48qDYnGiFWtnkwzDyeXzdWY2wuAp';

Future<void> main() async {
  List<Pet> pets = await fetchPets();

  List<Pet> availablePets =
      pets.where((pet) => pet.owner == masterAddress).toList();

  Faucet client = clientFaucet();

  await buy(client, availablePets[0]);

  print("OK...");
}
