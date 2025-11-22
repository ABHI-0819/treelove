import '../../core/config/constants/enum/order_enum.dart';

class OrderFlowState {
  static final OrderFlowState _instance = OrderFlowState._internal();
  factory OrderFlowState() => _instance;
  OrderFlowState._internal();

  OrderType orderType = OrderType.normal;

  void reset() {
    orderType = OrderType.normal;
  }
}

