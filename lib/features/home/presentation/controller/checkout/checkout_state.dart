import 'package:equatable/equatable.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../checkout/models/payment_method_model.dart';

class CheckoutState extends Equatable {
  final PaymentMethodModel selectedPaymentMethod;

  const CheckoutState({
    required this.selectedPaymentMethod,
  });

  factory CheckoutState.initial() {
    return CheckoutState(
      selectedPaymentMethod: PaymentMethodModel(
        name: 'Paypal',
        image: TImages.paypal, // قم باستيراد TImages
      ),
    );
  }

  CheckoutState copyWith({
    PaymentMethodModel? selectedPaymentMethod,
  }) {
    return CheckoutState(
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [selectedPaymentMethod];
}