class Prize{
  final String id;
  final String name;

  Prize({this.id, this.name});

  factory Prize.fromJson(Map<String, dynamic> parsedJson) {
    Prize newPrize = new Prize(
      id: parsedJson['_id'],
      name: parsedJson['name']
    );
    return newPrize;
  }
}