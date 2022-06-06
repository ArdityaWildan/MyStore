class StoreItem {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final int price;
  final double discountPercentage;
  final double rating;
  final bool favorite;

  StoreItem({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    this.favorite = false,
  });

  factory StoreItem.fromJson(Map<String, dynamic> data) => StoreItem(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        thumbnail: data['thumbnail'],
        price: data['price'],
        discountPercentage:
            double.tryParse(data['discountPercentage'].toString()) ?? 0,
        rating: double.tryParse(data['rating'].toString()) ?? 0,
      );
}
