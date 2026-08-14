import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/task_controller.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Full Screen Background SVG (assets/svg/bg.svg)
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg/bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Layered Blur 150 Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Foreground Screen Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.loadData();
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Top Header Bar
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          // Profile Picture dari internet (size: 46)
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=250&auto=format&fit=crop',
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: const Color(0xFF6366F1),
                                  child: const Center(
                                    child: Text(
                                      'LV',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Jarak PP ke font: 16
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello!',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Livia Vaccaro',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Progress Dashboard Card (Warna 5F33E1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: Obx(() {
                        final ratio = controller.todayProgressRatio;
                        final percentage = (ratio * 100).toInt();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5F33E1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5F33E1).withValues(alpha: 0.35),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Teks & Tombol di Kiri
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your today’s task\nalmost done!',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    ElevatedButton(
                                      onPressed: () => Get.toNamed('/today-tasks'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF5F33E1),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'View Task',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF5F33E1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Lingkaran Progress Persen di Kanan (Jarak ke ujung kanan 75)
                              Padding(
                                padding: const EdgeInsets.only(right: 55),
                                child: SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 72,
                                        height: 72,
                                        child: CircularProgressIndicator(
                                          value: ratio,
                                          strokeWidth: 7.5,
                                          backgroundColor: const Color(0xFF8764FF),
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ),
                                      Text(
                                        '$percentage%',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  // Section "In Progress"
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Text(
                            'In Progress',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Elips EEE9FF mengacu pada jumlah tugas in progress
                          Obx(() => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEE9FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${controller.pendingTodayCount}',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5F33E1),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Sizebox kebawah 16 & Task Groups Horizontal List (w202 h116)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        height: 116,
                        child: Obx(() {
                          if (controller.projects.isEmpty) {
                            return const Center(child: Text('Belum ada Task Group'));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.projects.length,
                            itemBuilder: (context, index) {
                              final proj = controller.projects[index];
                              return _buildTaskGroupCard(proj, index);
                            },
                          );
                        }),
                      ),
                    ),
                  ),

                  // Today Tasks Section Title
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tugas Hari Ini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/today-tasks'),
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Color(0xFF6366F1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Today Tasks List
                  Obx(() {
                    final tasks = controller.todayTasks;
                    if (tasks.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
                              SizedBox(height: 10),
                              Text(
                                'Tidak Ada Tugas Hari Ini',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Klik tombol + di bawah untuk menambah tugas baru',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = tasks[index];
                            return _buildTaskTile(task);
                          },
                          childCount: tasks.length > 5 ? 5 : tasks.length,
                        ),
                      ),
                    );
                  }),

                  const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation & FAB Action
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-project'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Buat Baru', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTaskGroupCard(ProjectModel proj, int index) {
    final pastelThemes = [
      {
        'bg': const Color(0xFFE7F3FF),
        'iconBg': const Color(0xFFFFE4F2),
        'iconColor': const Color(0xFFF478B8),
        'progressColor': const Color(0xFF0087FF),
      },
      {
        'bg': const Color(0xFFFFEBF0),
        'iconBg': const Color(0xFFE0F2FE),
        'iconColor': const Color(0xFF0284C7),
        'progressColor': const Color(0xFFF43F5E),
      },
      {
        'bg': const Color(0xFFFFF7E6),
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFEF4444),
        'progressColor': const Color(0xFFF59E0B),
      },
      {
        'bg': const Color(0xFFE6F9F0),
        'iconBg': const Color(0xFFF3E8FF),
        'iconColor': const Color(0xFFA855F7),
        'progressColor': const Color(0xFF10B981),
      },
    ];

    final theme = pastelThemes[index % pastelThemes.length];
    final double progress = controller.getProjectProgress(proj.name);

    return Container(
      width: 202,
      height: 116,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme['bg'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Category Title (reg 11 6E6A7C) & Emoji Box (size 24, bg FFE4F2, icon F478B8)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proj.name,
                style: GoogleFonts.lexendDeca(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6A7C),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme['iconBg'],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                    IconData(proj.iconCode, fontFamily: 'MaterialIcons'),
                    size: 14,
                    color: theme['iconColor'],
                  ),
                ),
              ),
            ],
          ),

          // Main Title (reg 14 warna hitam, max 2 baris)
          Text(
            proj.description.isNotEmpty ? proj.description : 'Grocery shopping app design',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lexendDeca(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),

          // Progress Bar (w 170 h 6, bg putih, finished 0087FF)
          SizedBox(
            width: 170,
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(theme['progressColor']!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(TaskModel task) {
    final color = Color(task.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? const Color(0xFFE2E8F0) : color.withValues(alpha: 0.3),
          width: task.isCompleted ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: GestureDetector(
          onTap: () => controller.toggleTaskStatus(task.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted ? const Color(0xFF10B981) : Colors.transparent,
              border: Border.all(
                color: task.isCompleted ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                width: 2,
              ),
            ),
            child: task.isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: task.isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              margin: const EdgeInsets.only(top: 4, right: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.projectName,
                style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              task.time,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
          onPressed: () => controller.deleteTask(task.id),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view_rounded, color: Color(0xFF6366F1), size: 26),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/today-tasks'),
            icon: const Icon(Icons.task_alt_rounded, color: Color(0xFF94A3B8), size: 26),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/add-project'),
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF94A3B8), size: 26),
          ),
        ],
      ),
    );
  }
}
