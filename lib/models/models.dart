String _formatRelativeTime(String? dateStr) {
  if (dateStr == null) return 'recently';
  try {
    final date = DateTime.parse(dateStr).toLocal();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).round()} weeks ago';
    return '${(diff.inDays / 30).round()} months ago';
  } catch (_) {
    return 'recently';
  }
}

String _formatMessageTime(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (dt.day == now.day) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (dt.day == yesterday.day) return 'Yesterday';
  return '${dt.day}/${dt.month}';
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? bio;
  final String campusLocation;
  final String? avatarUrl;
  final double rating;
  final int reviews;
  final int activeListings;
  final int soldItems;
  final bool verified;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.bio,
    this.campusLocation = 'Main Campus',
    this.avatarUrl,
    this.rating = 0.0,
    this.reviews = 0,
    this.activeListings = 0,
    this.soldItems = 0,
    this.verified = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      campusLocation: json['campus_location'] as String? ?? 'Main Campus',
      avatarUrl: json['avatar_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews_count'] as int? ?? 0,
      activeListings: json['active_listings'] as int? ?? 0,
      soldItems: json['sold_items'] as int? ?? 0,
      verified: json['verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toUpdateJson() => {
        'name': name,
        'phone': phone,
        'bio': bio,
        'campus_location': campusLocation,
        'avatar_url': avatarUrl,
      };
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
  final String? avatarUrl;

  const Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.listings,
    required this.sold,
    required this.verified,
    this.bio,
    this.avatarUrl,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews_count'] as int? ?? 0,
      listings: json['active_listings'] as int? ?? 0,
      sold: json['sold_items'] as int? ?? 0,
      verified: json['verified'] as bool? ?? false,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
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
  final List<String> imageUrls;

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
    this.imageUrls = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final sellerJson = json['seller'] as Map<String, dynamic>?;
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      condition: json['condition'] as String,
      category: json['category'] as String,
      seller: sellerJson != null
          ? Seller.fromJson(sellerJson)
          : Seller(
              id: json['seller_id'] as String? ?? '',
              name: 'Unknown',
              rating: 0.0,
              reviews: 0,
              listings: 0,
              sold: 0,
              verified: false,
            ),
      location: json['location'] as String,
      description: json['description'] as String,
      isSold: json['is_sold'] as bool? ?? false,
      isDraft: json['is_draft'] as bool? ?? false,
      views: json['views_count'] as int? ?? 0,
      favorites: json['favorites_count'] as int? ?? 0,
      messages: json['messages_count'] as int? ?? 0,
      listedAt: _formatRelativeTime(json['created_at'] as String?),
      isNegotiable: json['is_negotiable'] as bool? ?? false,
      minOffer: (json['min_offer'] as num?)?.toDouble(),
      imageUrls:
          (json['image_urls'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String from; // 'me' or 'them'
  final String text;
  final String time;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.from,
    required this.text,
    required this.time,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserId) {
    final senderId = json['sender_id'] as String;
    final createdAt = DateTime.parse(json['created_at'] as String).toLocal();
    return Message(
      id: json['id'] as String,
      senderId: senderId,
      from: senderId == currentUserId ? 'me' : 'them',
      text: json['text'] as String,
      time: _formatMessageTime(createdAt),
      createdAt: createdAt,
    );
  }
}

class Conversation {
  final String id;
  final Seller seller; // the other participant
  final String lastMessage;
  final List<Message> messages;
  final String time;
  final bool hasUnread;
  final Product? product;
  final String otherUserId;
  final String? productId;

  const Conversation({
    required this.id,
    required this.seller,
    required this.lastMessage,
    required this.messages,
    this.time = '',
    this.hasUnread = false,
    this.product,
    required this.otherUserId,
    this.productId,
  });

  factory Conversation.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    final buyerId = json['buyer_id'] as String;
    final sellerId = json['seller_id'] as String;
    final isCurrentUserBuyer = buyerId == currentUserId;
    final otherUserId = isCurrentUserBuyer ? sellerId : buyerId;
    final hasUnread = isCurrentUserBuyer
        ? (json['buyer_has_unread'] as bool? ?? false)
        : (json['seller_has_unread'] as bool? ?? false);

    final otherUserJson = isCurrentUserBuyer
        ? json['seller_profile'] as Map<String, dynamic>?
        : json['buyer_profile'] as Map<String, dynamic>?;

    final seller = otherUserJson != null
        ? Seller.fromJson(otherUserJson)
        : Seller(
            id: otherUserId,
            name: 'Unknown',
            rating: 0,
            reviews: 0,
            listings: 0,
            sold: 0,
            verified: false,
          );

    final productJson = json['product'] as Map<String, dynamic>?;
    Product? product;
    if (productJson != null) {
      try {
        product = Product.fromJson({...productJson, 'seller': otherUserJson});
      } catch (_) {}
    }

    final lastMessageAt = json['last_message_at'] as String?;

    return Conversation(
      id: json['id'] as String,
      seller: seller,
      lastMessage: json['last_message'] as String? ?? '',
      messages: [],
      time: lastMessageAt != null
          ? _formatMessageTime(DateTime.parse(lastMessageAt).toLocal())
          : '',
      hasUnread: hasUnread,
      product: product,
      otherUserId: otherUserId,
      productId: json['product_id'] as String?,
    );
  }
}

class Review {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String? reviewerAvatarUrl;
  final String revieweeId;
  final String? productId;
  final int rating;
  final String? comment;
  final String createdAt;

  const Review({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    this.reviewerAvatarUrl,
    required this.revieweeId,
    this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] as Map<String, dynamic>?;
    return Review(
      id: json['id'] as String,
      reviewerId: json['reviewer_id'] as String,
      reviewerName: reviewer?['name'] as String? ?? 'Anonymous',
      reviewerAvatarUrl: reviewer?['avatar_url'] as String?,
      revieweeId: json['reviewee_id'] as String,
      productId: json['product_id'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: _formatRelativeTime(json['created_at'] as String?),
    );
  }
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

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    final blockedProfile =
        json['blocked_profile'] as Map<String, dynamic>?;
    final createdAt = json['created_at'] as String?;
    return BlockedUser(
      id: json['blocked_id'] as String,
      name: blockedProfile?['name'] as String? ?? 'Unknown',
      blockedAt: _formatRelativeTime(createdAt),
    );
  }
}
