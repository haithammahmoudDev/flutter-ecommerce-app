import '../../../../personalization/data/models/address_entity.dart';
import '../../../../personalization/data/models/cart_item_entity.dart';
import '../../../../utils/constants/enums.dart';
   import '../../../../utils/helpers/helper_functions.dart';

class OrderEntity {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressEntity? address;
  final DateTime? deliveryDate;
  final List<CartItemEntity> items;

  const OrderEntity({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
  });

  /// دوال العرض المساعدة (Getters) مطابقة للـ Model
  String get formattedOrderDate => HelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? HelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  /// إنشاء كائن فارغ (Empty) مفيد في حالات الـ Initial State أو الـ Fallback
  static OrderEntity empty() => OrderEntity(
    id: '',
    userId: '',
    status: OrderStatus.processing,
    totalAmount: 0.0,
    orderDate: DateTime.now(),
    items: [],
  );
}