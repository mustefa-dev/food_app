import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const RestaurantApp());
}

// ===================== BRAND COLORS =====================
class Brand {
  static const primary = Color(0xFF06C167); // Green as primary
  static const secondary = Color(0xFF34D399); // Lighter green
  static const tertiary = Color(0xFF059669); // Darker green
  static const onSurface = Color(0xFF0F172A); // Rich black for text
  static const bg = Color(0xFFFFFFFF);
  static const bgAlt = Color(0xFFF1FDF7);
  static const outline = Color(0xFFD1FAE5); // Light green outline
  static const error = Color(0xFFDC2626); // Error red
  static const warning = Color(0xFFFACC15); // Warning yellow
}

ColorScheme _colorScheme(Brightness b) {
  final isDark = b == Brightness.dark;
  return ColorScheme(
    brightness: b,
    primary: Brand.primary,
    onPrimary: Colors.white,
    secondary: Brand.secondary,
    onSecondary: Colors.white,
    tertiary: Brand.tertiary,
    onTertiary: Colors.white,
    error: Brand.error,
    onError: Colors.white,
    surface: isDark ? const Color(0xFF111827) : Brand.bg,
    onSurface: isDark ? const Color(0xFFE2E8F0) : Brand.onSurface,
    surfaceContainerHighest: isDark ? const Color(0xFF1E293B) : Brand.bgAlt,
    surfaceContainerHigh: isDark ? const Color(0xFF1B2332) : const Color(0xFFECFDF5),
    surfaceContainer: isDark ? const Color(0xFF1B1B25) : const Color(0xFFF0FDF4),
    surfaceContainerLow: isDark ? const Color(0xFF151923) : const Color(0xFFDCFCE7),
    surfaceContainerLowest: isDark ? const Color(0xFF0F172A) : Brand.bg,
    background: isDark ? const Color(0xFF0F172A) : Brand.bgAlt,
    onBackground: isDark ? const Color(0xFFE2E8F0) : Brand.onSurface,
    outline: isDark ? const Color(0xFF334155) : Brand.outline,
    outlineVariant: isDark ? const Color(0xFF475569) : const Color(0xFFD1FAE5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: isDark ? Brand.bg : const Color(0xFF0F172A),
    onInverseSurface: isDark ? Brand.onSurface : Colors.white,
    inversePrimary: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
  );
}

ThemeData buildTheme(Brightness brightness) {
  final scheme = _colorScheme(brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Cairo', // Add Cairo or Tajawal in pubspec
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    chipTheme: ChipThemeData(
      shape: StadiumBorder(side: BorderSide(color: scheme.outline)),
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.secondary.withAlpha(46),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withAlpha(41), // Fixed opacity warning
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}

// ===================== APP =====================
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      state: AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مطعم واحد — HallGlow',
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: ThemeMode.system,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: MainScaffold(),
        ),
      ),
    );
  }
}

// ===================== STATE =====================
class AppState extends ChangeNotifier {
  // --- AUTH (Demo) ---
  final Map<String, String> _users = {
    'demo@hallglow.com': '123456',
  };

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<String?> signIn(String email, String password) async {
    final ok = _users[email] == password;
    if (!ok) return 'الإيميل أو كلمة المرور غير صحيحة';
    _currentUser = AppUser(email: email, name: email.split('@').first);
    notifyListeners();
    return null;
  }

