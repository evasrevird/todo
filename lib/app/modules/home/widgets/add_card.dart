import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/data/models/task.dart';
import 'package:todo/app/modules/home/controller.dart';
import 'package:todo/app/modules/home/widgets/icons.dart';

class AddCard extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'task\'s title',
              content: Form(
                key: homeController.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        controller: homeController.editController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          return (value == null || value.trim().isEmpty)
                              ? 'Enter something'
                              : null;
                        },
                      ),
                    ),
                    Wrap(
                      spacing: 2.0.wp,
                      children: icons
                          .map((e) => Obx(() {
                                final index = icons.indexOf(e);
                                return ChoiceChip(
                                  // avatar: Icon(Icons.abc),
                                  showCheckmark: false,
                                  // backgroundColor: Colors.white,
                                  side: BorderSide.none,
                                  label: e,
                                  selected:
                                      homeController.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeController.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              }))
                          .toList(),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        onPressed: () {
                          if (homeController.formKey.currentState!.validate()) {
                            int icon = icons[homeController.chipIndex.value]
                                .icon!
                                .codePoint;
                            String color = icons[homeController.chipIndex.value]
                                .color!
                                .toHex();
                            var task = Task(
                                title: homeController.editController.text,
                                icon: icon,
                                color: color);
                            Get.back();
                            homeController.addTask(task)
                                ? EasyLoading.showSuccess('New note created')
                                : EasyLoading.showError('Duplicated!');
                          }
                        },
                        child: const Text('Confirm'))
                  ],
                ),
              ));
          homeController.editController.clear();
          homeController.changeChip(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
