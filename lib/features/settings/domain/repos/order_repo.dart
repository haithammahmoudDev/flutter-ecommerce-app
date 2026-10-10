import 'package:dartz/dartz.dart';
import 'package:fit_store/common/errors/failure.dart';
import '../../data/models/order_model.dart';
import '../../../auth/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure,List<OrderEntity>>> fetchUserOrders();
  Future<Either<Failure, void>> saveOrder(OrderModel order, String userId);
}