import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TaskController controller = Get.find<TaskController>();

  int _selectedTabIndex = 0; // 0 = Add Task, 1 = Add Project

  // Task Form Controls
  final _taskTitleController = TextEditingController();
  final _taskDescController = TextEditingController();
  String _selectedProjectName = '';
  String _selectedPriority = 'Sedang';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Project Form Controls
  final _projectNameController = TextEditingController();
  final _projectDescController = TextEditingController();
  int _selectedColorValue = 0xFF6366F1;
  int _selectedIconCode = 0xe3af;

  final List<int> _colorOptions = [
    0xFF6366F1, // Indigo
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEC4899, // Pink
    0xFF3B82F6, // Blue
    0xFF8B5CF6, // Purple
    0xFFEF4444, // Red
    0xFF14B8A6, // Teal
  ];

  final List<int> _iconOptions = [
    0xe3af, // folder / work
    0xe1b1, // design / brush
    0xe1d7, // code
    0xe491, // person / personal
    0xe57f, // shopping
    0xe3e8, // book
    0xe539, // fitness
    0xe8b8, // star
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
    _taskTitleController.dispose();
    _taskDescController.dispose();
    _projectNameController.dispose();
    _projectDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _selectedTabIndex == 0 ? 'Buat Tugas Baru' : 'Buat Proyek Baru',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Tab Switcher
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedTabIndex == 0
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Tambah Tugas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedTabIndex == 0 ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedTabIndex == 1
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Tambah Proyek',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedTabIndex == 1 ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Content depending on tab
              _selectedTabIndex == 0 ? _buildTaskForm() : _buildProjectForm(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Task Form ---
  Widget _buildTaskForm() {
    final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate);
    final formattedTime = _selectedTime.format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Judul Tugas'),
        TextField(
          controller: _taskTitleController,
          decoration: _inputDecoration('Misal: Meeting Laporan UI/UX'),
        ),
        const SizedBox(height: 20),

        _buildLabel('Pilih Proyek / Kategori'),
        Obx(() {
          if (controller.projects.isEmpty) {
            return const Text('Belum ada proyek. Buat proyek terlebih dahulu.', style: TextStyle(color: Colors.red));
          }
          return DropdownButtonFormField<String>(
            initialValue: controller.projects.any((p) => p.name == _selectedProjectName)
                ? _selectedProjectName
                : controller.projects.first.name,
            decoration: _inputDecoration(''),
            items: controller.projects.map((proj) {
              return DropdownMenuItem<String>(
                value: proj.name,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(proj.colorValue),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(proj.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedProjectName = val);
              }
            },
          );
        }),
        const SizedBox(height: 20),

        _buildLabel('Tingkat Prioritas'),
        Row(
          children: [
            _buildPriorityChip('Tinggi', const Color(0xFFEF4444)),
            const SizedBox(width: 10),
            _buildPriorityChip('Sedang', const Color(0xFFF59E0B)),
            const SizedBox(width: 10),
            _buildPriorityChip('Rendah', const Color(0xFF10B981)),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Tanggal'),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF6366F1), size: 18),
                          const SizedBox(width: 8),
                          Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Waktu'),
                  InkWell(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: Color(0xFF6366F1), size: 18),
                          const SizedBox(width: 8),
                          Text(formattedTime, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildLabel('Deskripsi (Opsional)'),
        TextField(
          controller: _taskDescController,
          maxLines: 3,
          decoration: _inputDecoration('Tambahkan catatan detail mengenai tugas ini...'),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _submitTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Text('Simpan Tugas Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- Project Form ---
  Widget _buildProjectForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Proyek'),
        TextField(
          controller: _projectNameController,
          decoration: _inputDecoration('Misal: Aplikasi E-Commerce'),
        ),
        const SizedBox(height: 20),

        _buildLabel('Deskripsi Proyek'),
        TextField(
          controller: _projectDescController,
          maxLines: 2,
          decoration: _inputDecoration('Deskripsi singkat cakupan proyek...'),
        ),
        const SizedBox(height: 20),

        _buildLabel('Pilih Warna Proyek'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colorOptions.map((cVal) {
            final bool isSelected = _selectedColorValue == cVal;
            return GestureDetector(
              onTap: () => setState(() => _selectedColorValue = cVal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(cVal),
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                  boxShadow: [
                    BoxShadow(
                      color: Color(cVal).withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 22) : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        _buildLabel('Pilih Ikon Proyek'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _iconOptions.map((iCode) {
            final bool isSelected = _selectedIconCode == iCode;
            return GestureDetector(
              onTap: () => setState(() => _selectedIconCode = iCode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isSelected ? Color(_selectedColorValue) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Color(_selectedColorValue) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Icon(
                  IconData(iCode, fontFamily: 'MaterialIcons'),
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  size: 22,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _submitProject,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(_selectedColorValue),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Text('Simpan Proyek Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6366F1)),
      ),
    );
  }

  Widget _buildPriorityChip(String level, Color color) {
    final bool isSelected = _selectedPriority == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : const Color(0xFFE2E8F0)),
          ),
          child: Center(
            child: Text(
              level,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitTask() {
    if (_taskTitleController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Judul tugas tidak boleh kosong', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final matchedProj = controller.projects.firstWhere(
      (p) => p.name == _selectedProjectName,
      orElse: () => ProjectModel(id: '', name: 'Umum', colorValue: 0xFF6366F1),
    );

    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _taskTitleController.text.trim(),
      description: _taskDescController.text.trim(),
      projectName: matchedProj.name,
      date: _selectedDate,
      time: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      priority: _selectedPriority,
      colorValue: matchedProj.colorValue,
    );

    controller.addTask(newTask);
    Get.back();
  }

  void _submitProject() {
    if (_projectNameController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Nama proyek tidak boleh kosong', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newProj = ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _projectNameController.text.trim(),
      description: _projectDescController.text.trim(),
      colorValue: _selectedColorValue,
      iconCode: _selectedIconCode,
    );

    controller.addProject(newProj);
    Get.back();
  }
}
