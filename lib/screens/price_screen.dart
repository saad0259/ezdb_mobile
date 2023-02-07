import 'package:flutter/material.dart';

class PriceScreen extends StatelessWidget {
  PriceScreen({super.key});

  final List<PriceItem> _priceItems = [
    PriceItem(price: 200, days: 30),
    PriceItem(price: 500, days: 90),
    PriceItem(price: 750, days: 120),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemCount: _priceItems.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Text(
                'RM ${_priceItems[index].price.round()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text('${_priceItems[index].days} Days'),
            ),
          );
        },
      ),
    );
  }
}

class PriceItem {
  double price;
  int days;
  PriceItem({required this.price, required this.days});
}