  Future<String?> signUp(String name, String email, String password) async {
    if (_users.containsKey(email)) return 'هذا الإيميل مسجّل مسبقًا';
    _users[email] = password;
    _currentUser = AppUser(email: email, name: name);
    notifyListeners();
    return null;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  // --- RESTAURANT ---
  final Restaurant restaurant = demoRestaurant;

  // --- CART ---
  final Map<CartLine, int> _cart = {};
  Map<CartLine, int> get cart => Map.unmodifiable(_cart);
  int get cartCount => _cart.values.fold(0, (a, b) => a + b);
  int get subtotal => _cart.entries.fold(0, (sum, e) => sum + e.key.totalPrice * e.value);

  int deliveryFee = 1000; // رسوم توصيل
  int serviceFee = 500;   // خدمة
  int tips = 0;           // بخشيش
  int freeDeliveryThreshold = 15000; // حد الشحن المجاني

  // كوبون بسيط: HAL10 = خصم 10%
  String? appliedCoupon;
  int get discount => appliedCoupon == 'HAL10' ? (subtotal * 0.10).round() : 0;

  void applyCoupon(String? code) {
    if (code == null || code.isEmpty) {
      appliedCoupon = null;
    } else if (code.toUpperCase() == 'HAL10') {
      appliedCoupon = 'HAL10';
    } else {
      appliedCoupon = null;
    }
    notifyListeners();
  }

  void setTips(int value) { tips = value; notifyListeners(); }

  int get totalBeforeFees => subtotal - discount;
  int get finalTotal => totalBeforeFees + (isFreeDelivery ? 0 : deliveryFee) + serviceFee + tips;
  bool get isFreeDelivery => totalBeforeFees >= freeDeliveryThreshold;
  int get remainingForFreeDelivery => (freeDeliveryThreshold - totalBeforeFees).clamp(0, 1 << 31);

  void addToCart(MenuItem item, {int quantity = 1, List<AddOn> addOns = const []}) {
    final line = CartLine(item: item, selectedAddOns: addOns);
    final existingKey = _cart.keys.firstWhere((k) => k == line, orElse: () => line);
    _cart.update(existingKey, (q) => q + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  void setQty(CartLine line, int qty) {
    if (qty <= 0) {
      _cart.remove(line);
    } else {
      _cart[line] = qty;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    appliedCoupon = null;
    tips = 0;
    notifyListeners();
  }

  final List<Address> savedAddresses = const [
    Address(label: 'البيت', details: 'بغداد، حي المنصور، شارع 14 رمضان، بناية 12، ط3'),
    Address(label: 'العمل', details: 'بغداد، الكرادة داخل، قرب ساحة كهرمانة'),
  ];

  void placeOrder(CheckoutInfo info) {
    if (_cart.isEmpty) return;
    final order = Order(
      id: Random().nextInt(999999999).toString().padLeft(9, '0'),
      dateTime: DateTime.now(),
      lines: Map.of(_cart),
      subtotal: subtotal,
      deliveryFee: isFreeDelivery ? 0 : deliveryFee,
      serviceFee: serviceFee,
      tips: tips,
      discount: discount,
      total: finalTotal,
      address: info.address,
      paymentMethod: info.paymentMethod,
      customerEmail: _currentUser?.email ?? 'guest',
      status: OrderStatus.preparing,
    );
    orders.insert(0, order);
    clearCart();
  }

  final List<Order> orders = [];
}

class AppStateWidget extends InheritedNotifier<AppState> {
  const AppStateWidget({super.key, required super.child, required AppState state}) : super(notifier: state);
  static AppState of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    assert(w != null, 'No AppStateWidget found');
    return w!.notifier!;
  }
}

// ===================== MODELS =====================
class AppUser {
  final String email;
  final String name;
  const AppUser({required this.email, required this.name});
}

class Restaurant {
  final String name;
  final double rating;
  final int reviews;
  final int deliveryMinutesMin;
  final int deliveryMinutesMax;
  final int deliveryFee;
  final List<MenuCategory> categories;
  Restaurant({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.deliveryMinutesMin,
    required this.deliveryMinutesMax,
    required this.deliveryFee,
    required this.categories,
  });
}

class MenuCategory {
  final String id;
  final String name;
  final List<MenuItem> items;
  MenuCategory({required this.id, required this.name, required this.items});
}

class AddOn {
  final String id;
  final String name;
  final int price;
  const AddOn({required this.id, required this.name, required this.price});
}

class MenuItem {
  final String id;
  final String title;
  final String description;
  final int price; // IQD
  final String imageUrl;
  final List<AddOn> addOns; // optional add-ons
  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.addOns = const [],
  });
}

class CartLine {
  final MenuItem item;
  final List<AddOn> selectedAddOns;
  const CartLine({required this.item, this.selectedAddOns = const []});

