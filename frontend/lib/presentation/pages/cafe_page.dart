import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/presentation/bloc/cafe_bloc.dart';
import 'package:frontend/presentation/widgets/announcement_banner.dart';
import 'package:frontend/presentation/widgets/announcement_composer.dart';
import 'package:frontend/presentation/widgets/cart_section.dart';
import 'package:frontend/presentation/widgets/connection_banner.dart';
import 'package:frontend/presentation/widgets/menu_section.dart';
import 'package:frontend/presentation/widgets/orders_section.dart';

enum ViewMode { customer, barista }

/// The only page of the app.
class CafePage extends StatefulWidget {
  const CafePage({super.key});

  @override
  State<CafePage> createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  // Only affects what is drawn, so it lives here instead of in the bloc.
  ViewMode _mode = ViewMode.customer;

  bool get _isBarista => _mode == ViewMode.barista;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CafeBloc, CafeState>(
      listenWhen: (previous, current) => current.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocBuilder<CafeBloc, CafeState>(
          buildWhen: (previous, current) => previous.loading != current.loading,
          builder: (context, state) {
            if (state.loading) return const _LoadingView();
            return _buildContent();
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Brew & Bean', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        SegmentedButton<ViewMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: ViewMode.customer, icon: Icon(Icons.person_outline), label: Text('Customer')),
            ButtonSegment(value: ViewMode.barista, icon: Icon(Icons.badge_outlined), label: Text('Barista')),
          ],
          selected: {_mode},
          onSelectionChanged: (selection) => setState(() => _mode = selection.first),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ConnectionBanner(),
              const AnnouncementBanner(),
              if (_isBarista) const AnnouncementComposer(),
              _buildSections(),
            ],
          ),
        ),
      ),
    );
  }

  /// Side by side on wide screens, stacked on phones.
  Widget _buildSections() {
    final menu = MenuSection(isBarista: _isBarista);
    final orders = Column(children: [
      if (!_isBarista) ...[const CartSection(), const SizedBox(height: 16)],
      OrdersSection(isBarista: _isBarista),
    ]);

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 800) {
        return Column(children: [menu, const SizedBox(height: 16), orders]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: menu),
          const SizedBox(width: 16),
          Expanded(flex: 6, child: orders),
        ],
      );
    });
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Connecting to Brew & Bean…'),
      ]),
    );
  }
}
