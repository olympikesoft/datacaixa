import 'package:datacaixa/store/app_state.dart';
import 'package:datacaixa/ui/table_view.dart';
import 'package:flutter/material.dart';
import 'package:datacaixa/models/table.dart' as table;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return FutureBuilder<List<table.Table>>(
            future: tableStore.getTables(),
            builder: (context, snapshot) =>
            tableStore.tables.isNotEmpty ?
            AnimationLimiter(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(tableStore.tables.length, (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    columnCount: 1,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: TableView(
                            tableStore.tableNumber(index)
                        ),
                      ),
                    ),
                  );
                },
                ),
              ),
            ): Container(),
        );
      }
    );
  }
}