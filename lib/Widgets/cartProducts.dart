import 'package:flutter/material.dart';
import 'package:pizzadeliveryecom/Config/Constant.dart';
import 'package:pizzadeliveryecom/Providers/app.dart';
import 'package:pizzadeliveryecom/Providers/user.dart';
import 'package:provider/provider.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return user.userModel.cart.length < 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: grey,
                    size: 30,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Products found",
                    style: TextStyle(
                      color: grey,
                      fontWeight: FontWeight.w300,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ],
          )
        : ListView.builder(
            itemCount: user.userModel.cart.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.2),
                          offset: Offset(3, 2),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            user.userModel.cart[index].image,
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: user.userModel.cart[index].name +
                                          "\n",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "\$${user.userModel.cart[index].price / 100} \n\n",
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Quantity: ",
                                      style: TextStyle(
                                        color: grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: user.userModel.cart[index].quantity
                                          .toString(),
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: primary,
                                ),
                                onPressed: () async {
                                  app.changeLoading();
                                  bool value = await user.removeFromCart(
                                      cartItem: user.userModel.cart[index]);
                                  if (value) {
                                    user.reloadUserModel();
                                    print("Item added to cart");
                                    _key.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Removed from Cart!"),
                                      ),
                                    );
                                    app.changeLoading();
                                    return;
                                  } else {
                                    print("Item was not Removed");
                                    app.changeLoading();
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          );
  }
}
