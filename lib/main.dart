// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tezos_dapp/faucet.dart';
import 'package:tezos_dapp/pet.dart';
import 'package:tezos_dapp/tezos_client.dart';

const masterAddress = 'tz1ZDY3u3VbqPh2J4TskgLuB6GKkJg11ftyx';
const clientAddress = 'tz1USeni48qDYnGiFWtnkwzDyeXzdWY2wuAp';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Pet Shop",
      home: PetList(),
    );
  }
}

class PetList extends StatefulWidget {
  const PetList({Key? key}) : super(key: key);

  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  List<Pet> pets = [];
  List<Pet> availablePets = [];
  List<Pet> boughtPets = [];
  bool isLoading = false;

  Faucet client = clientFaucet();

  void _fetchPets() async {
    setState(() {
      isLoading = true;
    });
    pets = await fetchPets();
    availablePets = pets.where((pet) => pet.owner == masterAddress).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pet Shop"),
          actions: [
            IconButton(onPressed: _fetchPets, icon: const Icon(Icons.refresh))
          ],
        ),
        body: Stack(
          children: [
            _buildPets(),
            if (isLoading) _buildSpinKit(),
          ],
        ));
  }

  Widget _buildPets() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: availablePets.length,
        itemBuilder: (context, i) {
          return _buildPetCard(availablePets[i]);
        });
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${pet.id}', style: const TextStyle(fontSize: 20)),
              Text('Name: ${WordPair.random().asPascalCase}',
                  style: const TextStyle(fontSize: 20)),
              Text('Price: ${pet.price}', style: const TextStyle(fontSize: 20)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        await buy(client, pet);
                        _fetchPets();
                        setState(() {
                          isLoading = false;
                        });
                      },
                child: const Text('Buy', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
          Image.network("https://images.dog.ceo/breeds/shiba/shiba-10.jpg",
              width: 150, height: 100)
        ],
      ),
    );
  }

  Widget _buildSpinKit() {
    return const SpinKitRing(color: Colors.blue);
  }
}
