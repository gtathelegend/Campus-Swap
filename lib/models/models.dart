class UserProfile {
  final String name;
  final String email;
  final String? phone;
  final String? bio;
  final String campusLocation;
  final double rating;
  final int reviews;
  final int activeListings;
  final int soldItems;
  final int draftListings;
  final bool verified;

  const UserProfile({
    required this.name,
    required this.email,
    this.phone,
    this.bio,
    required this.campusLocation,
    required this.rating,
    required this.reviews,
    required this.activeListings,
    required this.soldItems,
    required this.draftListings,
    required this.verified,
  });
}

class Seller {
  final String id;
  final String name;
  final double rating;
  final int reviews;
  final int listings;
  final int sold;
  final bool verified;
  final String? bio;

  const Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.listings,
    required this.sold,
    required this.verified,
    this.bio,
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
  final bool isSold;
  final bool isDraft;
  final int views;
  final int favorites;
  final int messages;
  final String listedAt;
  final bool isNegotiable;
  final double? minOffer;

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
    this.isSold = false,
    this.isDraft = false,
    this.views = 0,
    this.favorites = 0,
    this.messages = 0,
    this.listedAt = '1 day ago',
    this.isNegotiable = false,
    this.minOffer,
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
  final String time;
  final bool hasUnread;
  final Product? product;

  const Conversation({
    required this.id,
    required this.seller,
    required this.lastMessage,
    required this.messages,
    this.time = '',
    this.hasUnread = false,
    this.product,
  });
}

class Category {
  final String id;
  final String name;
  final String emoji;

  const Category({required this.id, required this.name, required this.emoji});
}

class BlockedUser {
  final String id;
  final String name;
  final String blockedAt;

  const BlockedUser({
    required this.id,
    required this.name,
    required this.blockedAt,
  });
}
