import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:maitungsi/model.dart';

class PieChart extends StatelessWidget {
  final List<CategoryList> categoryList;

  PieChart({this.categoryList});

  List<charts.Series<CategoryList, String>> createSampleDate(List list) {
    return [
      charts.Series<CategoryList, String>(
        id: 'Category',
        colorFn: (_, index) =>
            charts.MaterialPalette.deepOrange.makeShades(list.length)[index],
        domainFn: (CategoryList series, _) => series.category,
        measureFn: (CategoryList series, _) => series.value,
        data: list,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      createSampleDate(categoryList),
      animate: true,
      defaultRenderer:
          charts.ArcRendererConfig(arcWidth: 80, arcRendererDecorators: [
        charts.ArcLabelDecorator(
            outsideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.Color.white,
          fontSize: 12,
        ))
      ]),
    );
  }
}
