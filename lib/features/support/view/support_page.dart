import '../../../l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final messages = <(bool me, String text)>[(false, 'Hi! How can we help you today?')];
  final controller = TextEditingController();

  void _send() {
    final txt = controller.text.trim();
    if (txt.isEmpty) return;
    setState(() { messages.add((true, txt)); controller.clear(); });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() { messages.add((false, context.l10n.thanksReply)); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.support, showBack: false),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                final align = m.$1 ? Alignment.centerRight : Alignment.centerLeft;
                final bg = m.$1 ? Colors.deepOrange : const Color(0xFFF2F2F5);
                final fg = m.$1 ? Colors.white : Colors.black87;
                return Align(
                  alignment: align,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
                    child: Text(m.$2, style: TextStyle(color: fg)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: context.l10n.typeMessage,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _send, child: Text(context.l10n.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}