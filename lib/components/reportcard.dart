import 'package:flutter/material.dart';
import 'package:maitungsi/model.dart';
import 'package:intl/intl.dart';
import 'package:maitungsi/constants.dart';

class ReportCard extends StatelessWidget {
  ReportCard({@required this.value, this.detail, this.category});
  final double value;
  final List<DetailList> detail;
  final String category;
  final f = NumberFormat("#,###.0#", "en_US");

  List<Widget> generateList(List<DetailList> detail) {
    List<Widget> detailedList = [];
    for (var item in detail) {
      detailedList.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          leading: Icon(
            Icons.check,
            color: kSecondaryColor,
          ),
          title: Text(
            item.itemName,
            style: kSecondaryTextStyle,
          ),
          trailing: Text(f.format(item.value), style: kSecondaryTextStyle),
        ),
      ));
    }

    return detailedList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        color: kPrimaryColor,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: ExpansionTile(
          title: Text(
            f.format(this.value),
            style: kMainTextStyle,
          ),
          leading: Container(
            padding: EdgeInsets.only(right: 10.0),
            decoration: kBoxBorderOneSide,
            child: Text(
              category,
              style: kMainTextStyle.copyWith(
                  color: kSecondaryColor, fontStyle: FontStyle.italic),
            ),
          ),
          children: generateList(detail),
        ));
  }
}
