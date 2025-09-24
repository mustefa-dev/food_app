import 'package:flutter/material.dart';

enum AppLang { en, ar }

class I18n extends InheritedWidget {
  final AppLang lang;
  final Map<String, String> t;
  const I18n({super.key, required this.lang, required this.t, required super.child});
  static I18n of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<I18n>()!;
  @override
  bool updateShouldNotify(I18n oldWidget) => oldWidget.lang != lang;
}

final kTranslations = <AppLang, Map<String,String>>{
  AppLang.en: {
    'appTitle':'OrangeEats','home':'Home','orders':'Orders','profile':'Profile','login':'Login','register':'Register',
    'email':'Email','password':'Password','fullName':'Full name','signIn':'Sign in','createAccount':'Create account',
    'logout':'Logout','scanQr':'Scan QR','favorites':'Favorites','addRestaurant':'Add restaurant','setDefault':'Set as default','remove':'Remove',
    'popular':'Popular near you','searchPlaceholder':'Search restaurants or dishes','viewMenu':'View menu','minutes':'min',
    'cart':'Cart','checkout':'Checkout','subtotal':'Subtotal','taxes':'Taxes','deliveryFee':'Delivery fee','total':'Total','proceedToCheckout':'Proceed to checkout',
    'confirmOrder':'Confirm Order','tip':'Tip','address':'Address','payment':'Payment Method','cash':'Cash','card':'Card','language':'Language',
    'arabic':'Arabic','english':'English','autoOpenLast':'Auto-open last restaurant','offline':'Offline — showing cached data','refreshing':'Refreshing…',
    'noData':'No data yet'
  },
  AppLang.ar: {
    'appTitle':'أورنج إيتس','home':'الرئيسية','orders':'الطلبات','profile':'الملف الشخصي','login':'تسجيل الدخول','register':'إنشاء حساب',
    'email':'الإيميل','password':'كلمة المرور','fullName':'الاسم الكامل','signIn':'دخول','createAccount':'إنشاء حساب',
    'logout':'تسجيل الخروج','scanQr':'سكان QR','favorites':'المفضلة','addRestaurant':'إضافة مطعم','setDefault':'تعيين كافتراضي','remove':'إزالة',
    'popular':'الأكثر طلباً قريبك','searchPlaceholder':'دور على مطاعم أو أكلات','viewMenu':'شوف المنيو','minutes':'د',
    'cart':'السلة','checkout':'الدفع','subtotal':'المجموع الفرعي','taxes':'الضرائب','deliveryFee':'رسوم التوصيل','total':'الإجمالي','proceedToCheckout':'انتقال للدفع',
    'confirmOrder':'تأكيد الطلب','tip':'بقشيش','address':'العنوان','payment':'طريقة الدفع','cash':'نقدًا','card':'بطاقة','language':'اللغة',
    'arabic':'العربية','english':'الإنجليزية','autoOpenLast':'فتح آخر مطعم تلقائياً','offline':'أوفلاين — نعرض بيانات مخزنة','refreshing':'جاري التحديث…',
    'noData':'لا توجد بيانات بعد'
  }
};

bool isRtl(AppLang lang) => lang == AppLang.ar;
