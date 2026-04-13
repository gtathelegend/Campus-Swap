class Seller {
  final String id;
  final String name;
  final double rating;
  final int reviews;
  final int listings;
  final int sold;
  final bool verified;

  const Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.listings,
    required this.sold,
    required this.verified,
  });
}

class Product {
  final String id;
  final String name;
  final double price;
  final String condition;
  final String category;
  final Seller seller;
  final String location;
  final String description;
  bool isSaved;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.condition,
    required this.category,
    required this.seller,
    required this.location,
    required this.description,
    this.isSaved = false,
  });
}

class Message {
  final String id;
  final String from; // 'me' or 'them'
  final String text;
  final String time;

  const Message({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
  });
}

class Conversation {
  final String id;
  final Seller seller;
  final String lastMessage;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.seller,
    required this.lastMessage,
    required this.messages,
  });
}

class Category {
  final String id;
  final String name;
  final String emoji;

  const Category({required this.id, required this.name, required this.emoji});
}
