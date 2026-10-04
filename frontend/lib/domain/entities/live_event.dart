import 'package:frontend/domain/entities/cafe_menu_item.dart';
import 'package:frontend/domain/entities/cafe_order.dart';

/// Everything the server can push to the app.
sealed class LiveEvent {
  const LiveEvent();
}

class MenuUpdated extends LiveEvent {
  final CafeMenuItem item;
  const MenuUpdated(this.item);
}

class OrderUpdated extends LiveEvent {
  final CafeOrder order;
  const OrderUpdated(this.order);
}

class AnnouncementReceived extends LiveEvent {
  final String message;
  const AnnouncementReceived(this.message);
}

/// The live connection to the server is open.
class StreamConnected extends LiveEvent {
  const StreamConnected();
}

/// The live connection dropped. The app keeps retrying on its own.
class StreamDisconnected extends LiveEvent {
  const StreamDisconnected();
}
