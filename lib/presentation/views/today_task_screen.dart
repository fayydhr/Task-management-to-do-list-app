import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/project_entity.dart';
import '../controllers/task_controller.dart';

class TodayTaskScreen extends StatelessWidget {
  TodayTaskScreen({super.key});

  final TaskController controller = Get.isRegistered<TaskController>()
      ? Get.find<TaskController>()
      : Get.put(TaskController(
          getTasksUseCase: Get.find(),
          addTaskUseCase: Get.find(),
          toggleTaskStatusUseCase: Get.find(),
          deleteTaskUseCase: Get.find(),
          getProjectsUseCase: Get.find(),
          addProjectUseCase: Get.find(),
          deleteProjectUseCase: Get.find(),
          getNotesUseCase: Get.find(),
          addNoteUseCase: Get.find(),
          togglePinNoteUseCase: Get.find(),
          deleteNoteUseCase: Get.find(),
        ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              'assets/svg/back.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: Text(
          'Today’s Tasks',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/svg/notif.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg/bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHorizontalCalendar(context),
                const SizedBox(height: 32),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Obx(() {
                    final currentFilter = controller.selectedFilter.value;
                    return Row(
                      children: [
                        _buildFilterChip('All', currentFilter),
                        _buildFilterChip('To Do', currentFilter),
                        _buildFilterChip('In Progress', currentFilter),
                        _buildFilterChip('Completed', currentFilter),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    final tasks = controller.filteredTodayTasks;

                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak Ada Tugas',
                              style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tidak ada tugas pada tanggal ini',
                              style: GoogleFonts.lexendDeca(fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(22, 10, 22, 90),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _buildDetailTaskCard(task);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHorizontalCalendar(BuildContext context) {
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final List<DateTime> monthDays = List.generate(
      daysInMonth,
      (index) => DateTime(now.year, now.month, index + 1),
    );

    final int todayIndex = now.day - 1;
    final ScrollController scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        double offset = (todayIndex * 74.0) - (MediaQuery.of(context).size.width / 2) + 37.0;
        if (offset < 0) offset = 0;
        if (offset > scrollController.position.maxScrollExtent) {
          offset = scrollController.position.maxScrollExtent;
        }
        scrollController.jumpTo(offset);
      }
    });

    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.transparent,
      child: Obx(() {
        final selected = controller.selectedDate.value;
        return ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: monthDays.length,
          itemBuilder: (context, index) {
            final date = monthDays[index];
            final bool isSelected = selected.year == date.year &&
                selected.month == date.month &&
                selected.day == date.day;

            String monthStr;
            String dayOfWeekStr;
            try {
              monthStr = DateFormat('MMM', 'en_US').format(date);
              dayOfWeekStr = DateFormat('EEE', 'en_US').format(date);
            } catch (_) {
              monthStr = DateFormat('MMM').format(date);
              dayOfWeekStr = DateFormat('EEE').format(date);
            }
            final String dayNumStr = date.day.toString();

            return GestureDetector(
              onTap: () {
                controller.selectedDate.value = date;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 84,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5F33E1) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF5F33E1).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthStr,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.white.withValues(alpha: 0.85) : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dayNumStr,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dayOfWeekStr,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.white.withValues(alpha: 0.85) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFilterChip(String label, String currentFilter) {
    final bool isSelected = currentFilter == label;
    return GestureDetector(
      onTap: () {
        controller.selectedFilter.value = label;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 34,
        constraints: const BoxConstraints(minWidth: 66),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5F33E1) : const Color(0xFFEDE8FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.lexendDeca(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF5F33E1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTaskCard(TaskEntity task) {
    String statusText;
    Color statusTextColor;
    Color statusBgColor;

    if (task.isCompleted) {
      statusText = 'Done';
      statusTextColor = const Color(0xFF5F33E1);
      statusBgColor = const Color(0xFFEDE8FF);
    } else if (task.priority == 'Tinggi') {
      statusText = 'In Progress';
      statusTextColor = const Color(0xFFFF7D53);
      statusBgColor = const Color(0xFFFFE9E1);
    } else {
      statusText = 'To-do';
      statusTextColor = const Color(0xFF0087FF);
      statusBgColor = const Color(0xFFE3F2FF);
    }

    final pastelThemes = [
      {
        'iconBg': const Color(0xFFFFE4F2),
        'iconColor': const Color(0xFFF478B8),
      },
      {
        'iconBg': const Color(0xFFE0F2FE),
        'iconColor': const Color(0xFF0284C7),
      },
      {
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFEF4444),
      },
      {
        'iconBg': const Color(0xFFF3E8FF),
        'iconColor': const Color(0xFFA855F7),
      },
    ];

    final int projIndex = controller.projects.indexWhere((p) => p.name == task.projectName);
    final ProjectEntity? project = projIndex >= 0 ? controller.projects[projIndex] : null;
    final theme = pastelThemes[(projIndex >= 0 ? projIndex : 0) % pastelThemes.length];

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteTask(task.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
      ),
      child: Container(
        width: double.infinity,
        height: 130,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.projectName.isNotEmpty ? task.projectName : 'Grocery shopping app design',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6E6A7C),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme['iconBg'],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Icon(
                      project != null
                          ? IconData(project.iconCode, fontFamily: 'MaterialIcons')
                          : Icons.work_outline,
                      size: 13,
                      color: theme['iconColor'],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              task.title.isNotEmpty ? task.title : 'Market Research',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexendDeca(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/clock.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFAB94FF),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.time.isNotEmpty ? task.time : '10:00 AM',
                      style: GoogleFonts.lexendDeca(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFAB94FF),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => controller.toggleTaskStatus(task.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/buttombar.svg',
              width: double.infinity,
              height: 56,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Get.offAllNamed('/home'),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/home.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/calender.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
                GestureDetector(
                  onTap: () => Get.offAllNamed('/notes'),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/note.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/profile.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 34,
            child: GestureDetector(
              onTap: () => Get.toNamed('/add-project'),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF5F33E1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5F33E1).withValues(alpha: 0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/plus.svg',
                    width: 28,
                    height: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
