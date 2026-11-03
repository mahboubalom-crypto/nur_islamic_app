import 'package:flutter/material.dart';

// ─── Data Models ───────────────────────────────────────────
class DuaItem {
  final String title;
  final String? source;
  final bool hasAudio;

  const DuaItem({required this.title, this.source, this.hasAudio = false});
}

class DuaChapter {
  final String title;
  final String emoji;
  final List<DuaItem> items;

  const DuaChapter(
      {required this.title, required this.emoji, required this.items});
}

// ─── Data ──────────────────────────────────────────────────
const List<DuaChapter> _fastingDuaChapters = [
  DuaChapter(
    title: 'রমযান অধ্যায়',
    emoji: '🌙',
    items: [
      DuaItem(title: "নতুন চাঁদ দেখে পড়ার দু'আ-১", hasAudio: true),
      DuaItem(title: "নতুন চাঁদ দেখে পড়ার দু'আ-২"),
      DuaItem(title: "রজব ও শা'বান মাসের দু'আ"),
      DuaItem(title: "রমযান মাসে পড়ার দু'আ"),
      DuaItem(title: 'সাহরী খাওয়া', source: 'সহীহ বুখারী'),
      DuaItem(
          title: 'ইফতারের সময় পড়বে-১',
          source: "শুআ'বুল ঈমান",
          hasAudio: true),
      DuaItem(title: 'ইফতারের সময় পড়বে-২', hasAudio: true),
      DuaItem(
          title: "ইফতারের পর এ দু'আ পড়বে", source: 'খেজুর দিয়ে ইফতার করা'),
      DuaItem(
          title: "অন্যের বাড়ীতে ইফতার করলে এ দু'আ পাঠ",
          source: 'সুনানে আবু দাউদ'),
      DuaItem(title: "শবে কদরের পড়ার দু'আ", hasAudio: true),
    ],
  ),
  DuaChapter(
    title: 'ঈদ অধ্যায়',
    emoji: '🕌',
    items: [
      DuaItem(title: "নতুন চাঁদ দেখে পড়ার দু'আ-১", hasAudio: true),
      DuaItem(title: "নতুন চাঁদ দেখে পড়ার দু'আ-২"),
      DuaItem(title: 'তাকবীরে তাশরীক', source: 'সুনানে দারা কুতনী (উর্দু)'),
      DuaItem(title: 'ঈদের শুভেচ্ছা জ্ঞাপন', source: 'সুনানুল কুবরা'),
      DuaItem(title: "পশু জবাইয়ের দু'আ সমূহ"),
    ],
  ),
];

// ─── Main Section Widget ────────────────────────────────────
class FastingDuaSection extends StatelessWidget {
  const FastingDuaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B1120) : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text(
          "দু'আ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _fastingDuaChapters.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chapter = _fastingDuaChapters[index];
          return _ChapterCard(chapter: chapter, isDark: isDark);
        },
      ),
    );
  }
}

// ─── Chapter Card ───────────────────────────────────────────
class _ChapterCard extends StatelessWidget {
  final DuaChapter chapter;
  final bool isDark;

  const _ChapterCard({required this.chapter, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => _DuaListPage(chapter: chapter),
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Text(chapter.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                chapter.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ),
            Text(
              '${chapter.items.length} টি',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dua List Page ──────────────────────────────────────────
class _DuaListPage extends StatelessWidget {
  final DuaChapter chapter;

  const _DuaListPage({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B1120) : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
        elevation: 0,
        title: Text(
          chapter.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: chapter.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = chapter.items[index];
          return _DuaItemCard(
            index: index + 1,
            item: item,
            isDark: isDark,
            chapterTitle: chapter.title,
          );
        },
      ),
    );
  }
}

// ─── Dua Item Card ──────────────────────────────────────────
class _DuaItemCard extends StatelessWidget {
  final int index;
  final DuaItem item;
  final bool isDark;
  final String chapterTitle;

  const _DuaItemCard({
    required this.index,
    required this.item,
    required this.isDark,
    required this.chapterTitle,
  });

  void _showDownloadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DownloadDialog(
        duaTitle: item.title,
        chapterTitle: chapterTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Index badge
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title + source
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                if (item.source != null) ...[
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.source!,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            isDark ? Colors.white54 : const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Audio play button
          if (item.hasAudio) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showDownloadDialog(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF1B5E20),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 20,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Download Dialog ────────────────────────────────────────
class _DownloadDialog extends StatelessWidget {
  final String duaTitle;
  final String chapterTitle;

  const _DownloadDialog({required this.duaTitle, required this.chapterTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_download_outlined,
              size: 36,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ডাউনলোড বাধ্যতামূলক',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            duaTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          Text(
            chapterTitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          const Text(
            "এই দু'আটি শোনার জন্য আগে দু'আর অডিও ডাউনলোড করতে হবে",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'এখনি ডাউনলোড করুন',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'বন্ধ করুন',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
