import 'package:nuPro/library/components/dropdown/io_dropdown_sheet_model.dart';
import 'package:nuPro/library/components/main/io_sliver_header.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IODropdownSheet<T> extends StatelessWidget {
  final String title;
  final List<IODropdownSheetModel<T>> items;
  const IODropdownSheet({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.8,
      builder: (context, scroll) {
        return Container(
          decoration: const BoxDecoration(
            color: IOColors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: CustomScrollView(
            controller: scroll,
            slivers: [
              IOSliverHeader(
                pinned: true,
                min: 76,
                max: 76,
                child: Container(
                  decoration: const BoxDecoration(
                    color: IOColors.backgroundPrimary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: IOColors.textQuarternary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: IOStyles.body1Bold,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: () {
                        Get.back(result: items[index]);
                      },
                      title: Text(
                        items[index].name,
                        style: IOStyles.body2Semibold,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 1, thickness: 1);
                },
                itemCount: items.length,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<IODropdownSheetModel<T>?> show() {
    return Get.bottomSheet(this, isScrollControlled: true);
  }
}
