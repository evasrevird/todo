import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/controller.dart';

class OngoingList extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  OngoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.ongoingTodos.isEmpty &&
              homeController.finishedTodos.isEmpty
          ? Column(
              children: [
                Image.asset(
                  'assets/images/task.jpg',
                  fit: BoxFit.cover,
                  width: 65.0.wp,
                ),
                Text(
                  'Add task ?',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                ),
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeController.ongoingTodos.map((element) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp, horizontal: 9.0.wp),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: element['done'],
                              onChanged: (value) {
                                homeController.doneTodo(element['title']);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                            child: Text(
                              element['title'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),
                if (homeController.ongoingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0.wp,
                    ),
                    child: const Divider(
                      thickness: 2,
                    ),
                  ),
              ],
            ),
    );
  }
}
