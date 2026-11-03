import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hadith_data.dart';

class HadithSection extends StatefulWidget {
  const HadithSection({super.key});

  @override
  State<HadithSection> createState() => _HadithSectionState();
}

class _HadithSectionState extends State<HadithSection> {
  String searchQuery = '';
  String selectedBook = 'all';
  String? copiedId;

  List<String> get _booksList =>
      hadithCollection.map((h) => h.book).toSet().toList();

  List<HadithItem> get _filteredHadiths {
    return hadithCollection.where((h) {
      final matchesSearch = searchQuery.isEmpty ||
          h.banglaText.contains(searchQuery) ||
          h.category.contains(searchQuery) ||
          h.narrator.contains(searchQuery);
      final matchesBook = selectedBook == 'all' || h.book == selectedBook;
      return matchesSearch && matchesBook;
    }).toList();
  }

  Future<void> _handleCopy(String id, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => copiedId = id);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => copiedId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 14),
        _buildBookFilters(),
        const SizedBox(height: 16),
        ..._filteredHadiths.map((hadith) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildHadithCard(hadith),
            )),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text('সহীহ হাদিস ভাণ্ডার',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'রাসুলুল্লাহ (সা:) এর বাণী, সহীহ বুখারী, সহীহ মুসলিম ও অন্যান্য কিতাব থেকে',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'হাদিস খুঁজুন...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              prefixIcon:
                  const Icon(Icons.search, color: Colors.white54, size: 18),
              filled: true,
              fillColor: Colors.black26,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ],
      ),
    );
  }

  Widget _buildBookFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _bookChip('সকল হাদিস কিতাব', 'all'),
          const SizedBox(width: 8),
          ..._booksList.map((book) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _bookChip(book, book),
              )),
        ],
      ),
    );
  }

  Widget _bookChip(String label, String value) {
    final isActive = selectedBook == value;
    return InkWell(
      onTap: () => setState(() => selectedBook = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.green[600] : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(HadithItem hadith) {
    final isCopied = copiedId == hadith.id;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[950],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[800]!),
                      ),
                      child: Text(
                          '${hadith.book} (হাদিস নং ${hadith.hadithNumber})',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[400])),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      child: Text(hadith.category,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _handleCopy(hadith.id,
                    '${hadith.banglaText}\n- ${hadith.book}, রাবী: ${hadith.narrator}'),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCopied ? Icons.check : Icons.copy,
                    size: 15,
                    color: isCopied ? Colors.green[400] : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hadith.arabicText,
            textAlign: TextAlign.right,
            style: const TextStyle(
                color: Color(0xFFFDE68A), fontSize: 19, height: 1.7),
          ),
          const SizedBox(height: 10),
          Text(
            '"${hadith.banglaText}"',
            style:
                TextStyle(color: Colors.grey[200], fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('রাবী: ${hadith.narrator}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      overflow: TextOverflow.ellipsis),
                ),
                Text('মান: ${hadith.grade}',
                    style: TextStyle(
                        color: Colors.green[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
