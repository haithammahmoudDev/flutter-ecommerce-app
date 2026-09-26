import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_store/common/preferences/loacal_storage_service.dart';

import '../../../../../common/errors/failure.dart';
import '../../../../../personalization/data/models/order_model.dart';
import '../../../../auth/domain/entities/order_entity.dart';
import 'order_repo.dart';

 class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<Either<Failure,List<OrderEntity>>> fetchUserOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes.';
      }

      final result =
      await _db.collection('Users').doc(userId).collection('Orders').get();
      final List<OrderModel> ordersList =
      result.docs.map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot)).toList();
      final List<OrderEntity> ordersEntity = ordersList.map((e)=> e.toEntity()).toList();
       return right(ordersEntity);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> saveOrder(OrderModel order, String userId) async {
    try {
      await _db.collection('Users')
          .doc(userId).collection('Orders').add(order.toJson());
      return const Right(null);

    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}