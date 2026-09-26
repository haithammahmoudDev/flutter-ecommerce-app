import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../domain/entities/product_entity.dart';
import '../../controller/all_products/all_products_cubit.dart';
import '../product_cards/product_card_vertical.dart';

class SortableProducts extends StatelessWidget {
  const SortableProducts({
    super.key,
    required this.products,
  });

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllProductsCubit, AllProductsState>(
      builder: (context, state) {
        // إذا قام المستخدم بالفرز نأخذ المنتجات المُرتبة من الـ state، وإلا نَعرض القائمة الممررة فوراً
        final displayProducts = state.products.isNotEmpty ? state.products : products;

        return Column(
          children: [
            /// Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
              value: state.selectedSortOption, // القيمة المخزنة في الـ state (الافتراضية Name)
              onChanged: (value) {
                if (value != null) {
                  context.read<AllProductsCubit>().sortProducts(value);
                }
              },
              items: ['Name', 'Higher Price', 'Lower Price', 'Sale', 'Newest', 'Popularity']
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Products Grid
            TGridLayout(
              itemCount: displayProducts.length,
              itemBuilder: (_, index) => TProductCardVertical(product: displayProducts[index]),
            ),
          ],
        );
      },
    );
  }
}

