import 'package:flutter/material.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../address/widgets/order_list_items.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
        showActions: false,
        showSkipButton: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace),

        child: OrderListItems(),
      ), // Padding
    ); // Scaffold
  }
}