  int get addOnsPrice => selectedAddOns.fold(0, (s, a) => s + a.price);
  int get unitPrice => item.price + addOnsPrice;
  int get totalPrice => unitPrice;

  @override
  bool operator ==(Object other) {
    if (other is! CartLine) return false;
    if (other.item.id != item.id) return false;
    if (other.selectedAddOns.length != selectedAddOns.length) return false;
    final a = [...selectedAddOns]..sort((x, y) => x.id.compareTo(y.id));
    final b = [...other.selectedAddOns]..sort((x, y) => x.id.compareTo(y.id));
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(item.id, selectedAddOns.map((e) => e.id).join(','));
}

class Address {
  final String label;
  final String details;
  const Address({required this.label, required this.details});
}

enum OrderStatus { preparing, pickedUp, onTheWay, delivered }

class Order {
  final String id;
  final DateTime dateTime;
  final Map<CartLine, int> lines;
  final int subtotal;
  final int deliveryFee;
  final int serviceFee;
  final int tips;
  final int discount;
  final int total;
  final String address;
  final String paymentMethod;
  final String customerEmail;
  OrderStatus status;
  Order({
    required this.id,
    required this.dateTime,
    required this.lines,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tips,
    required this.discount,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.customerEmail,
    required this.status,
  });
}

class CheckoutInfo {
  String address;
  String paymentMethod;
  CheckoutInfo({required this.address, required this.paymentMethod});
}

// ===================== DEMO DATA =====================
final demoRestaurant = Restaurant(
  name: 'مطعم عدنان أبو الظلع',
  rating: 4.6,
  reviews: 1240,
  deliveryMinutesMin: 15,
  deliveryMinutesMax: 25,
  deliveryFee: 1000,
  categories: [
    MenuCategory(
      id: 'picks',
      name: 'مختارات لك',
      items: [
        MenuItem(
          id: 'foul_ghee',
          title: 'فول بالسمن',
          description: 'خبز، زيت، بيض، سمن',
          price: 6000,
          imageUrl: 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?q=80&w=1200&auto=format&fit=crop',
          addOns: [
            AddOn(id: 'bread', name: 'خبز إضافي', price: 500),
            AddOn(id: 'egg', name: 'بيضة إضافية', price: 1000),
          ],
        ),
        MenuItem(
          id: 'makhlama',
          title: 'مخلمة',
          description: 'بيض مع لحم وبندورة',
          price: 6000,
          imageUrl: 'https://images.unsplash.com/photo-1508737027454-29eb0a3883b8?q=80&w=1200&auto=format&fit=crop',
          addOns: [
            AddOn(id: 'bread', name: 'خبز إضافي', price: 500),
            AddOn(id: 'spicy', name: 'زيادة حار', price: 0),
          ],
        ),
      ],
    ),
    MenuCategory(
      id: 'breakfast',
      name: 'فطور',
      items: [
        MenuItem(
          id: 'earook',
          title: 'عروق كباب',
          description: 'كباب مشوي مع طماطم ومخللات',
          price: 6000,
          imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1200&auto=format&fit=crop',
          addOns: [AddOn(id: 'tomato', name: 'طماطم زيادة', price: 500)],
        ),
      ],
    ),
    MenuCategory(
      id: 'grills',
      name: 'مشويات',
      items: [
        MenuItem(
          id: 'meat_kebab',
          title: 'كباب لحم',
          description: 'كباب مشوي مع طماطم وبصل',
          price: 7500,
          imageUrl: 'https://images.unsplash.com/photo-1604908554027-27bc33f5f2df?q=80&w=1200&auto=format&fit=crop',
          addOns: [AddOn(id: 'pickles', name: 'مخلل إضافي', price: 500)],
        ),
        MenuItem(
          id: 'meat_tikka',
          title: 'تكة لحم',
          description: 'تكة مشوية مع بقدونس ومخللات',
          price: 7500,
          imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop',
          addOns: [AddOn(id: 'bread', name: 'خبز إضافي', price: 500)],
        ),
        MenuItem(
          id: 'ribs',
          title: 'أضلاع',
          description: 'أضلاع مشوية على الفحم',
          price: 14000,
          imageUrl: 'https://images.unsplash.com/photo-1604908177074-0010b1f5c0bb?q=80&w=1200&auto=format&fit=crop',
          addOns: [AddOn(id: 'garlic', name: 'صوص ثوم', price: 500)],
        ),
      ],
    ),
    MenuCategory(
      id: 'drinks',
      name: 'مشروبات',
      items: [
        MenuItem(
          id: 'water',
          title: 'مي قنينة',
          description: 'ماء عادي',
          price: 1000,
          imageUrl: 'https://images.unsplash.com/photo-1526403227865-6b0f430a04f4?q=80&w=1200&auto=format&fit=crop',
        ),
      ],
    ),
  ],
);

// ===================== UI: SCAFFOLD =====================
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;
  final List<Widget> _pages = const [RestaurantScreen(), OrdersScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Scaffold(
          body: _pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'طلباتي'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
            ],
            onDestinationSelected: (i) => setState(() => _index = i),
          ),
        ),
        if (app.cartCount > 0)
          Positioned(
            left: 12,
            right: 12,
            bottom: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      foregroundColor: cs.primary,
                      child: Text(app.cartCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text('شوف السلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ]),
                  Text('د.ع ${formatIQD(app.subtotal)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ===================== UI: RESTAURANT =====================
class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int categoryIndex = 0;
  final _scrollController = ScrollController();
  // header image used in the flexible space — keep as a field so we can precache it
  final String _headerImageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop';

  @override
  void initState() {
    super.initState();
    // Precache the header image and some initial item images to reduce scroll jank.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // precache header
      precacheImage(NetworkImage(_headerImageUrl), context);
      // precache first few menu item images for the default category
      try {
        final app = AppStateWidget.of(context);
        final items = app.restaurant.categories.first.items;
        for (var i = 0; i < items.length && i < 4; i++) {
          precacheImage(NetworkImage(items[i].imageUrl), context);
        }
      } catch (_) {
        // ignore if precache fails for any reason
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final r = app.restaurant;
    final cat = r.categories[categoryIndex];
    final cs = Theme.of(context).colorScheme;
    return CustomScrollView(
      controller: _scrollController,
      // smoother physics and increased cacheExtent to keep offscreen widgets ready
      physics: const BouncingScrollPhysics(),
      cacheExtent: 1000.0,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 220,
          surfaceTintColor: Colors.transparent,
          backgroundColor: cs.surface,
          // show a back button only when this route can pop, otherwise no leading
          leading: Navigator.canPop(context) ? BackButton(color: cs.onSurface) : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Simple feedback for now — replace with a real search flow if desired
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search tapped')));
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsets.only(right: 16, left: 16, bottom: 12),
            title: Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
            background: Stack(fit: StackFit.expand, children: [
              CachedNetworkImage(
                imageUrl: _headerImageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 1600,
                memCacheHeight: 900,
                placeholder: (context, url) => Container(color: cs.surfaceContainerLow),
                errorWidget: (context, url, error) => Container(color: cs.surfaceContainerLow),
              ),
               Container(
                 decoration: const BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [Colors.transparent, Colors.black54],
                   ),
                 ),
               ),
             ]),
           ),
         ),
        SliverToBoxAdapter(child: RestaurantHeader(r: r)),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final c = r.categories[i];
                final selected = i == categoryIndex;
                return ChoiceChip(
                  label: Text(c.name),
                  selected: selected,
                  selectedColor: cs.secondary,
                  labelStyle: TextStyle(color: selected ? cs.onSecondary : cs.onSurface),
                  onSelected: (v) {
                    // update selected category and pre-cache its first images to reduce jank
                    setState(() => categoryIndex = i);
                    if (v) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        try {
                          final app = AppStateWidget.of(context);
                          final items = app.restaurant.categories[i].items;
                          for (var k = 0; k < items.length && k < 4; k++) {
                            precacheImage(NetworkImage(items[k].imageUrl), context);
                          }
                        } catch (_) {}
                      });
                    }
                  },
                );
              },
              separatorBuilder: (context, __) => const SizedBox(width: 8),
              itemCount: r.categories.length,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => MenuItemTile(item: cat.items[i]),
            childCount: cat.items.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

