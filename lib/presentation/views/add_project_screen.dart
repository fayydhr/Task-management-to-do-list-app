import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../controllers/task_controller.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
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

  final _projectNameController = TextEditingController(text: 'Grocery Shopping App');
  final _descriptionController = TextEditingController();
  
  String _selectedProjectName = 'Work';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  final List<Map<String, dynamic>> _pastelThemes = [
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

  @override
  void initState() {
    super.initState();
    if (controller.projects.isNotEmpty) {
      _selectedProjectName = controller.projects.first.name;
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int projIndex = controller.projects.indexWhere((p) => p.name == _selectedProjectName);
    final ProjectEntity? selectedProject = projIndex >= 0 ? controller.projects[projIndex] : null;
    final theme = _pastelThemes[(projIndex >= 0 ? projIndex : 0) % _pastelThemes.length];

    final String startDateStr = DateFormat('dd MMM yyyy', 'en_US').format(_startDate);
    final String endDateStr = DateFormat('dd MMM yyyy', 'en_US').format(_endDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 14, bottom: 14),
            child: SvgPicture.asset(
              'assets/svg/back.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: Text(
          'Add Project',
          style: GoogleFonts.lexendDeca(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showTaskGroupSelector,
                    child: Container(
                      width: double.infinity,
                      height: 63,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme['iconBg'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Icon(
                                selectedProject != null
                                    ? IconData(selectedProject.iconCode, fontFamily: 'MaterialIcons')
                                    : Icons.work_outline,
                                size: 14,
                                color: theme['iconColor'],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Group',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6E6A7C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedProjectName.isNotEmpty ? _selectedProjectName : 'Work',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/kebawah.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 63,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Name',
                          style: GoogleFonts.lexendDeca(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6E6A7C),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: TextField(
                            controller: _projectNameController,
                            style: GoogleFonts.lexendDeca(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: 'Grocery Shopping App',
                              hintStyle: GoogleFonts.lexendDeca(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 142,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.lexendDeca(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6E6A7C),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            style: GoogleFonts.lexendDeca(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: 'Enter project details...',
                              hintStyle: GoogleFonts.lexendDeca(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => _pickDate(isStart: true),
                    child: Container(
                      width: double.infinity,
                      height: 63,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/calender.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6E6A7C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  startDateStr,
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/kebawah.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => _pickDate(isStart: false),
                    child: Container(
                      width: double.infinity,
                      height: 63,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/calender.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Date',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF6E6A7C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  endDateStr,
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/kebawah.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 160),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F33E1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Add Project',
                        style: GoogleFonts.lexendDeca(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskGroupSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Task Group',
                style: GoogleFonts.lexendDeca(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(controller.projects.length, (index) {
                final proj = controller.projects[index];
                final theme = _pastelThemes[index % _pastelThemes.length];
                final bool isSelected = proj.name == _selectedProjectName;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme['iconBg'],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        IconData(proj.iconCode, fontFamily: 'MaterialIcons'),
                        size: 16,
                        color: theme['iconColor'],
                      ),
                    ),
                  ),
                  title: Text(
                    proj.name,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF5F33E1) : Colors.black,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF5F33E1))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedProjectName = proj.name;
                    });
                    Get.back();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    final title = _projectNameController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Peringatan', 'Project Name tidak boleh kosong', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final matchedProj = controller.projects.firstWhere(
      (p) => p.name == _selectedProjectName,
      orElse: () => ProjectEntity(id: '', name: _selectedProjectName, colorValue: 0xFF5F33E1),
    );

    final newTask = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: _descriptionController.text.trim(),
      projectName: matchedProj.name,
      date: _startDate,
      time: DateFormat('hh:mm a').format(DateTime.now()),
      priority: 'Tinggi',
      colorValue: matchedProj.colorValue,
    );

    controller.addTask(newTask);
    Get.back();
  }
}
