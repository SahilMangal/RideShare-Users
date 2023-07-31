import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PayFareAmountDialog extends StatefulWidget {

  double? fareAmount;

  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      //elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF2D2727),
          border: Border.all(color: Color(0xFFff725e), width: 2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFff725e),
              blurRadius: 4,
              offset: Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 20,),

            Text(
              "Fare Amount".toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color(0xFFff725e),
                  fontFamily: "Ubuntu"
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xFFff725e),
            ),

            const SizedBox(height: 20,),

            // Fare Amount Text
            Text(
               "\$" + widget.fareAmount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFFff725e),
                  fontFamily: "Ubuntu"
              ),
            ),

            const SizedBox(height: 10,),

            // Text message - This is the total trip fare amount, Please Pay it the driver.
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip fare amount, Please Pay it the driver.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Ubuntu"
                ),
              ),
            ),

            const SizedBox(height: 10,),

            // Pay Buttons
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [

                  // Cash Payed Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFff725e),
                    ),
                    onPressed: (){
                      Future.delayed(const Duration(milliseconds: 2000), (){
                        Navigator.pop(context, "cashPayed");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Pay Cash",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Ubuntu"
                          ),
                        ),
                        Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10,),

                  // Using PalPal

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFff725e),
                    ),
                    onPressed: () {

                      // PayPal Integration - Started
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => UsePaypal(
                              sandboxMode: true,
                              clientId:
                              "Adi3W0nvKryIJEJ6w911AC5QdvxS_QKQeJg3jHYUvrtKqCn9W1jI5ctH-fCu4ACyw3bPOf-WaJ1dvpga",
                              secretKey:
                              "EN6LHUY2AR1gwC9dIFNFojat_Bp6UZnLUvD11bVQcRMlhV7DXtODJuy8iyjORfYYBa8sFFhCOzMuMmo-",
                              returnURL: "https://gogole.com",
                              cancelURL: "https://gogole.com",
                              transactions: const [
                                {
                                  "amount": {
                                    "total": '10.12',
                                    "currency": "CAD",
                                    "details": {
                                      "subtotal": '10.12',
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                  "The payment transaction description.",
                                  "item_list": {
                                    "items": [
                                      {
                                        "name": "A demo product",
                                        "quantity": 1,
                                        "price": '10.12',
                                        "currency": "CAD"
                                      }
                                    ],
                                  }
                                }
                              ],
                              note: "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                Navigator.pop(context, "PayPalPayment");
                              },
                              onError: (error) {
                                Navigator.pop(context, "PaymentException");
                              },
                              onCancel: (params) {
                                Navigator.pop(context, "PaymentException");
                              }),
                        ),
                      );
                      // PayPal Integration - Ended

                       Future.delayed(const Duration(milliseconds: 2000), (){
                         Navigator.pop(context, "PayPalPayment");
                       });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Pay with PayPal",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Ubuntu"
                          ),
                        ),
                        Icon(
                          Icons.paypal,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ),

            const SizedBox(height: 5,),

          ],
        ),
      ),
    );
  }
}
