import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/gemini_service.dart';

class JijiScreen extends StatefulWidget {
  const JijiScreen({super.key});

  @override
  State<JijiScreen> createState() => _JijiScreenState();
}

class _JijiScreenState extends State<JijiScreen> {
  final TextEditingController _controller = TextEditingController();
  String answer = '';
  bool loading = false;

  void search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      loading = true;
      answer = '';
    });

    final res = await GeminiService.generateAnswer(query);

    setState(() {
      answer = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Jiji',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text('Your AI Friend'),
              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/avatar.png', height: 160),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _controller,
                onSubmitted: (_) => search(),
                decoration: InputDecoration(
                  hintText: 'Ask something...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: search,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      loading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Jiji says',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  answer.isEmpty
                                      ? 'Ask a question to start'
                                      : answer,
                                ),

                                const SizedBox(height: 20),

                                _resourceTile(
                                  icon: Icons.picture_as_pdf,
                                  title: 'AI Basics PPT',
                                  subtitle: 'PowerPoint Presentation',
                                  url: 'https://your-link-to-ppt',
                                  buttonText: 'Open PPT',
                                ),
                                const SizedBox(height: 12),
                                _resourceTile(
                                  icon: Icons.video_library,
                                  title: 'Intro to AI - YouTube',
                                  subtitle: 'Video Tutorial',
                                  url: 'https://youtube.com/',
                                  buttonText: 'Watch',
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resourceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
