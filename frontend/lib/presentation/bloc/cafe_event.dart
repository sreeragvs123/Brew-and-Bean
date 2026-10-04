part of 'cafe_bloc.dart';

/// Things that happen in the UI (taps) or that the bloc triggers itself.
sealed class CafeEvent {
  const CafeEvent();
}

/// Page opened: start listening to the server.
class CafeStarted extends CafeEvent {
  const CafeStarted();
}

/// (Re)load menu and orders. Triggered every time the live connection opens.
class CafeRefreshRequested extends CafeEvent {
  const CafeRefreshRequested();
}

class CartItemAdded extends CafeEvent {
  final int itemId;
  const CartItemAdded(this.itemId);
}

class CartItemRemoved extends CafeEvent {
  final int itemId;
  const CartItemRemoved(this.itemId);
}

class OrderSubmitted extends CafeEvent {
  final String customerName;
  const OrderSubmitted(this.customerName);
}

class OrderStatusAdvanced extends CafeEvent {
  final CafeOrder order;
  const OrderStatusAdvanced(this.order);
}

class AvailabilityToggled extends CafeEvent {
  final CafeMenuItem item;
  const AvailabilityToggled(this.item);
}

class AnnouncementPosted extends CafeEvent {
  final String message;
  const AnnouncementPosted(this.message);
}
