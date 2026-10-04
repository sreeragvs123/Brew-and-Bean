import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/common/formatters.dart';
import 'package:frontend/common/section_card.dart';
import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';

/// Customer: tap + to add to the cart. Barista: switch items on or off.
class MenuSection extends StatelessWidget {
  final bool isBarista;

  const MenuSection({super.key, required this.isBarista});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: isBarista ? 'Menu availability' : 'Menu',
      icon: Icons.local_cafe_outlined,
      child: BlocBuilder<CafeBloc, CafeState>(
        buildWhen: (previous, current) => previous.menu != current.menu,
        builder: (context, state) {
          return Column(
            children: [for (final item in state.menu) _MenuRow(item: item, isBarista: isBarista)],
          );
        },
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final CafeMenuItem item;
  final bool isBarista;

  const _MenuRow({required this.item, required this.isBarista});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CafeBloc>();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: item.available ? null : TextDecoration.lineThrough,
          color: item.available ? null : Colors.grey,
        ),
      ),
      subtitle: Text('${item.category}  •  ${formatPrice(item.price)}'),
      trailing: isBarista
          ? Switch(
              value: item.available,
              onChanged: (_) => bloc.add(AvailabilityToggled(item)),
            )
          : item.available
              ? IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  onPressed: () => bloc.add(CartItemAdded(item.id)),
                )
              : const Chip(label: Text('Sold out')),
    );
  }
}
