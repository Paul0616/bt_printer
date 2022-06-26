enum DatecsDiscountType {
  noDiscount(0x00),
  percentageDiscount(0x02),
  absolutDiscount(0x04);

  final int value;
  const DatecsDiscountType(this.value);
}
