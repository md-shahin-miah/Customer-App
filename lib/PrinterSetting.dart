class Settings {
  bool domain;
  bool enablePendingOrderSound;
  bool hideRestaurantAddressOnReceipt;
  bool displayOrderIdTable;
  bool autoPrintTableBookingReceipt;
  bool autoPrintOrder;
  bool showOnlyCurrentDaysOrder;
  bool kitchenReceiptDefault;
  bool kitchenReceiptSameAsFront;
  bool displayOrderIdInReceipt;
  bool displayAwaitingNotPaidPayment;
  bool enableAwaitingNotPaidPaymentSound;
  bool enableDeveloperMode;
  String unconfirmedPaymentButtonValue;
  String paperSize;
  String autoCutter;
  String numberOfFrontReceiptValue;
  String numberOfKitchenReceiptValue;
  String pendingOrderSoundLengthValue;

  Settings(
      {this.domain,
      this.enablePendingOrderSound,
      this.hideRestaurantAddressOnReceipt,
      this.displayOrderIdTable,
      this.autoPrintTableBookingReceipt,
      this.autoPrintOrder,
      this.showOnlyCurrentDaysOrder,
      this.kitchenReceiptDefault,
      this.kitchenReceiptSameAsFront,
      this.displayOrderIdInReceipt,
      this.displayAwaitingNotPaidPayment,
      this.enableAwaitingNotPaidPaymentSound,
      this.enableDeveloperMode,
      this.unconfirmedPaymentButtonValue,
      this.paperSize,
      this.autoCutter,
      this.numberOfFrontReceiptValue,
      this.numberOfKitchenReceiptValue,
      this.pendingOrderSoundLengthValue});


}
