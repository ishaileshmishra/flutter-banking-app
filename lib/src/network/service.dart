import 'package:alok/res.dart';
import 'package:alok/src/models/DashboardModel.dart';
import 'package:flutter/material.dart';

mixin Reposit {
  static List<CatModel> getCategories() {
    List<CatModel> categories = new List<CatModel>();

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Res.accentColor,
        ),
        'Create Account'));
    categories.add(new CatModel(
        Icon(
          Icons.money,
          size: 40,
          color: Res.accentColor,
        ),
        'Deposit Amount'));

    return categories;
  }

  static List<CatModel> getAgentCategories() {
    List<CatModel> categories = new List<CatModel>();

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Res.accentColor,
        ),
        'Deposite Amount'));

    categories.add(new CatModel(
        Icon(
          Icons.supervised_user_circle_outlined,
          size: 40,
          color: Res.accentColor,
        ),
        'Recurring Deposite'));

    return categories;
  }
}
