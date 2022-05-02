class Product {
  late String? name;
  late String? price;
  late String? category;
  late String? description;
  late String? location;
  late String? id;
  late int? quantity;

  Product(
      {this.quantity,
      this.id,
      this.category,
      this.description,
      this.location,
      this.name,
      this.price});
}
