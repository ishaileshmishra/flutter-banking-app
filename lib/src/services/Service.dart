import 'package:alok/src/models/DashboardModel.dart';
import 'package:flutter/material.dart';

mixin Reposit {
  static List<CatModel> getCategories() {
    List<CatModel> categories = new List<CatModel>();
    categories.add(new CatModel(
        Icon(
          Icons.group,
          size: 40,
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
        'Fund Transfer'));
    categories.add(new CatModel(
        Icon(
          Icons.integration_instructions_outlined,
          size: 40,
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
        'Standing Instructions'));
    categories.add(new CatModel(
        Icon(
          Icons.arrow_circle_down,
          size: 40,
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
        'POSB Sweep In'));
    categories.add(new CatModel(
        Icon(
          Icons.arrow_circle_up,
          size: 40,
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
        'POSB Sweep Out'));
    categories.add(new CatModel(
        Icon(
          Icons.qr_code_outlined,
          size: 40,
          color: Color.fromRGBO(143, 148, 251, 1),
        ),
        'Pay By QR'));
    return categories;
  }
}