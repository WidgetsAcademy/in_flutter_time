// This is not meant to be run on a client, print is ok here
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:in_flutter_time/feature/in_flutter_time/model/tag_data.dart';

/// script to read the tags from the flutter repo and write them to a file
Future<void> processRepositoryAndWriteToFile({
  /// the path to the flutter repo on the filesystem
  required String repoPath,

  /// the path to the file to write the tags to
  required String outFilePath,
}) async {
  final tags = await getGitTags(repoPath);
  final semverTags = filterSemanticVersionTags(tags);
  final tagDates = await getTagCreationDates(semverTags, repoPath);

  final tagMap = Map<DateTime, String>.fromEntries(tagDates.entries);
  final tagDataList =
      tagMap.entries.map((entry) => TagData(entry.key, entry.value)).toList();

  // Serialize the data to JSON
  final jsonStr = jsonEncode(tagDataList);
  File(outFilePath).writeAsStringSync(jsonStr);
}

/// get all tags for a git repo on the file system
Future<List<String>> getGitTags(String repoPath) async {
  print('Getting git tags...');
  final result = await Process.run('git', ['-C', repoPath, 'tag', '--list']);
  print('Got git tags');
  if (result.exitCode == 0) {
    final tags = LineSplitter.split(result.stdout as String)
        .where((line) => line.isNotEmpty)
        .toList();
    return tags;
  } else {
    throw Exception('Failed to get Git tags: ${result.stderr}');
  }
}

/// get the creation dates for given tags on the file system
Future<Map<DateTime, String>> getTagCreationDates(
    List<String> tags, String repoPath) async {
  final dateMap = <DateTime, String>{};

  for (final tag in tags) {
    final result = await Process.run(
      'git',
      ['-C', repoPath, 'log', '-1', '--format=%ai', tag],
    );

    if (result.exitCode == 0) {
      final dateStr = result.stdout.trim();
      final date = DateTime.parse(dateStr);
      dateMap[date] = tag;
    } else {
      print('Failed to get creation date for tag $tag');
    }
  }

  return dateMap;
}

/// return tags which are in the format: 1.2.3 or v1.2.3 without metadata
List<String> filterSemanticVersionTags(List<String> tags) {
  final semverTags = <String>[];

  for (final tag in tags) {
    if (isValidSemverTag(tag)) {
      semverTags.add(tag);
    }
  }

  return semverTags;
}

/// accept tags which are in the format: 1.2.3 or v1.2.3 without metadata
bool isValidSemverTag(String tag) {
  final semverPattern =
      RegExp(r'^v?\d+\.\d+\.\d+$'); // Matches versions like 1.2.3 or v1.2.3

  // Additional checks to exclude non-semver patterns
  if (!semverPattern.hasMatch(tag)) {
    return false;
  }

  // Exclude tags with pre-release or build metadata
  if (tag.contains('-') || tag.contains('+')) {
    return false;
  }

  return true;
}
