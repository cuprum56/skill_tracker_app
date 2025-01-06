import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Импорт url_launcher

class LearningPage extends StatelessWidget {
  final String topicTitle;
  final List<String> links;

  const LearningPage({
    Key? key,
    required this.topicTitle,
    required this.links,
  }) : super(key: key);

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Не удалось открыть ссылку: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Обучение: $topicTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: links.isNotEmpty
            ? ListView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Ссылка ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(links[index]),
                      trailing: const Icon(Icons.open_in_browser),
                      onTap: () => _openLink(links[index]),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'Ссылки отсутствуют',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
