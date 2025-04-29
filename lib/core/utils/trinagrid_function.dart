import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';
import 'check.dart';
import 'helper.dart';

class TrinaGridFuntion {
  ///FILTER**********************************************************************************************
  // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc
  List<dynamic> _getUniqueValues(String field, List<TrinaRow> currentRows, {bool isNgay = false, bool isNumber =false}) {
    final data = currentRows.map((row) => row.cells[field]!.value.toString()).toSet().toList();

    if (isNgay) {
      List<DateTime?> dateList = data.map((e) => Helper.stringToDate(e)).toList();
      dateList.sort();
      return dateList.map((e) => Helper.dateFormatDMY(e!)).toList();
    }
    if(isNumber){
      List<double> x = data.map((e) => double.parse(e)).toList();
      x.sort();
      return x.map((e){
        if(e==0.0) return '0';
        if(Check().isInteger(e)){
          return e.toInt().toString();
        }else{
          return e.toString();
        }
      }).toList();
    }
    data.sort();
    return data;
  }

  Widget builTitle(
    TrinaColumnTitleRendererContext render,
    Map<String, List<dynamic>> filters,
    void Function() applyFilters, {
    bool isNgay = false,
    bool isNummber = false,
    bool enabelFilter = false,
  }) {
    final List<TrinaRow> filteredRows =
        render.stateManager.filterRows.isNotEmpty ? render.stateManager.filterRows : render.stateManager.rows;

    List<dynamic> availableValues = _getUniqueValues(render.column.field, filteredRows, isNgay: isNgay,isNumber: isNummber);
    Map<String, bool> map = {
      for (var value in availableValues) value.toString(): filters[render.column.field]!.contains(value),
    };
    return DataGridTitle(
      isFilter: filters[render.column.field]!.isNotEmpty,
      isNumber: isNummber,
      title: render.column.title,
      onChanged: (val) {
        filters[render.column.field] =
            val.entries
                .where((e) => e.value)
                .map((e) => availableValues.firstWhere((v) => v.toString() == e.key))
                .toList();
        applyFilters();
      },
      items: map,
      enabelFilter: enabelFilter,
    );
  }

  ///**********************************************************************************************FILTER
}
