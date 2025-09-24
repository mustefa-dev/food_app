import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget { const CheckoutScreen({super.key}); @override State<CheckoutScreen> createState()=> _CheckoutScreenState(); }
class _CheckoutScreenState extends State<CheckoutScreen> {
  String? address='Home'; String payment='cash'; int tipPct=0;
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Checkout')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Delivery address', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:8),
        DropdownButtonFormField(value: address, items: const [DropdownMenuItem(value:'Home',child:Text('Home')), DropdownMenuItem(value:'Work',child:Text('Work'))], onChanged: (v)=> setState(()=> address=v)),
        const SizedBox(height:16),
        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile(value:'cash', groupValue:payment, onChanged:(v)=> setState(()=> payment=v!), title: const Text('Cash')),
        RadioListTile(value:'card', groupValue:payment, onChanged:(v)=> setState(()=> payment=v!), title: const Text('Card')),
        const SizedBox(height:16),
        const Text('Tip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(spacing:8, children: [ for (final p in [0,10,15,20]) ChoiceChip(label: Text('$p%'), selected: tipPct==p, onSelected: (_)=> setState(()=> tipPct=p)) ]),
        const SizedBox(height:100),
      ]),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: FilledButton(onPressed: (){/* TODO sync order */}, child: const Text('Confirm Order')))),
    );
  }
}
