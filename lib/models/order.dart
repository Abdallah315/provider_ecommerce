class Order {
  late String documentId;
  late int totallPrice;
  late String address;
  Order(
      {required this.totallPrice,
      required this.address,
      required this.documentId});
}
