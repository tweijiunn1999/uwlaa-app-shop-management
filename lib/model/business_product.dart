class BusinessProductList {
  final List<dynamic> businessProductList;
  final String status;

  BusinessProductList({this.status, this.businessProductList});

  factory BusinessProductList.fromJson(Map<String, dynamic> json) {
    return new BusinessProductList(
        status: json["status"], businessProductList: json["result"]);
  }
}

class BusinessProduct {
  final String isPreOrder;
  final bool isVariationMode;
  final bool isVariation2Enabled;
  final String productName;
  final String coverImage;
  final String productDescription;
  final int minimumLot;
  var productRating;
  var productPrice;
  final String productId;
  final bool isFavourite;
  final String priceDisplay;
  final String shopName;
  var shopRating;
  final String shopLogo;
  final int unitSold;
  final List<dynamic> productImages;
  final List<ExtraQuestion> extraQuestionForm; // title, answer
  final List<WholesaleDetail> wholesaleDetails; // min, max, price
  final List<Variations>
      variations; // variation_name_1, variation_name_2, stock, price, image_url, quantity, tag
  final List<ShippingOptions> shippingOptions;
  final int daysToShip; // Only needed when isPreOrder is needed
  final String productType; // Muslim friendly or halal certified
  final String halalCertImage;
  final String halalIssueCountry;
  final int numberOfProduct;
  final int totalStock;
  final String shopOwnerId;
  // Shipping options

  BusinessProduct({
    this.isPreOrder,
    this.isVariationMode,
    this.isVariation2Enabled,
    this.productName,
    this.coverImage,
    this.productDescription,
    this.minimumLot,
    this.productRating,
    this.productPrice,
    this.productId,
    this.isFavourite,
    this.priceDisplay,
    this.shopName,
    this.shopRating,
    this.shopLogo,
    this.unitSold,
    this.productImages,
    this.extraQuestionForm,
    this.wholesaleDetails,
    this.variations,
    this.shippingOptions,
    this.daysToShip,
    this.productType,
    this.halalCertImage,
    this.halalIssueCountry,
    this.numberOfProduct,
    this.totalStock,
    this.shopOwnerId,
    // Shipping options
  });

  factory BusinessProduct.fromJson(Map<String, dynamic> json) {
    return new BusinessProduct(
      isPreOrder: json["is_pre_order"],
      isVariationMode: json["is_variation_mode"],
      isVariation2Enabled: json["is_variation2_enabled"],
      productName: json["product_name"],
      coverImage: json["cover_image"],
      productDescription: json["product_description"],
      minimumLot: json["minimum_lot"],
      productRating: json["product_rating"],
      productPrice: json["product_price"],
      productId: json["id"],
      isFavourite: json["is_favourite"],
      priceDisplay: json["price_display"],
      shopName: json["shop_name"],
      shopRating: json["shop_rating"],
      shopLogo: json["shop_logo"],
      unitSold: json["unit_sold"],
      productImages: json["product_images"],
      extraQuestionForm: json["extra_question_form"],
      wholesaleDetails: json["wholesale_details"],
      variations: json["variation_list"],
      shippingOptions: json["shipping_options"],
      daysToShip: json["days_to_ship"],
      productType: json["product_type"],
      halalCertImage: json["halal_cert_image"],
      halalIssueCountry: json["halal_certificate_issue_country"],
      numberOfProduct: json["shop_number_of_product"],
      totalStock: json["total_stock"],
      shopOwnerId: json["shop_owner_id"],
      // Shipping options
    );
  }

