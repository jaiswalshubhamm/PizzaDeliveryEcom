import 'package:flutter/material.dart';
import 'package:pizzadeliveryecom/Config/Constant.dart';
import 'package:pizzadeliveryecom/Helpers/order.dart';
import 'package:pizzadeliveryecom/Models/cartItem.dart';
import 'package:pizzadeliveryecom/Providers/app.dart';
import 'package:pizzadeliveryecom/Providers/user.dart';
import 'package:pizzadeliveryecom/Widgets/cartProducts.dart';
import 'package:pizzadeliveryecom/Widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.1,
        title: Text('Shopping Cart'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: app.isLoading ? Loading() : CartProducts(),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                        color: grey,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "\$${user.userModel.totalCartPrice / 100}",
                      style: TextStyle(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: primary),
                child: MaterialButton(
                  onPressed: () {
                    if (user.userModel.totalCartPrice == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Your cart is empty',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'You will be charged \$${user.userModel.totalCartPrice / 100} on delivery!',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: 320,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        var uuid = Uuid();
                                        String id = uuid.v4();
                                        _orderServices.createOrder(
                                            userId: user.user.uid,
                                            id: id,
                                            description:
                                                "Some random Description",
                                            status: 'Complete',
                                            totalPrice:
                                                user.userModel.totalCartPrice,
                                            cart: user.userModel.cart);
                                        for (CartItemModel cartItem
                                            in user.userModel.cart) {
                                          bool value =
                                              await user.removeFromCart(
                                            cartItem: cartItem,
                                          );
                                          if (value) {
                                            user.reloadUserModel();
                                            print("Item added to Cart");
                                            _key.currentState.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Removed from Cart!",
                                                ),
                                              ),
                                            );
                                          } else {
                                            print('Item was not removed');
                                          }
                                        }
                                        _key.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text("Order Created!"),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(color: white),
                                      ),
                                      color: primary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(color: white),
                                      ),
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Check out',
                    style: TextStyle(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  color: primary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