class RestaurantHeader extends StatelessWidget {
  final Restaurant r;
  const RestaurantHeader({super.key, required this.r});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    final remain = app.remainingForFreeDelivery;
    final reached = app.isFreeDelivery;
    final totalBefore = app.totalBeforeFees;
    final progress = (totalBefore / app.freeDeliveryThreshold).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 6))],
          ),
          child: Row(children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${r.rating}', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            Text('(${r.reviews}+)', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 10),
            const Icon(Icons.timer_outlined, size: 18),
            const SizedBox(width: 4),
            Text('${r.deliveryMinutesMin} - ${r.deliveryMinutesMax} دقيقة'),
            const Spacer(),
            const Icon(Icons.delivery_dining_outlined, size: 18),
            const SizedBox(width: 6),
            Text('د.ع ${formatIQD(app.isFreeDelivery ? 0 : r.deliveryFee)}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !reached
              ? Container(
            key: const ValueKey('bar1'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary.withOpacity(.10), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.local_shipping_outlined, color: cs.tertiary),
                const SizedBox(width: 8),
                Expanded(child: Text('أضف د.ع ${formatIQD(remain)} لتحصل على توصيل مجاني', style: const TextStyle(fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress,
                  color: cs.tertiary,
                  backgroundColor: cs.tertiary.withOpacity(.25),
                ),
              ),
            ]),
          )
              : Container(
            key: const ValueKey('bar2'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(.12), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.verified, color: cs.secondary),
              const SizedBox(width: 8),
              const Expanded(child: Text('تم تفعيل التوصيل المجاني', style: TextStyle(fontWeight: FontWeight.w700))),
            ]),
          ),
        ),
      ]),
    );
  }
}

