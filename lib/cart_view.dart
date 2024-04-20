import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          badges.Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            badgeAnimation: const badges.BadgeAnimation.scale(),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: ((BuildContext context,
                    AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('images/empty_cart.png')),
                          Text('Explore Products'),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Card(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(
                                              data.image.toString())),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data.productName.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    dbHelper.delete(snapshot
                                                        .data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(
                                                        double.parse(data
                                                            .productPrice
                                                            .toString()));
                                                  },
                                                  child:
                                                      const Icon(Icons.delete))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data.unitTag.toString() +
                                                " " +
                                                r"$" +
                                                data.productPrice.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      int quantity =
                                                          data.quantity!;
                                                      int price =
                                                          data.initialPrice!;
                                                      quantity--;
                                                      int? newPrice =
                                                          quantity * price;

                                                      if (quantity > 0) {
                                                        dbHelper
                                                            .updateQuantity(
                                                          Cart(
                                                              id: data.id,
                                                              productId: data
                                                                  .productId
                                                                  .toString(),
                                                              productName: data
                                                                  .productName,
                                                              initialPrice: data
                                                                  .initialPrice,
                                                              productPrice:
                                                                  newPrice,
                                                              quantity:
                                                                  quantity,
                                                              unitTag:
                                                                  data.unitTag,
                                                              image:
                                                                  data.image),
                                                        )
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(
                                                              double.parse(data
                                                                  .initialPrice!
                                                                  .toString()));
                                                          print('successful');
                                                        }).onError((error,
                                                                stackTrace) {
                                                          print(
                                                              error.toString());
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    )),
                                                Text(
                                                  data.quantity.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      int quantity =
                                                          data.quantity!;
                                                      int price =
                                                          data.initialPrice!;
                                                      quantity++;
                                                      int? newPrice =
                                                          quantity * price;

                                                      dbHelper
                                                          .updateQuantity(
                                                        Cart(
                                                            id: data.id,
                                                            productId: data
                                                                .productId
                                                                .toString(),
                                                            productName: data
                                                                .productName,
                                                            initialPrice: data
                                                                .initialPrice,
                                                            productPrice:
                                                                newPrice,
                                                            quantity: quantity,
                                                            unitTag:
                                                                data.unitTag,
                                                            image: data.image),
                                                      )
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(
                                                            double.parse(data
                                                                .initialPrice!
                                                                .toString()));
                                                        print('successful');
                                                      }).onError((error,
                                                              stackTrace) {});
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ));
                            }),
                      );
                    }
                  }
                  return Text('data');
                })),
            Consumer<CartProvider>(builder: (context, value, child) {
              double discount = 5 * value.getTotalPrice() / 100;
              double newTotal = value.getTotalPrice() - discount;
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(children: [
                  ReusableWidget(
                      title: 'Sub Total',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                  ReusableWidget(
                      title: 'Discount 5%',
                      value: r'$' + discount.toStringAsFixed(2)),
                  ReusableWidget(
                      title: 'Total',
                      value: r'$' + newTotal.toStringAsFixed(2)),
                ]),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
