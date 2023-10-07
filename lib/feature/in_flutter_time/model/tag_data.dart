class TagData {
  final DateTime date;
  final String tagName;

  TagData(this.date, this.tagName);

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      DateTime.parse(json['date']),
      json['tagName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'tagName': tagName,
      };
}