  @override
  String toString() {
    String response =
        "{ isPreOrder: $isPreOrder, isVariationMode: $isVariationMode, isVariation2Enabled: $isVariation2Enabled, productName: $productName, minimumLot: $minimumLot, productRating: $productRating, productPrice: $productPrice, productId: $productId, isFavourite: $isFavourite, priceDisplay: $priceDisplay, shopName: $shopName, shopRating: $shopRating, unitSold: $unitSold, daysToShip: $daysToShip, productType: $productType, numberOfProduct: $numberOfProduct, totalStock: $totalStock, shopOwnerId: $shopOwnerId, ";
    for (int i = 0; i < extraQuestionForm.length; i++) {
      if (extraQuestionForm[i].answer != "") {
        if (i == 0 && i == extraQuestionForm.length - 1) {
          response += "extraQuestionForm: [ " +
              extraQuestionForm[i].toString() +
              " ], ";
        } else if (i == 0) {
          response +=
              "extraQuestionForm: [ " + extraQuestionForm[i].toString() + ", ";
        } else if (i == extraQuestionForm.length - 1) {
          response += extraQuestionForm[i].toString() + " ], ";
        } else {
          response += extraQuestionForm[i].toString() + ", ";
        }
      }
    }
    for (int i = 0; i < wholesaleDetails.length; i++) {
      if (i == 0 && i == wholesaleDetails.length - 1) {
        response +=
            "wholesaleDetails: [ " + wholesaleDetails[i].toString() + " ], ";
      } else if (i == 0) {
        response +=
            "wholesaleDetails: [ " + wholesaleDetails[i].toString() + ", ";
      } else if (i == wholesaleDetails.length - 1) {
        response += wholesaleDetails[i].toString() + " ], ";
      } else {
        response += wholesaleDetails[i].toString() + ", ";
      }
    }
    for (int i = 0; i < variations.length; i++) {
      if (i == 0 && i == variations.length - 1) {
        response += "variations: [ " + variations[i].toString() + " ], }";
      } else if (i == 0) {
        response += "variations: [ " + variations[i].toString() + ", ";
      } else if (i == variations.length - 1) {
        response += variations[i].toString() + " ], }";
      } else {
        response += variations[i].toString() + ", ";
      }
    }
    return response;
  }
}

class ShippingOptions {
  final bool options;
  final int shippingMultiplier;
  final String id;
  final String category;
  var shippingFee;
  final String title;
  final bool isEnabled;

  ShippingOptions({
    this.options,
    this.shippingMultiplier,
    this.id,
    this.category,
    this.shippingFee,
    this.title,
    this.isEnabled,
  });

  factory ShippingOptions.fromJson(Map<String, dynamic> json) {
    return new ShippingOptions(
      options: json["options"],
      shippingMultiplier: json["shipping_multiplier"],
      id: json["id"],
      category: json["category"],
      shippingFee: json["shipping_fee"],
      title: json["title"],
      isEnabled: json["isEnabled"],
    );
  }

  @override
  String toString() {
    String response =
        "{ options: $options, shippingMultiplier: $shippingMultiplier, id: $id, category: $category, shippingFee: $shippingFee, title: $title, isEnabled: $isEnabled }";
    return response;
  }
}

class Variations {
  // variation_name_1, variation_name_2, stock, price, image_url, quantity
  final String variationName1;
  final String variationName2;
  final int stock;
  var price;
  final String imageUrl;
  int quantity;
  final String tag; //0, 1, 2...
  final String variationId;
  int addedToCartQuantity;

  Variations({
    this.variationName1,
    this.variationName2,
    this.stock,
    this.price,
    this.imageUrl,
    this.quantity,
    this.tag,
    this.variationId,
    this.addedToCartQuantity,
  });

  factory Variations.fromJson(Map<String, dynamic> json) {
    return new Variations(
      variationName1: json["variation_name_1"],
      variationName2: json["variation_name_2"],
      stock: json["stock"],
      price: json["price"],
      imageUrl: json["image_url"],
      quantity: json["quantity"],
      tag: json["tag"],
      variationId: json["variation_id"],
      addedToCartQuantity: json["added_to_cart_quantity"],
    );
  }

  @override
  String toString() {
    String response =
        "{variationId: $variationId, addedToCartQuantity: $addedToCartQuantity, variationName1: $variationName1, variationName2: $variationName2, stock: $stock, price: $price, imageUrl: $imageUrl, quantity: $quantity, tag: $tag}";
    return response;
  }
}

class ExtraQuestion {
  final String title;
  final String answer;

  ExtraQuestion({this.title, this.answer});

  factory ExtraQuestion.fromJson(Map<String, dynamic> json) {
    return new ExtraQuestion(title: json["title"], answer: json["answer"]);
  }

  @override
  String toString() {
    String response = "{title: $title, answer: $answer}";
    return response;
  }
}

class WholesaleDetail {
  final int min;
  final int max;
  var price;

  WholesaleDetail({this.min, this.max, this.price});

  factory WholesaleDetail.fromJson(Map<String, dynamic> json) {
    return new WholesaleDetail(
        min: json["min"], max: json["max"], price: json["price"]);
  }

  @override
  String toString() {
    String response = "{min: $min, max: $max, price: $price}";
    return response;
  }
}
