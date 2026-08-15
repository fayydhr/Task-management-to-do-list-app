import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/task_controller.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
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

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryFilter = 'Semua';

  final List<int> _pastelColors = [
    0xFFFFF4BD, // Pastel Yellow
    0xFFFFD6EC, // Pastel Pink
    0xFFE8DDFF, // Pastel Purple
    0xFFD2E0FB, // Pastel Blue
    0xFFD7F9F1, // Pastel Mint
    0xFFFFE5CA, // Pastel Peach
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          'Quick Notes',
          style: GoogleFonts.lexendDeca(
            color: Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
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
                              Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => setState(() {}),
                                  style: GoogleFonts.lexendDeca(fontSize: 13, color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Cari catatan...',
                                    hintStyle: GoogleFonts.lexendDeca(fontSize: 13, color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  child: Icon(Icons.clear_rounded, color: Colors.grey.shade400, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showAddNoteDialog,
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5F33E1),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5F33E1).withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                  child: Row(
                    children: [
                      _buildCategoryChip('Semua'),
                      _buildCategoryChip('Pinned'),
                      _buildCategoryChip('Desain UI/UX'),
                      _buildCategoryChip('Pengembangan Flutter'),
                      _buildCategoryChip('Pekerjaan Kantor'),
                      _buildCategoryChip('Personal'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    final query = _searchController.text.toLowerCase().trim();
                    var displayedNotes = controller.notes.where((note) {
                      final matchesSearch = query.isEmpty ||
                          note.title.toLowerCase().contains(query) ||
                          note.content.toLowerCase().contains(query);

                      if (!matchesSearch) return false;

                      if (_selectedCategoryFilter == 'Semua') return true;
                      if (_selectedCategoryFilter == 'Pinned') return note.isPinned;
                      return note.category == _selectedCategoryFilter;
                    }).toList();

                    displayedNotes.sort((a, b) {
                      if (a.isPinned && !b.isPinned) return -1;
                      if (!a.isPinned && b.isPinned) return 1;
                      return b.date.compareTo(a.date);
                    });

                    if (displayedNotes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'Belum Ada Catatan',
                              style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tekan tombol + untuk membuat sticky note baru',
                              style: GoogleFonts.lexendDeca(fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(22, 6, 22, 90),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: displayedNotes.length,
                      itemBuilder: (context, index) {
                        final note = displayedNotes[index];
                        return _buildStickyNoteCard(note);
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

  Widget _buildCategoryChip(String title) {
    final bool isSelected = _selectedCategoryFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryFilter = title),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5F33E1) : const Color(0xFFEDE8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: GoogleFonts.lexendDeca(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF5F33E1),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyNoteCard(NoteEntity note) {
    final dateStr = DateFormat('dd MMM yyyy', 'en_US').format(note.date);

    return Container(
      decoration: BoxDecoration(
        color: Color(note.colorValue),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        note.category,
                        style: GoogleFonts.lexendDeca(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.togglePinNote(note.id),
                      child: Icon(
                        note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                        size: 18,
                        color: note.isPinned ? const Color(0xFF5F33E1) : Colors.black38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lexendDeca(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    note.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF475569),
                      height: 1.3,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateStr,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _confirmDeleteNote(note),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    int selectedColor = _pastelColors.first;
    String selectedCat = controller.projects.isNotEmpty ? controller.projects.first.name : 'Umum';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Buat Sticky Note Baru',
                    style: GoogleFonts.lexendDeca(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Judul Catatan',
                      hintStyle: GoogleFonts.lexendDeca(fontSize: 14, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    style: GoogleFonts.lexendDeca(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Tulis isi catatan cepat...',
                      hintStyle: GoogleFonts.lexendDeca(fontSize: 12, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Warna Sticky Note:',
                    style: GoogleFonts.lexendDeca(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _pastelColors.map((cVal) {
                      final isSelected = selectedColor == cVal;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColor = cVal),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(cVal),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF5F33E1) : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded, color: Color(0xFF5F33E1), size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          Get.snackbar('Peringatan', 'Judul catatan tidak boleh kosong', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        final newNote = NoteEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                          category: selectedCat,
                          date: DateTime.now(),
                          isPinned: false,
                          colorValue: selectedColor,
                        );
                        controller.addNote(newNote);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F33E1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Simpan Catatan',
                        style: GoogleFonts.lexendDeca(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteNote(NoteEntity note) {
    Get.defaultDialog(
      title: 'Hapus Catatan',
      titleStyle: GoogleFonts.lexendDeca(fontWeight: FontWeight.w600, fontSize: 16),
      middleText: 'Apakah Anda yakin ingin menghapus "${note.title}"?',
      middleTextStyle: GoogleFonts.lexendDeca(fontSize: 13),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      cancelTextColor: Colors.grey.shade700,
      onConfirm: () {
        controller.deleteNote(note.id);
        Get.back();
      },
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
                const SizedBox(width: 48),
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
