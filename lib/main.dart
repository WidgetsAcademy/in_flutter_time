import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_flutter_time/feature/in_flutter_time/in_flutter_time.dart';
import 'package:in_flutter_time/feature/in_flutter_time/model/tag_data.dart';

late List<TagData> tagDataList;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tagDataList = await readJsonAsset('assets/tag_data.json');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Material(
          child: Center(
        child: SingleChildScrollView(
          child: TimeForm(),
        ),
      )),
    );
  }
}

class TimeForm extends StatefulWidget {
  const TimeForm({
    super.key,
  });

  @override
  State<TimeForm> createState() => _TimeFormState();
}

class _TimeFormState extends State<TimeForm> {
  final TextEditingController _controller =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Convert a date into a Flutter release tag',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              const Text(
                  'Convert a date into a flutter stable version. This can be a fun thing to do when you are giving a talk and want to spice up your bio with dating it in "Flutter Time".'),
              const SizedBox(height: 16),
              TextField(
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(
                  //hintText: 'Enter a date',
                  labelText: 'One date per line (YYYY-MM-DD)',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final List<String> lines = _controller.text.split('\n');
                  final List<String> tags = lines
                      .map((line) => line.trim())
                      .where((line) => line.isNotEmpty)
                      .map((line) => convertDateToTag(line))
                      .toList();
                  final String result = tags.join('\n');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SelectableText(result),
                      actions: [
                        // Copy to clipboard
                        TextButton(
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: result));
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Copy to clipboard'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Convert'),
              ),
              const SizedBox(height: 16),
              const Text("Created by Damian Bast with \u{1F499} in Hamburg"),
            ],
          ),
        ),
      ),
    );
  }

  String convertDateToTag(String line) {
    final DateTime date = DateTime.parse(line);
    final TagData tagData = findClosestSmallerDateTime(tagDataList, date);
    return '${tagData.tagName} matches $line with a create date of ${tagData.date.toString().substring(0, 10)}';
  }
}
