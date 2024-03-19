import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/controller.dart';

class FinishedList extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  FinishedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeController.finishedTodos.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Text(
                  'Completed (${homeController.finishedTodos.length})',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
                ),
                ...homeController.finishedTodos.map((element) => Dismissible(
                      key: ObjectKey(element),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          homeController.deleteDoneTodo(element),
                      background: Container(
                        color: Colors.red.withOpacity(.8),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.0.wp),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.wp, vertical: 3.0.wp),
                        child: Wrap(
                          spacing: 3.0.wp,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: Icon(Icons.done),
                            ),
                            Text(
                              element['title'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )
        : Container());
  }
}