class MenuItemTile extends StatelessWidget {
  final MenuItem item;
  const MenuItemTile({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ItemDetailBottomSheet(item: item)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 10),
                      Text('د.ع ${formatIQD(item.price)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: cs.primary)),
                    ]),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 112,
                height: 92,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'img_${item.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: 112,
                          height: 92,
                          fit: BoxFit.cover,
                          memCacheWidth: 224,
                          memCacheHeight: 184,
                          placeholder: (context, url) => Container(width: 112, height: 92, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(14))),
                          errorWidget: (context, url, error) => Container(width: 112, height: 92, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Material(
                        color: cs.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => app.addToCart(item),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}

// ===================== UI: ITEM DETAIL (Bottom Sheet page style)
class ItemDetailBottomSheet extends StatefulWidget {
  final MenuItem item;
  const ItemDetailBottomSheet({super.key, required this.item});
  @override
  State<ItemDetailBottomSheet> createState() => _ItemDetailBottomSheetState();
}

class _ItemDetailBottomSheetState extends State<ItemDetailBottomSheet> {
  int qty = 1;
  final noteCtrl = TextEditingController();
  final List<AddOn> selected = [];

  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final item = widget.item;
    final addOnsPrice = selected.fold(0, (s, a) => s + a.price);
    final unitTotal = item.price + addOnsPrice;
    final lineTotal = unitTotal * qty;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: SizedBox(
          height: 52,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() => qty = (qty - 1).clamp(1, 99)),
                ),
                Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => qty = (qty + 1).clamp(1, 99)),
                ),
              ]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  app.addToCart(item, quantity: qty, addOns: List.of(selected));
                  Navigator.pop(context);
                },
                child: Text('أضف • د.ع ${formatIQD(lineTotal)}'),
              ),
            ),
          ]),
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Hero(
          tag: 'img_${item.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              height: 220,
              fit: BoxFit.cover,
              memCacheWidth: 1200,
              placeholder: (context, url) => Container(height: 220, color: cs.surfaceContainerLow),
              errorWidget: (context, url, error) => Container(height: 220, color: cs.surfaceContainerLow),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(item.description),
        if (item.addOns.isNotEmpty) ...[
          const SizedBox(height: 16),
          sectionTitle('الإضافات'),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in item.addOns)
              FilterChip(
                label: Text('${a.name}${a.price > 0 ? ' • د.ع ${formatIQD(a.price)}' : ''}'),
                selected: selected.contains(a),
                selectedColor: cs.secondary.withOpacity(.18),
                onSelected: (v) => setState(() { v ? selected.add(a) : selected.remove(a); }),
              )
          ])
        ],
        const SizedBox(height: 16),
        sectionTitle('ملاحظات التوصيل'),
        Wrap(spacing: 8, children: const [
          QuickPill('لا دق الجرس'), QuickPill('اتصل عند الوصول'), QuickPill('صلصة زيادة'),
        ]),
        const SizedBox(height: 8),
        TextField(controller: noteCtrl, minLines: 2, maxLines: 4, decoration: const InputDecoration(hintText: 'اكتب ملاحظاتك هنا')),
        const SizedBox(height: 80),
      ]),
    );
  }
}

