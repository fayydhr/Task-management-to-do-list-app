import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/task_controller.dart';
import '../models/project_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
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
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              'assets/svg/notif.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Progress Dashboard Card (Warna 5F33E1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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

                  // Section "Task Groups"
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Text(
                            'Task Groups',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Elips EEE9FF mengacu pada jumlah Task Groups
                          Obx(() => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEE9FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${controller.projects.length}',
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

                  // Task Groups Vertical List (Container w331 h66 warna putih)
                  Obx(() {
                    if (controller.projects.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('Belum ada Task Group')),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final proj = controller.projects[index];
                            return _buildTaskGroupTile(proj, index);
                          },
                          childCount: controller.projects.length,
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
      bottomNavigationBar: _buildBottomNav(),
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

  Widget _buildTaskGroupTile(ProjectModel proj, int index) {
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

    final theme = pastelThemes[index % pastelThemes.length];
    final int totalTaskCount = controller.getTaskCountForProject(proj.name);
    final double progress = controller.getProjectProgress(proj.name);
    final int percentage = (progress * 100).toInt();

    return Container(
        width: double.infinity,
        height: 66,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo size 34 & Judul reg 14 + Total tasks reg 11 (6E6A7C)
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: theme['iconBg'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      IconData(proj.iconCode, fontFamily: 'MaterialIcons'),
                      size: 18,
                      color: theme['iconColor'],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      proj.name,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalTaskCount Tasks',
                      style: GoogleFonts.lexendDeca(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6E6A7C),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Lingkaran Progress Persen di Ujung Kanan (reg 11, warna terpenuhi iconColor, belum iconBg)
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4.5,
                      backgroundColor: theme['iconBg'],
                      valueColor: AlwaysStoppedAnimation<Color>(theme['iconColor']!),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: GoogleFonts.lexendDeca(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          // SVG Custom Bottom Bar Shape (assets/svg/buttombar.svg)
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

          // Icons Overlay over Bottom Bar (height 56)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {},
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
                  onTap: () => Get.offAllNamed('/today-tasks'),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/calender.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Celah tengah untuk plus button
                GestureDetector(
                  onTap: () {},
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

          // Plus Circle Button (size 46, warna 5F33E1, SVG assets/svg/plus.svg size 28, dengan shadow, bottom: 34)
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
