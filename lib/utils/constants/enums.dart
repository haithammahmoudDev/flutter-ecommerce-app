
enum AppRole { admin, user }

enum Role { admin, manager, operator, fleetOwner, fleetManager, fleetOperator, driver, user, unknown }

enum ChatType { support }

// enum ChatMessageStatus { sending, sent, delivered, read, failed }

// enum VerificationStatus { unknown, pending, submitted, underReview, approved, rejected }

enum TextSizes { small, medium, large }

enum OrderStatus {processing, shipped, delivered, pending,cancelled}

// enum PaymentMethods {paypal, vodafoneCash, creditCard,}

enum ProductType { single, variable }
// enum ProductsStatus { initial, loading, success, error }
enum BannerTargetType {
  none,
  store,
  product,
  category,
  external;

  bool get requiresTarget =>
      this == BannerTargetType.product ||
          this == BannerTargetType.category ||
          this == BannerTargetType.external;
}



