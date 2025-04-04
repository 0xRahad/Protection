import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:protection/features/main/provider/website_repo_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final urlController = TextEditingController();
  final scaffoldKey = GlobalKey();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blockedWebsites = ref.watch(blockedWebsitesProvider);
    final websiteNotifier = ref.read(blockedWebsitesProvider.notifier);

    return ScaffoldPage(
      header: PageHeader(title: Text('Website Blocker')),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Block Websites", style: TextStyle(fontSize: 20)),
            Gap(10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextBox(
                    controller: urlController,
                    placeholder: "Enter website URL (e.g., facebook.com)",
                  ),
                ),
                Gap(10),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 33,
                    child: Button(
                      onPressed: () async {
                        final url = urlController.text.trim();

                        if (url.isEmpty) {
                          showAlert(
                            title: "Empty URL",
                            content: "Please enter a valid website URL.",
                          );
                          return;
                        }

                        if (!isValidUrl(url)) {
                          showAlert(
                            title: "Invalid URL Format",
                            content: 'Please enter a domain like "example.com"',
                          );
                          return;
                        }

                        await blockWebsite(url);
                        await flushDNS();
                        websiteNotifier.addWebsite(url);
                        urlController.clear();
                      },
                      child: Text("Block"),
                    ),
                  ),
                ),
              ],
            ),
            Gap(20),
            Expanded(
              child: ListView.builder(
                itemCount: blockedWebsites.length,
                itemBuilder: (context, index) {
                  final site = blockedWebsites[index];
                  return ListTile(
                    title: Text(site.url),
                    trailing: Button(
                      child: Text("Unblock"),
                      onPressed: () async {
                        await unblockWebsite(site.url);
                        await flushDNS();
                        websiteNotifier.removeWebsite(site.id);
                        showAlert(
                          title: "Unblocked",
                          content: "${site.url} has been unblocked.",
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> blockWebsite(String url) async {
    final file = _getHostsFile();
    if (!file.existsSync()) return;

    final domainVariants = [
      '127.0.0.1 $url',
      '127.0.0.1 www.$url',
      '::1 $url',
      '::1 www.$url',
    ];

    final content = await file.readAsString();
    final entriesToAdd =
        domainVariants.where((line) => !content.contains(line)).toList();

    if (entriesToAdd.isNotEmpty) {
      final newLines = entriesToAdd.join('\n');
      await file.writeAsString('\n$newLines', mode: FileMode.append);
      await flushDNS();
      showAlert(
        title: "Success",
        content: "$url and variants have been blocked.",
      );
    } else {
      showAlert(
        title: "Already Blocked",
        content: "All variants of $url are already blocked.",
      );
    }
  }

  Future<void> unblockWebsite(String url) async {
    final file = _getHostsFile();
    if (!file.existsSync()) return;

    final lines = await file.readAsLines();

    final filtered =
        lines
            .where(
              (line) =>
                  !(line.contains("127.0.0.1 $url") ||
                      line.contains("127.0.0.1 www.$url") ||
                      line.contains("::1 $url") ||
                      line.contains("::1 www.$url")),
            )
            .toList();

    await file.writeAsString(filtered.join('\n'));
  }

  File _getHostsFile() {
    if (Platform.isWindows) {
      return File(r'C:\Windows\System32\drivers\etc\hosts');
    } else {
      return File('/etc/hosts');
    }
  }

  Future<void> flushDNS() async {
    try {
      if (Platform.isLinux) {
        await Process.run('sudo', ['systemd-resolve', '--flush-caches']);
      } else if (Platform.isWindows) {
        await Process.run('ipconfig', ['/flushdns'], runInShell: true);
      }
    } catch (e) {
      showAlert(title: "Error", content: "Failed to flush DNS: $e");
    }
  }

  bool isValidUrl(String url) {
    final regex = RegExp(
      r'^(?!\-)(?:[a-zA-Z0-9\-]{1,63}(?<!\-)\.)+[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(url.trim().toLowerCase());
  }

  Future<void> showAlert({
    required String title,
    required String content,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => ContentDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              Button(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
