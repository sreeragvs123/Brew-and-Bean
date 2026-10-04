import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/common/section_card.dart';
import 'package:frontend/domain/entities/cafe_order.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Customer: watch order status change live. Barista: move orders forward.
class OrdersSection extends StatelessWidget {
  final bool isBarista;

  const OrdersSection({super.key, required this.isBarista});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: isBarista ? 'Incoming orders' : 'Live order status',
      icon: Icons.receipt_long_outlined,
      child: BlocBuilder<CafeBloc, CafeState>(
        buildWhen: (previous, current) => previous.orders != current.orders,
        builder: (context, state) {
          if (state.orders.isEmpty) return const Text('No orders yet.');

          return Column(
            children: [
              for (final order in state.orders) _OrderRow(order: order, isBarista: isBarista),
            ],
          );
        },
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final CafeOrder order;
  final bool isBarista;

  const _OrderRow({required this.order, required this.isBarista});

  @override
  Widget build(BuildContext context) {
    final nextStatus = order.status.next;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('#${order.id} • ${order.customerName}'),
      subtitle: Text(order.items.map((line) => '${line.quantity}× ${line.name}').join(', ')),
      trailing: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _StatusChip(status: order.status),
          if (isBarista && nextStatus != null)
            OutlinedButton(
              onPressed: () => context.read<CafeBloc>().add(OrderStatusAdvanced(order)),
              child: Text('Mark ${nextStatus.label}'),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  Color get _color => switch (status) {
        OrderStatus.placed => Colors.blueGrey,
        OrderStatus.preparing => Colors.orange,
        OrderStatus.ready => Colors.green,
        OrderStatus.completed => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.label, style: TextStyle(color: _color, fontWeight: FontWeight.w600)),
    );
  }
}
