import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:in_flutter_time/feature/in_flutter_time/model/tag_data.dart';

TagData findClosestSmallerDateTime(
    List<TagData> tagDataList, DateTime targetDateTime) {
  TagData closestTag = tagDataList.first;

  for (final tagData in tagDataList) {
    if (tagData.date.isBefore(targetDateTime) &&
        tagData.date.isAfter(closestTag.date)) {
      closestTag = tagData;
    }
  }

  return closestTag;
}

Future<List<TagData>> readJsonAsset(String assetPath) async {
  final jsonStr = await rootBundle.loadString(assetPath);
  final jsonList = jsonDecode(jsonStr) as List<dynamic>;

  return jsonList.map((json) => TagData.fromJson(json)).toList();
}
