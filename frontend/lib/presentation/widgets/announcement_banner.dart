import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Yellow banner showing the latest announcement pushed by the cafe.
class AnnouncementBanner extends StatelessWidget {
  const AnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeBloc, CafeState>(
      buildWhen: (previous, current) => previous.announcement != current.announcement,
      builder: (context, state) {
        final message = state.announcement;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: message == null
              ? const SizedBox.shrink()
              : Container(
                  key: ValueKey(message),
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade400),
                  ),
                  child: Row(children: [
                    const Icon(Icons.campaign_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ]),
                ),
        );
      },
    );
  }
}
