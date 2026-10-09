import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/search_utils.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/search/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static const routeName = 'search_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>()..init(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openProduct(ProductEntity product) {
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().rememberQuery();
    Navigator.pushNamed(context, TRoutes.productDetails, arguments: product);
  }

  /// اختيار من آخر عمليات البحث أو من البراندات
  void _selectQuery(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.collapsed(offset: q.length);
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().submit(q);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.fromLTRB(
                TSizes.defaultSpace / 2,
                12,
                TSizes.defaultSpace,
                8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: isDark
                          ? TColors.iconPrimaryDark
                          : TColors.iconPrimaryLight,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: cubit.onQueryChanged,
                      onSubmitted: cubit.submit,
                      decoration: InputDecoration(
                        hintText: 'Search products or brands...',
                        filled: true,
                        fillColor: isDark
                            ? TColors.darkContainer
                            : TColors.lightContainer,
                        prefixIcon:
                        const Icon(Iconsax.search_normal, size: 20),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _controller,
                          builder: (_, value, __) => value.text.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                            icon: const Icon(Iconsax.close_circle,
                                size: 20),
                            color: TColors.iconSecondaryLight,
                            onPressed: () {
                              _controller.clear();
                              cubit.onQueryChanged('');
                            },
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

             Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SearchStatus.loading:
                      return const Center(
                        child:
                        CircularProgressIndicator(color: TColors.primary),
                      );

                    case SearchStatus.error:
                      return _MessageView(
                        icon: Iconsax.wifi_square,
                        title: 'Something went wrong',
                        subtitle: state.errorMessage,
                      );

                    case SearchStatus.success:
                      if (state.isEmptyResult) {
                        return _MessageView(
                          icon: Iconsax.search_status,
                          title: 'No results for "${state.query}"',
                          subtitle:
                          'Check the spelling or try a different keyword.',
                        );
                      }
                      return _ResultsList(
                        products: state.products,
                        query: state.query,
                        sort: state.sort,
                        isDark: isDark,
                        onTap: _openProduct,
                        onSort: cubit.setSort,
                      );

                    case SearchStatus.initial:
                      return _SuggestionsView(
                        recent: state.recent,
                        brands: state.topBrands,
                        onSelect: _selectQuery,
                        onRemove: cubit.removeRecent,
                        onClear: cubit.clearRecent,
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView({
    required this.recent,
    required this.brands,
    required this.onSelect,
    required this.onRemove,
    required this.onClear,
  });

  final List<String> recent;
  final List<String> brands;
  final void Function(String) onSelect;
  final void Function(String) onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (recent.isEmpty && brands.isEmpty) {
      return const _MessageView(
        icon: Iconsax.search_normal,
        title: 'Search for products',
        subtitle: 'Type a product name or brand to get started.',
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: 8,
      ),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Text('Recent searches', style: textTheme.titleMedium),
              const Spacer(),
              TextButton(onPressed: onClear, child: const Text('Clear all')),
            ],
          ),
          for (final q in recent)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Iconsax.clock,
                  size: 20, color: TColors.iconSecondaryLight),
              title: Text(q, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Iconsax.close_circle,
                    size: 18, color: TColors.iconSecondaryLight),
                onPressed: () => onRemove(q),
              ),
              onTap: () => onSelect(q),
            ),
          const SizedBox(height: 16),
        ],
        if (brands.isNotEmpty) ...[
          Text('Popular brands', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final b in brands)
                ActionChip(label: Text(b), onPressed: () => onSelect(b)),
            ],
          ),
        ],
      ],
    );
  }
}


