import '../models/models.dart';

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