class QuickPill extends StatelessWidget {
  final String text;
  const QuickPill(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Chip(label: Text(text)));
  }
}

// ===================== UI: CART =====================
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final couponCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: Column(children: [
        Expanded(
          child: ListView(children: [
            for (final e in app.cart.entries)
              ListTile(
                leading: CircleAvatar(
                    backgroundColor: cs.tertiary.withAlpha(31),
                    foregroundColor: cs.tertiary,
                    child: const Icon(Icons.fastfood)
                ),
                title: Text(e.key.item.title),
                subtitle: Text(buildAddOnsText(e.key.selectedAddOns)),
                trailing: SizedBox(
                  width: 140,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => app.setQty(e.key, e.value - 1)),
                    Text('${e.value}'),
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => app.setQty(e.key, e.value + 1)),
                  ]),
                ),
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: couponCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.percent),
                      hintText: 'كود الخصم',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => app.applyCoupon(couponCtrl.text.trim())),
                  child: const Text('تطبيق'),
                ),
              ]),
            ),
            if (app.appliedCoupon == 'HAL10')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.check_circle, color: cs.secondary),
                  const SizedBox(width: 8),
                  const Text('تم تطبيق خصم 10%')
                ]),
              )
            else if ((couponCtrl.text.trim().isNotEmpty))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  Icon(Icons.error_outline, color: cs.error),
                  const SizedBox(width: 8),
                  Text('الكوبون غير صالح', style: TextStyle(color: cs.error))
                ]),
              ),
            const SizedBox(height: 8),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: TipsChooser()),
            const SizedBox(height: 8),
            PaymentSummary(
              subtotal: app.subtotal,
              discount: app.discount,
              delivery: app.isFreeDelivery ? 0 : app.deliveryFee,
              service: app.serviceFee,
              tips: app.tips,
              total: app.finalTotal,
            ),
          ]),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(12),
          child: Row(children: [
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('أضف أصناف')),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: AppStateWidget.of(context).cart.isEmpty
                    ? null
                    : () async {
                  final app = AppStateWidget.of(context);
                  if (!app.isLoggedIn) {
                    final ok = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                    if (ok != true) return;
                  }
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  }
                },
                child: const Text('كمّل الطلب'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class TipsChooser extends StatelessWidget {
  const TipsChooser({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    Widget tip(int v) => ChoiceChip(
      label: Text(v == 0 ? 'بدون بخشيش' : 'بخشيش د.ع ${formatIQD(v)}'),
      selected: app.tips == v,
      onSelected: (_) => app.setTips(v),
    );
    return Row(children: [
      const Icon(Icons.volunteer_activism_outlined),
      const SizedBox(width: 8),
      Expanded(child: Wrap(spacing: 8, children: [tip(0), tip(500), tip(1000)]))
    ]);
  }
}

class PaymentSummary extends StatelessWidget {
  final int subtotal, discount, delivery, service, tips, total;
  const PaymentSummary({super.key, required this.subtotal, required this.discount, required this.delivery, required this.service, required this.tips, required this.total});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ملخص الدفع', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        _row('المجموع', subtotal),
        if (discount > 0) _row('خصم', -discount, color: cs.secondary),
        _row('التوصيل', delivery),
        _row('الخدمة', service),
        if (tips > 0) _row('بخشيش', tips),
        const Divider(),
        _row('الإجمالي', total, bold: true, color: cs.primary),
      ]),
    );
  }

  Widget _row(String label, int amount, {bool bold = false, Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
      Text('${amount < 0 ? '-' : ''}د.ع ${formatIQD(amount.abs())}', style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: color)),
    ]),
  );
}

