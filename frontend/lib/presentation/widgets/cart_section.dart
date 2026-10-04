import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/common/formatters.dart';
import 'package:frontend/common/section_card.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Customer cart with the "Place order" button.
class CartSection extends StatefulWidget {
  const CartSection({super.key});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Your order',
      icon: Icons.shopping_bag_outlined,
      child: BlocBuilder<CafeBloc, CafeState>(
        buildWhen: (previous, current) =>
            previous.cart != current.cart ||
            previous.menu != current.menu ||
            previous.placingOrder != current.placingOrder,
        builder: (context, state) {
          if (state.cart.isEmpty) {
            return const Text('Your cart is empty. Add something from the menu.');
          }
          return Column(children: [
            for (final entry in state.cart.entries) _CartRow(itemId: entry.key, quantity: entry.value),
            const Divider(),
            _TotalRow(total: state.cartTotal),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name for the order',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.placingOrder
                    ? null
                    : () => context.read<CafeBloc>().add(OrderSubmitted(_nameController.text.trim())),
                child: state.placingOrder
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Place order'),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final int itemId;
  final int quantity;

  const _CartRow({required this.itemId, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CafeBloc>();
    final item = bloc.state.menu.firstWhere((m) => m.id == itemId);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(item.name),
      subtitle: Text(formatPrice(item.price * quantity)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => bloc.add(CartItemRemoved(itemId)),
        ),
        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => bloc.add(CartItemAdded(itemId)),
        ),
      ]),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final double total;

  const _TotalRow({required this.total});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontWeight: FontWeight.bold);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Total', style: style),
      Text(formatPrice(total), style: style),
    ]);
  }
}
