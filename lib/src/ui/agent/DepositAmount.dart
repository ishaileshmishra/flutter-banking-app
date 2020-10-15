import 'package:alok/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositeAmount extends StatefulWidget {
  @override
  _DepositeAmountState createState() => _DepositeAmountState();
}

class _DepositeAmountState extends State<DepositeAmount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Res.accentColor,
          elevation: 0,
          centerTitle: true,
          title: Text('Deposite'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //====================================
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide( color: Res.accentColor)),
                      hintText: 'Transaction Id',
                      //helperText: 'Pls provide transaction id.',
                      labelText: 'Transaction Id',
                      prefixIcon: const Icon(
                        Icons.perm_identity_rounded,
                        color: CupertinoColors.inactiveGray,
                      ),
                      prefixText: ' ',
                      suffixText: 'NUM',
                      suffixStyle:
                          const TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                //====================================
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Res.accentColor)),
                      hintText: 'Amount',
                      //helperText: 'Pls provide amount.',
                      labelText: 'Amount',
                      prefixIcon: const Icon(
                        Icons.money,
                        color: CupertinoColors.inactiveGray,
                      ),
                      prefixText: ' ',
                      suffixText: 'NUM',
                      suffixStyle:
                          const TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                //====================================
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Res.accentColor)),
                      hintText: 'Remark',
                      //helperText: 'Pls provide remark.',
                      labelText: 'Remark',
                      prefixIcon: const Icon(
                        Icons.text_fields,
                        color: CupertinoColors.inactiveGray,
                      ),
                      prefixText: ' ',
                      suffixStyle:
                          const TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                //====================================
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    child: Text('Submit'),
                    color: Res.primaryColor,
                    onPressed: () {
                      // Write your callback here
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
