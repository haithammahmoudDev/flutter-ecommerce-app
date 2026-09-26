import 'package:fit_store/personalization/presentation/controllers/order/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../personalization/presentation/screens/address/order_list_items.dart';
import '../../../../../utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = 'orders=screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
        showActions: false,
        showSkipButton: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),

        child: TOrderListItems(),
      ), // Padding
    ); // Scaffold
  }
}
