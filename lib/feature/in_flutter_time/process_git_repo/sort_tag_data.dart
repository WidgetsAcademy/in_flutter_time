import 'dart:convert';
import 'dart:io';

import 'package:in_flutter_time/feature/in_flutter_time/model/tag_data.dart';

Future<void> sortTagDataAndWriteToFile(String inFile, String outFile) async {
  final tagsData = await readJsonFile(inFile);
  final optimizedTagsData = sortTagData(tagsData);

  // Serialize the optimized data to JSON
  final optimizedJsonStr = jsonEncode(optimizedTagsData);
  File(outFile).writeAsStringSync(optimizedJsonStr);
}

Future<List<TagData>> readJsonFile(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    throw Exception('JSON file not found: $filePath');
  }

  final jsonStr = file.readAsStringSync();
  final jsonList = jsonDecode(jsonStr) as List<dynamic>;

  return jsonList.map((json) => TagData.fromJson(json)).toList();
}

List<TagData> sortTagData(List<TagData> tagDataList) {
  tagDataList.sort((a, b) => a.date.compareTo(b.date));
  return tagDataList;
}
