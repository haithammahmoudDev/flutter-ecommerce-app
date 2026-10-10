import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CouponCode extends StatefulWidget {
  const CouponCode({super.key, this.onApplied, this.onRemoved});

  final ValueChanged<String>? onApplied;
  final VoidCallback? onRemoved;

  @override
  State<CouponCode> createState() => _CouponCodeState();
}

class _CouponCodeState extends State<CouponCode> {
  final _controller = TextEditingController();
  String? _appliedCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _appliedCode = code);
    widget.onApplied?.call(code);
  }

  void _remove() {
    setState(() => _appliedCode = null);
    _controller.clear();
    widget.onRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _appliedCode == null
          ? _buildInput(context, dark)
          : _buildApplied(context, dark, _appliedCode!),
    );
  }

  Widget _buildInput(BuildContext context, bool dark) {
    return Container(
      key: const ValueKey('input'),
      padding: const EdgeInsets.fromLTRB(AppSizes.md, 6, 6, 6),
      decoration: BoxDecoration(
        color: dark ? AppColors.dark : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(
          color: dark ? AppColors.darkerGrey : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.ticket_discount,
            size: 20,
            color: dark ? AppColors.iconPrimaryDark : AppColors.iconPrimaryLight,
          ),
          const SizedBox(width: AppSizes.spaceBtwItems),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _apply(),
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Have a promo code? Enter here',
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, __) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(84, 42),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: value.text.trim().isEmpty ? null : _apply,
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplied(BuildContext context, bool dark, String code) {
    return Container(
      key: const ValueKey('applied'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: dark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.tick_circle, size: 20, color: AppColors.success),
          const SizedBox(width: AppSizes.spaceBtwItems),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: code,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: '  applied',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: _remove,
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}