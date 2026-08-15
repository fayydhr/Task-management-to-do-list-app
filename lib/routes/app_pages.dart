import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/home_screen.dart';
import '../views/today_task_screen.dart';
import '../views/add_project_screen.dart';
import '../views/note_screen.dart';

class AppPages {
  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/today-tasks',
      page: () => TodayTaskScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/notes',
      page: () => NoteScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/add-project',
      page: () => const AddProjectScreen(),
      transition: Transition.downToUp,
    ),
  ];
}
