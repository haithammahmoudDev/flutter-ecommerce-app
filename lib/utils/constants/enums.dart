/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

enum AppRole { admin, user }

enum Role { admin, manager, operator, fleetOwner, fleetManager, fleetOperator, driver, user, unknown }

enum ChatType { support }

enum ChatMessageStatus { sending, sent, delivered, read, failed }

enum VerificationStatus { unknown, pending, submitted, underReview, approved, rejected }

enum TextSizes { small, medium, large }

enum OrderStatus {processing, shipped, delivered, pending,cancelled}

enum PaymentMethods {paypal, googlepay, applePay, visa, masterCard, creditCard, paystack , razorpay, paytm}

/// 1. نوع المنتج (منفرد أو يحتوي على خيارات ومتغيرات)
enum ProductType { single, variable }
enum ProductsStatus { initial, loading, success, error }



