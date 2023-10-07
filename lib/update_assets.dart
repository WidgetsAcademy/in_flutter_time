import 'dart:convert';
import 'dart:io';

import 'package:in_flutter_time/feature/in_flutter_time/model/tag_data.dart';
import 'package:in_flutter_time/feature/in_flutter_time/process_git_repo/process_git_repo.dart';
import 'package:in_flutter_time/feature/in_flutter_time/process_git_repo/sort_tag_data.dart';

Future<void> main() async {
  const repoPath = '/Users/damianbast/src/github.com/flutter/flutter';
  const outFilePath = 'assets/tag_data.json';

  File(outFilePath).writeAsStringSync('');
  final tags = await getGitTags(repoPath);
  final semverTags = filterSemanticVersionTags(tags);
  final tagDates = await getTagCreationDates(semverTags, repoPath);

  final tagMap = Map<DateTime, String>.fromEntries(tagDates.entries);
  final tagDataList =
      tagMap.entries.map((entry) => TagData(entry.key, entry.value)).toList();

  // sort by date
  final sortedTagDates = sortTagData(tagDataList);
  // Serialize the data to JSON
  final jsonStr = jsonEncode(sortedTagDates);
  File(outFilePath).writeAsStringSync(jsonStr);
}