// ===================== UI: CHECKOUT =====================
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddress = 0;
  String payment = 'بطاقة •••• 8075';
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    final info = CheckoutInfo(
      address: app.savedAddresses[selectedAddress].details,
      paymentMethod: payment,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('اتمام الطلب')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        sectionTitle('عنوان التوصيل'),
        const SizedBox(height: 6),
        for (int i = 0; i < app.savedAddresses.length; i++)
          Card(
            child: RadioListTile<int>(
              value: i,
              groupValue: selectedAddress,
              onChanged: (v) => setState(() => selectedAddress = v ?? 0),
              title: Text(app.savedAddresses[i].label),
              subtitle: Text(app.savedAddresses[i].details),
            ),
          ),
        const SizedBox(height: 12),
        sectionTitle('الدفع'),
        RadioListTile<String>(
          value: 'بطاقة •••• 8075',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('Mastercard •••• 8075'),
        ),
        RadioListTile<String>(
          value: 'بطاقة •••• 2590',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('Mastercard •••• 2590'),
        ),
        RadioListTile<String>(
          value: 'دفع عند التسليم',
          groupValue: payment,
          onChanged: (v) => setState(() => payment = v!),
          title: const Text('كاش عند التسليم'),
        ),
        const Divider(height: 32),
        PaymentSummary(
          subtotal: app.subtotal,
          discount: app.discount,
          delivery: app.isFreeDelivery ? 0 : app.deliveryFee,
          service: app.serviceFee,
          tips: app.tips,
          total: app.finalTotal,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            info.paymentMethod = payment;
            info.address = app.savedAddresses[selectedAddress].details;
            app.placeOrder(info);
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderPlacedScreen()),
                    (route) => route.isFirst,
              );
            }
          },
          child: const Text('تأكيد الطلب'),
        ),
      ]),
    );
  }
}

Widget sectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 96, color: Brand.secondary),
            const SizedBox(height: 16),
            const Text('تم تأكيد طلبك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('الراكب راح يوصل تقريبًا خلال 15 - 25 دقيقة'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                    (route) => false,
              ),
              child: const Text('تتبع الطلب'),
            ),
          ]),
        ),
      ),
    );
  }
}

// ===================== UI: ORDERS & TRACKING =====================
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: app.orders.isEmpty
          ? const _EmptyOrders()
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final o = app.orders[i];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text(app.restaurant.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${formatDate(o.dateTime)}  •  ${o.lines.length} عنصر\nرقم الطلب: ${o.id}\nالمستخدم: ${o.customerEmail}'),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('د.ع ${formatIQD(o.total)}', style: const TextStyle(fontWeight: FontWeight.w700))],
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: o)),
              ),
            ),
          );
        },
        separatorBuilder: (context, __) => const SizedBox(height: 8),
        itemCount: app.orders.length,
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: cs.outline),
          const SizedBox(height: 12),
          const Text('ما عندك طلبات بعد'),
          const SizedBox(height: 6),
          Text('بلّش تختار أكلك من قائمة المطعم', style: TextStyle(color: cs.onSurface.withOpacity(.7))),
        ]),
      ),
    );
  }
}

