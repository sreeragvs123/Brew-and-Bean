import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Shown only while the live connection is down.
class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeBloc, CafeState>(
      buildWhen: (previous, current) => previous.connected != current.connected,
      builder: (context, state) {
        if (state.connected) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(children: [
            SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Reconnecting to the cafe…'),
          ]),
        );
      },
    );
  }
}
