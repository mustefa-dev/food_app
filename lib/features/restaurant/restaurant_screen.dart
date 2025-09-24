import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../src/models/models.dart';
import '../../src/state/app_state.dart';
import '../../src/utils/helpers.dart';
import '../../src/i18n/i18n.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int categoryIndex = 0;
  final _scrollController = ScrollController();
  final String _headerImageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(NetworkImage(_headerImageUrl), context);
      try {
        final app = AppStateWidget.of(context);
        final items = app.restaurant.categories.first.items;
        for (var i = 0; i < items.length && i < 4; i++) {
          precacheImage(NetworkImage(items[i].imageUrl), context);
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);
    final r = app.restaurant;
    final cat = r.categories[categoryIndex];
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      cacheExtent: 1000.0,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 220,
          surfaceTintColor: Colors.transparent,
          backgroundColor: cs.surface,
          leading: Navigator.canPop(context) ? BackButton(color: cs.onSurface) : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.t('common.search_tapped'))),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsets.only(right: 16, left: 16, bottom: 12),
            title: Text(
              textOf(context, r.name),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            background: Stack(fit: StackFit.expand, children: [
              CachedNetworkImage(
                imageUrl: _headerImageUrl, fit: BoxFit.cover,
                memCacheWidth: 1600, memCacheHeight: 900,
                placeholder: (context, url) => Container(color: cs.surfaceContainerLow),
                errorWidget: (context, url, error) => Container(color: cs.surfaceContainerLow),
              ),
              Container(decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]),
              )),
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
                  label: Text(textOf(context, c.name)),
                  selected: selected,
                  selectedColor: cs.secondary,
                  labelStyle: TextStyle(color: selected ? cs.onSecondary : cs.onSurface),
                  onSelected: (v) {
                    setState(() => categoryIndex = i);
                    if (v) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        try {
                          final items = AppStateWidget.of(context).restaurant.categories[i].items;
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
    final t = I18nProvider.of(context);
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
            color: cs.surface, borderRadius: BorderRadius.circular(14),
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
            Text(t.t('restaurant.time_range', params: {'min': r.deliveryMinutesMin, 'max': r.deliveryMinutesMax})),
            const Spacer(),
            const Icon(Icons.delivery_dining_outlined, size: 18),
            const SizedBox(width: 6),
            Text(
              '${currencyLabel(context)}${AppStateWidget.of(context).isFreeDelivery ? 0 : r.deliveryFee}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !reached
              ? Container(
            key: const ValueKey('bar1'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: cs.tertiary.withOpacity(.10), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.local_shipping_outlined, color: cs.tertiary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.t('restaurant.add_more_for_free_delivery', params: {'remain': formatIQD(remain)}),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8, value: progress, color: cs.tertiary, backgroundColor: cs.tertiary.withOpacity(.25),
                ),
              ),
            ]),
          )
              : Container(
            key: const ValueKey('bar2'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: cs.secondary.withOpacity(.12), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.verified, color: cs.secondary),
              const SizedBox(width: 8),
              Expanded(child: Text(t.t('restaurant.free_delivery_activated'), style: const TextStyle(fontWeight: FontWeight.w700))),
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
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailBottomSheet(item: item))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(textOf(context, item.title), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(textOf(context, item.description), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 10),
              Text('${currencyLabel(context)}${formatIQD(item.price)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cs.primary)),
            ]),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 112, height: 92,
            child: Stack(children: [
              Hero(
                tag: 'img_${item.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl, width: 112, height: 92, fit: BoxFit.cover,
                    memCacheWidth: 224, memCacheHeight: 184,
                    placeholder: (context, url) => Container(width: 112, height: 92, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(14))),
                    errorWidget: (context, url, error) => Container(width: 112, height: 92, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.image_not_supported, color: Colors.grey)),
                  ),
                ),
              ),
              Positioned(
                right: 6, bottom: 6,
                child: Material(
                  color: cs.primary, shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => app.addToCart(item),
                    child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.add, color: Colors.white, size: 20)),
                  ),
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }
}

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
    final t = I18nProvider.of(context);
    final app = AppStateWidget.of(context);
    final item = widget.item;
    final addOnsPrice = selected.fold(0, (s, a) => s + a.price);
    final unitTotal = item.price + addOnsPrice;
    final lineTotal = unitTotal * qty;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textOf(context, item.title))),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: SizedBox(
          height: 52,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => qty = (qty - 1).clamp(1, 99))),
                Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => qty = (qty + 1).clamp(1, 99))),
              ]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  app.addToCart(item, quantity: qty, addOns: List.of(selected));
                  Navigator.pop(context);
                },
                child: Text(t.t('item.add_price', params: {'amount': formatIQD(lineTotal)})),
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
              imageUrl: item.imageUrl, height: 220, fit: BoxFit.cover, memCacheWidth: 1200,
              placeholder: (context, url) => Container(height: 220, color: cs.surfaceContainerLow),
              errorWidget: (context, url, error) => Container(height: 220, color: cs.surfaceContainerLow),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(textOf(context, item.title), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(textOf(context, item.description)),
        if (item.addOns.isNotEmpty) ...[
          const SizedBox(height: 16),
          sectionTitle(t.t('item.addons')),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in item.addOns)
              FilterChip(
                label: Text('${textOf(context, a.name)}${a.price > 0 ? ' • ${currencyLabel(context)}${formatIQD(a.price)}' : ''}'),
                selected: selected.contains(a),
                selectedColor: cs.secondary.withOpacity(.18),
                onSelected: (v) => setState(() { v ? selected.add(a) : selected.remove(a); }),
              )
          ])
        ],
        const SizedBox(height: 16),
        sectionTitle(t.t('item.delivery_notes')),
        Wrap(spacing: 8, children: [
          QuickPill(t.t('pill.no_bell')),
          QuickPill(t.t('pill.call_on_arrival')),
          QuickPill(t.t('pill.extra_sauce')),
        ]),
        const SizedBox(height: 8),
        TextField(controller: noteCtrl, minLines: 2, maxLines: 4, decoration: InputDecoration(hintText: t.t('item.write_note'))),
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
