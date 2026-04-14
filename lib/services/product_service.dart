import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class ProductService {
  final _client = Supabase.instance.client;

  String? get _uid => _client.auth.currentUser?.id;

  // ─── Fetch ───────────────────────────────────────────────────────────────────

  Future<List<Product>> getProducts() async {
    final data = await _client
        .from('products')
        .select('*, seller:profiles!seller_id(*)')
        .eq('is_draft', false)
        .eq('is_sold', false)
        .order('created_at', ascending: false);
    return _parseList(data);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final data = await _client
        .from('products')
        .select('*, seller:profiles!seller_id(*)')
        .eq('is_draft', false)
        .eq('is_sold', false)
        .eq('category', category)
        .order('created_at', ascending: false);
    return _parseList(data);
  }

  Future<List<Product>> searchProducts({
    required String query,
    String? category,
    String? condition,
    double? maxPrice,
  }) async {
    var q = _client
        .from('products')
        .select('*, seller:profiles!seller_id(*)')
        .eq('is_draft', false)
        .eq('is_sold', false);

    if (query.isNotEmpty) {
      q = q.ilike('name', '%$query%');
    }
    if (category != null) {
      q = q.eq('category', category);
    }
    if (condition != null) {
      q = q.eq('condition', condition);
    }
    if (maxPrice != null) {
      q = q.lte('price', maxPrice);
    }

    final data = await q.order('created_at', ascending: false);
    return _parseList(data);
  }

  Future<List<Product>> getMyListings() async {
    if (_uid == null) return [];
    final data = await _client
        .from('products')
        .select('*, seller:profiles!seller_id(*)')
        .eq('seller_id', _uid!)
        .order('created_at', ascending: false);
    return _parseList(data);
  }

  Stream<List<Product>> subscribeToMyListings() {
    if (_uid == null) return const Stream.empty();
    return _client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('seller_id', _uid!)
        .order('created_at', ascending: false)
        .map((rows) => rows.map((row) => Product.fromJson(row)).toList());
  }

  Future<List<Product>> getProductsBySeller(String sellerId) async {
    final data = await _client
        .from('products')
        .select('*, seller:profiles!seller_id(*)')
        .eq('seller_id', sellerId)
        .eq('is_draft', false)
        .order('created_at', ascending: false);
    return _parseList(data);
  }

  // ─── Saved Items ─────────────────────────────────────────────────────────────

  Future<Set<String>> getSavedProductIds() async {
    if (_uid == null) return {};
    final data = await _client
        .from('saved_items')
        .select('product_id')
        .eq('user_id', _uid!);
    return (data as List<dynamic>)
        .map((row) => row['product_id'] as String)
        .toSet();
  }

  Future<List<Product>> getSavedProducts() async {
    if (_uid == null) return [];
    final data = await _client
        .from('saved_items')
        .select('product:products!product_id(*, seller:profiles!seller_id(*))')
        .eq('user_id', _uid!)
        .order('created_at', ascending: false);
    return (data as List<dynamic>)
        .map((row) => Product.fromJson(row['product'] as Map<String, dynamic>))
        .toList();
  }

  Future<bool> toggleSave(String productId) async {
    if (_uid == null) return false;
    final existing = await _client
        .from('saved_items')
        .select('id')
        .eq('user_id', _uid!)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('saved_items')
          .delete()
          .eq('user_id', _uid!)
          .eq('product_id', productId);
      return false; // now unsaved
    } else {
      await _client.from('saved_items').insert({
        'user_id': _uid,
        'product_id': productId,
      });
      return true; // now saved
    }
  }

  // ─── Create / Update / Delete ────────────────────────────────────────────────

  Future<String> createProduct({
    required String name,
    required String description,
    required double price,
    required String condition,
    required String category,
    required String location,
    required bool isNegotiable,
    double? minOffer,
    bool isDraft = false,
    List<String> imageUrls = const [],
  }) async {
    if (_uid == null) throw Exception('Not logged in');
    final result = await _client.from('products').insert({
      'seller_id': _uid,
      'name': name,
      'description': description,
      'price': price,
      'condition': condition,
      'category': category,
      'location': location,
      'is_negotiable': isNegotiable,
      'min_offer': minOffer,
      'is_draft': isDraft,
      'image_urls': imageUrls,
    }).select('id').single();
    return result['id'] as String;
  }

  Future<void> updateProduct(
    String productId, {
    String? name,
    String? description,
    double? price,
    String? condition,
    String? category,
    String? location,
    bool? isNegotiable,
    double? minOffer,
    bool? isSold,
    bool? isDraft,
    List<String>? imageUrls,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (price != null) updates['price'] = price;
    if (condition != null) updates['condition'] = condition;
    if (category != null) updates['category'] = category;
    if (location != null) updates['location'] = location;
    if (isNegotiable != null) updates['is_negotiable'] = isNegotiable;
    if (minOffer != null) updates['min_offer'] = minOffer;
    if (isSold != null) updates['is_sold'] = isSold;
    if (isDraft != null) updates['is_draft'] = isDraft;
    if (imageUrls != null) updates['image_urls'] = imageUrls;

    if (updates.isEmpty) return;
    await _client.from('products').update(updates).eq('id', productId);
  }

  Future<void> deleteProduct(String productId) async {
    await _client.from('products').delete().eq('id', productId);
  }

  Future<void> markAsSold(String productId) async {
    await _client
        .from('products')
        .update({'is_sold': true})
        .eq('id', productId);
  }

  Future<void> incrementViews(String productId) async {
    // Uses a Postgres function to safely increment
    await _client.rpc('increment_product_views', params: {'pid': productId});
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  List<Product> _parseList(List<dynamic> data) {
    return data
        .map((row) => Product.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
