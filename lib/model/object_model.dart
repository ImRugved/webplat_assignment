class ObjectItem {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  ObjectItem({required this.id, required this.name, this.data});

  factory ObjectItem.fromJson(Map<String, dynamic> json) {
    return ObjectItem(id: json['id'], name: json['name'], data: json['data']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'data': data};
  }

  // Helper methods to extract common data fields
  String? get color =>
      data?['color'] ?? data?['Color'] ?? data?['Strap Colour'];
  String? get capacity => data?['capacity'] ?? data?['Capacity'];
  String? get price => data?['price']?.toString() ?? data?['Price'];
  String? get generation => data?['generation'] ?? data?['Generation'];
  String? get year => data?['year']?.toString();
  String? get cpuModel => data?['CPU model'];
  String? get hardDiskSize => data?['Hard disk size'];
  String? get caseSize => data?['Case Size'];
  String? get description => data?['Description'];
  String? get screenSize => data?['Screen size']?.toString();

  // Get all data as formatted string for display
  String get formattedData {
    if (data == null) return 'No additional data';

    List<String> dataItems = [];

    if (color != null) dataItems.add('Color: $color');
    if (capacity != null) dataItems.add('Capacity: $capacity');
    if (price != null) dataItems.add('Price: \$$price');
    if (generation != null) dataItems.add('Generation: $generation');
    if (year != null) dataItems.add('Year: $year');
    if (cpuModel != null) dataItems.add('CPU: $cpuModel');
    if (hardDiskSize != null) dataItems.add('Storage: $hardDiskSize');
    if (caseSize != null) dataItems.add('Case Size: $caseSize');
    if (description != null) dataItems.add('Description: $description');
    if (screenSize != null) dataItems.add('Screen Size: ${screenSize}"');

    return dataItems.isEmpty ? 'No additional data' : dataItems.join(', ');
  }
}
