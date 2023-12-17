class KeyValue {
  final String key;
  final String value;

  KeyValue({required this.key, required this.value});
}

extension ListToKeyValue on Map<String, dynamic> {
  List<KeyValue> list({bool interchange = false}) {
    List<KeyValue> list = [];
    for (final entry in entries) {
      list.add(
        KeyValue(
          key: interchange ? entry.value.toString() : entry.key.toString(),
          value: interchange ? entry.key.toString() : entry.value.toString(),
        ),
      );
    }
    return list;
  }
}