class OrderTrackingScreen extends StatefulWidget {
  final Order? order;
  const OrderTrackingScreen({super.key, this.order});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late OrderStatus status;
  @override
  void initState() {
    super.initState();
    status = widget.order?.status ?? OrderStatus.preparing;
  }
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          StatusTile(label: 'جاري التحضير', active: status.index >= OrderStatus.preparing.index, color: cs.primary),
          StatusTile(label: 'تم الاستلام من المطعم', active: status.index >= OrderStatus.pickedUp.index, color: cs.secondary),
          StatusTile(label: 'في الطريق إليك', active: status.index >= OrderStatus.onTheWay.index, color: cs.tertiary),
          StatusTile(label: 'تم التسليم', active: status.index >= OrderStatus.delivered.index, color: Colors.teal),
          const Spacer(),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.pickedUp),
                child: const Text('تحديد: تم الاستلام'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: status.index >= OrderStatus.onTheWay.index || status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.onTheWay),
                child: const Text('تحديد: في الطريق'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: status == OrderStatus.delivered ? null : () => setState(() => status = OrderStatus.delivered),
                child: const Text('تحديد: تم التسليم'),
              ),
            ),
          ])
        ]),
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String label; final bool active; final Color color;
  const StatusTile({super.key, required this.label, required this.active, required this.color});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, color: active ? color : cs.outline),
      title: Text(label, style: TextStyle(color: active ? cs.onSurface : cs.onSurface.withOpacity(.7))),
    );
  }
}

// ===================== UI: ACCOUNT & AUTH =====================
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    if (!app.isLoggedIn) return const AuthScreen();
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(app.currentUser!.name),
          subtitle: Text(app.currentUser!.email),
          trailing: TextButton(onPressed: app.signOut, child: const Text('تسجيل خروج')),
        ),
        const Divider(),
        const ListTile(leading: Icon(Icons.card_giftcard_outlined), title: Text('النقاط')),
        const ListTile(leading: Icon(Icons.receipt_long_outlined), title: Text('طلباتي')),
        const ListTile(leading: Icon(Icons.account_balance_wallet_outlined), title: Text('المحفظة')),
        const ListTile(leading: Icon(Icons.percent_outlined), title: Text('كوبونات')),
        const ListTile(leading: Icon(Icons.help_outline), title: Text('مساعدة')),
        const ListTile(leading: Icon(Icons.info_outline), title: Text('عن التطبيق')),
      ]),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailCtrl = TextEditingController(text: 'demo@hallglow.com');
  final passCtrl = TextEditingController(text: '123456');
  final nameCtrl = TextEditingController();
  bool isLogin = true;
  String? error;

  @override
  Widget build(BuildContext context) {
    final app = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'تسجيل دخول' : 'إنشاء حساب')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (!isLogin)
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'الاسم'),
          ),
        if (!isLogin) const SizedBox(height: 12),
        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'الإيميل'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'كلمة المرور'),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: Colors.red))
        ],
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            String? e;
            if (isLogin) {
              e = await app.signIn(emailCtrl.text.trim(), passCtrl.text);
            } else {
              e = await app.signUp(
                nameCtrl.text.trim().isEmpty ? 'مستخدم' : nameCtrl.text.trim(),
                emailCtrl.text.trim(),
                passCtrl.text,
              );
            }
            if (e != null) {
              setState(() => error = e);
            } else {
              if (mounted) Navigator.pop(context, true);
            }
          },
          child: Text(isLogin ? 'دخول' : 'تسجيل'),
        ),
        TextButton(
          onPressed: () => setState(() => isLogin = !isLogin),
          child: Text(isLogin ? 'ما عندك حساب؟ سجل الآن' : 'عندك حساب؟ سجّل دخول'),
        ),
      ]),
    );
  }
}

// ===================== HELPERS =====================
String formatIQD(int v) {
  final s = v.toString();
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return s.replaceAll(reg, ',');
}

String formatDate(DateTime dt) {
  const months = ['ينا','فبر','مار','أبر','ماي','يون','يول','آغس','سبت','أكت','نوف','ديس'];
  final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final ampm = dt.hour >= 12 ? 'م' : 'ص';
  final min = dt.minute.toString().padLeft(2, '0');
  return '${months[dt.month - 1]} ${dt.day} • $h12:$min$ampm';
}

String buildAddOnsText(List<AddOn> a) {
  if (a.isEmpty) return 'بدون إضافات';
  return a
      .map((e) => e.price > 0 ? '${e.name} (+${formatIQD(e.price)})' : e.name)
      .join('، ');
}
