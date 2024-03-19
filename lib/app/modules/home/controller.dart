import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/task.dart';
import '../../data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController(this.taskRepository);

  final tasks = <Task>[].obs;
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final ongoingTodos = <dynamic>[].obs;
  final finishedTodos = <dynamic>[].obs;
  final tabIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  void changeChip(int value) {
    chipIndex.value = value;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void changeTask(Task? selected) {
    task.value = selected;
  }

  updateTask(Task task, String title) {
    // var todos = task.todos ?? [];
    var todos = List<Map<String, dynamic>>.from(task.todos ?? []);
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    // task.todos = todos;
    return true;
  }

  bool containTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  void changeTodos(List<dynamic> select) {
    ongoingTodos.clear();
    finishedTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        finishedTodos.add(todo);
      } else {
        ongoingTodos.add(todo);
      }
    }
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (ongoingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var finishedTodo = {'title': title, 'done': true};
    if (finishedTodos
        .any((element) => mapEquals<String, dynamic>(finishedTodo, element))) {
      return false;
    }
    ongoingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([...ongoingTodos, ...finishedTodos]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var ongongingTodo = {'title': title, 'done': false};
    int index = ongoingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(ongongingTodo, element));
    ongoingTodos.removeAt(index);
    var finishedTodo = {'title': title, 'done': true};
    finishedTodos.add(finishedTodo);
    ongoingTodos.refresh();
    finishedTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = finishedTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    finishedTodos.removeAt(index);
    finishedTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
