import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/values/colors.dart';
import 'package:todo/app/data/models/task.dart';
import 'package:todo/app/modules/home/controller.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/widgets/add_card.dart';
import 'package:todo/app/modules/home/widgets/add_dialog.dart';
import 'package:todo/app/modules/home/widgets/task_card.dart';

import '../summary/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: [
          SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    'My todo list',
                    style: TextStyle(
                        fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      // TaskCard(
                      //   task:
                      //   const Task(title: 'title', icon: 0xe59c, color: '42A5F5'),
                      // ),
                      ...controller.tasks.map((element) => LongPressDraggable(
                          data: element,
                          onDragStarted: () => controller.changeDeleting(true),
                          onDraggableCanceled: (_, __) =>
                              controller.changeDeleting(false),
                          onDragEnd: (_) => controller.changeDeleting(false),
                          feedback: Opacity(
                              opacity: 0.8, child: TaskCard(task: element)),
                          child: TaskCard(task: element))),
                      AddCard(),
                    ],
                  ),
                )
              ],
            ),
          ),
          SummaryPage(),
        ]),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              shape: const CircleBorder(side: BorderSide.none),
              foregroundColor: Colors.white,
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Create a task type first');
                }
              },
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAcceptWithDetails: (DragTargetDetails<Task> details) {
          final task = details.data;
          controller.deleteTask(task);
          EasyLoading.showSuccess('Deleted note');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Padding(
                    padding: EdgeInsets.only(left: 0.0.wp),
                    child: const Icon(Icons.apps),
                  )),
              BottomNavigationBarItem(
                  label: 'Summary',
                  icon: Padding(
                    padding: EdgeInsets.only(right: 0.0.wp),
                    child: const Icon(Icons.data_usage),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