class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.products,
    required this.query,
    required this.sort,
    required this.isDark,
    required this.onTap,
    required this.onSort,
  });

  final List<ProductEntity> products;
  final String query;
  final SearchSort sort;
  final bool isDark;
  final void Function(ProductEntity) onTap;
  final void Function(SearchSort) onSort;

  static const _labels = {
    SearchSort.relevance: 'Best match',
    SearchSort.priceLow: 'Price: low to high',
    SearchSort.priceHigh: 'Price: high to low',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace / 2,
          ),
          child: Row(
            children: [
              Text(
                '${products.length} results',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              PopupMenuButton<SearchSort>(
                initialValue: sort,
                onSelected: onSort,
                itemBuilder: (_) => [
                  for (final e in _labels.entries)
                    PopupMenuItem(value: e.key, child: Text(e.value)),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.sort, size: 18),
                      const SizedBox(width: 6),
                      Text(_labels[sort]!,
                          style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: 4,
            ),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ProductResultTile(
              product: products[i],
              query: query,
              isDark: isDark,
              onTap: () => onTap(products[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductResultTile extends StatelessWidget {
  const _ProductResultTile({
    required this.product,
    required this.query,
    required this.isDark,
    required this.onTap,
  });

  final ProductEntity product;
  final String query;
  final bool isDark;
  final VoidCallback onTap;

  String _fmt(double v) => '\$${v.toStringAsFixed(2)}';

  double? _minVariationPrice() {
    final variations = product.productVariations;
    if (variations == null || variations.isEmpty) return null;
    double? min;
    for (final v in variations) {
      final p =
      (v.salePrice != null && v.salePrice! > 0) ? v.salePrice! : v.price;
      if (min == null || p < min) min = p;
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isVariable = product.productType == 'variable';
    final minVar = isVariable ? _minVariationPrice() : null;

    final hasSale = !isVariable &&
        product.salePrice != null &&
        product.salePrice! > 0 &&
        product.salePrice! < product.price;

    final String priceText = minVar != null
        ? 'From ${_fmt(minVar)}'
        : _fmt(hasSale ? product.salePrice! : product.price);

    final outOfStock = !isVariable && product.stock <= 0;

    return InkWell(
      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkContainer : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          border: Border.all(
            color: isDark ? TColors.darkerGrey : TColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              child: SizedBox(
                width: 80,
                height: 80,
                child: TRoundedImage(
                  isNetworkImage: true,
                  imageUrl: product.thumbnail,
                  applyImageRadius: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    product.title,
                    query: query,
                    maxLines: 2,
                    style: textTheme.titleSmall,
                  ),
                  if (product.brand != null) ...[
                    const SizedBox(height: 2),
                    _HighlightText(
                      product.brand!.name,
                      query: query,
                      maxLines: 1,
                      style: textTheme.labelMedium
                          ?.copyWith(color: TColors.darkGrey),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        priceText,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? TColors.white : TColors.primary,
                        ),
                      ),
                      if (hasSale) ...[
                        const SizedBox(width: 8),
                        Text(
                          _fmt(product.price),
                          style: textTheme.labelMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: TColors.darkGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (outOfStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Out of Stock',
                        style: textTheme.labelSmall
                            ?.copyWith(color: TColors.error),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3,
                size: 18, color: TColors.iconSecondaryLight),
          ],
        ),
      ),
    );
  }
}

 class _HighlightText extends StatelessWidget {
  const _HighlightText(
      this.text, {
        required this.query,
        this.style,
        this.maxLines,
      });

  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;

  static final _parts = RegExp(r'\S+|\s+');

  @override
  Widget build(BuildContext context) {
    final qTokens = SearchUtils.tokenize(query);
    if (qTokens.isEmpty) {
      return Text(text,
          maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style);
    }

    final hitStyle = (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w800,
      color: TColors.primary,
    );

    final spans = <TextSpan>[];
    for (final m in _parts.allMatches(text)) {
      final word = m.group(0)!;
      final n = SearchUtils.normalize(word);
      final hit = n.isNotEmpty &&
          qTokens.any((q) =>
          n.startsWith(q) || (q.length >= 3 && n.contains(q)));
      spans.add(TextSpan(text: word, style: hit ? hitStyle : null));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: TColors.iconSecondaryLight),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}