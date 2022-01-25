class Pet {
  int id;
  int price;
  String owner;

  Pet(this.id, this.price, this.owner);

  Pet.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['petId']),
        price = int.parse(json['price']),
        owner = json['owner'] as String;

  Map<String, dynamic> toJson() {
    return {'petId': id, 'price': price, 'owner': owner};
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{$id of $owner costs $price}';
  }
}
