import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/common/section_card.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Barista-only box for sending a message to every screen.
class AnnouncementComposer extends StatefulWidget {
  const AnnouncementComposer({super.key});

  @override
  State<AnnouncementComposer> createState() => _AnnouncementComposerState();
}

class _AnnouncementComposerState extends State<AnnouncementComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<CafeBloc>().add(AnnouncementPosted(text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Broadcast to all screens',
        icon: Icons.podcasts,
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(
                hintText: 'e.g. Cold brew is 20% off until 5 PM',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _send,
            icon: const Icon(Icons.send),
            label: const Text('Send'),
          ),
        ]),
      ),
    );
  }
}
