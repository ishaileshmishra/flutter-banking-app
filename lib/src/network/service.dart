import 'package:alok/src/models/DashboardModel.dart';
import 'package:flutter/material.dart';

mixin Reposit {
  static List<CatModel> getCategories() {
    List<CatModel> categories = new List<CatModel>();

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Colors.black,
        ),
        'Create Account'));
    categories.add(new CatModel(
        Icon(
          Icons.money,
          size: 40,
          color: Colors.black,
        ),
        'Deposit Amount'));
    categories.add(new CatModel(
        Icon(
          Icons.payments_sharp,
          size: 40,
          color: Colors.black,
        ),
        'Passbook'));

    return categories;
  }

  static List<CatModel> getAgentCategories() {
    List<CatModel> categories = new List<CatModel>();

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Colors.black,
        ),
        'Deposite Amount'));

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Colors.black,
        ),
        'Recurring Deposite'));

    return categories;
  }
}
