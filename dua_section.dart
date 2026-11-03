import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dua_data.dart';

class DuaSection extends StatefulWidget {
  final bool isDarkTheme;

  const DuaSection({
    super.key,
    this.isDarkTheme = false,
  });

  @override
  State<DuaSection> createState() => _DuaSectionState();
}

class _DuaSectionState extends State<DuaSection> {
  String searchQuery = '';
  String selectedCategory = 'all';
  String? copiedId;
  String? speakingId;

  late final FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ar-SA');
    await _flutterTts.setSpeechRate(0.35);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => speakingId = null);
    });
    _flutterTts.setCancelHandler(() {
      if (mounted) setState(() => speakingId = null);
    });
    _flutterTts.setErrorHandler((msg) {
      if (mounted) setState(() => speakingId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'উচ্চারণ চালানো যায়নি — ডিভাইসে আরবি ভয়েস প্যাক নেই হয়তো')),
      );
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  List<String> get _categories =>
      duaCollection.map((d) => d.category).toSet().toList();

  List<DuaItem> get _filteredDuas {
    return duaCollection.where((d) {
      final matchesSearch = searchQuery.isEmpty ||
          d.titleBangla.contains(searchQuery) ||
          d.meaningBangla.contains(searchQuery) ||
          d.transliterationBangla.contains(searchQuery);
      final matchesCat =
          selectedCategory == 'all' || d.category == selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();
  }

  Future<void> _handleCopy(String id, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => copiedId = id);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => copiedId = null);
    });
  }

  Future<void> _handlePlaySpeech(DuaItem dua) async {
    if (speakingId == dua.id) {
      await _flutterTts.stop();
      setState(() => speakingId = null);
      return;
    }
    setState(() => speakingId = dua.id);
    await _flutterTts.speak(dua.arabicText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 14),
        _buildCategoryFilters(),
        const SizedBox(height: 16),
        ..._filteredDuas.map((dua) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildDuaCard(dua),
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
              Icon(Icons.volume_up, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text('মাসনুন দোয়া (হিসনুল মুসলিম)',
                    style: TextStyle(
                        fontFamily: 'NotoSansBengali',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'দৈনন্দিন জীবনের প্রয়োজনীয় গুরুত্বপূর্ণ সকল মাসনুন দোয়া ও জিকির',
            style: TextStyle(
                fontFamily: 'NotoSansBengali',
                color: Colors.white70,
                fontSize: 11),
          ),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(
                fontFamily: 'NotoSansBengali',
                color: Colors.white,
                fontSize: 13),
            decoration: InputDecoration(
              hintText: 'দোয়া খুঁজুন...',
              hintStyle: const TextStyle(
                  fontFamily: 'NotoSansBengali',
                  color: Colors.white38,
                  fontSize: 12),
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

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _categoryChip('সকল দোয়া', 'all'),
          const SizedBox(width: 8),
          ..._categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _categoryChip(cat, cat),
              )),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, String value) {
    final dark = widget.isDarkTheme;
    final isActive = selectedCategory == value;
    return InkWell(
      onTap: () => setState(() => selectedCategory = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.green[600]
              : (dark ? Colors.grey[850] : const Color(0xFFF0F2F1)),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'NotoSansBengali',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Colors.white
                : (dark ? Colors.grey[300] : const Color(0xFF3F4B47)),
          ),
        ),
      ),
    );
  }

  Widget _buildDuaCard(DuaItem dua) {
    final dark = widget.isDarkTheme;
    final isCopied = copiedId == dua.id;
    final isSpeaking = speakingId == dua.id;
    final isQuranAyat = dua.category == 'কুরআনি আয়াত';

    final cardBg = dark ? Colors.grey[900]?.withOpacity(0.5) : Colors.white;
    final cardBorder = dark ? Colors.grey[700]! : const Color(0xFFE1E6E4);
    final titleColor = dark ? Colors.white : const Color(0xFF0F2E2A);
    final meaningColor = dark ? Colors.grey[200] : const Color(0xFF374151);
    final refColor = dark ? Colors.grey[400] : const Color(0xFF6B7280);
    final dividerColor = dark ? Colors.white12 : const Color(0xFFE5E7EB);
    final iconBtnBg = dark ? Colors.grey[800] : const Color(0xFFF0F2F1);
    final iconBtnColor = dark ? Colors.white70 : const Color(0xFF4B5563);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dark ? Colors.green[950] : Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dark ? Colors.green[800]! : Colors.green[200]!,
                  ),
                ),
                child: Text(dua.category,
                    style: TextStyle(
                        fontFamily: 'NotoSansBengali',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[dark ? 400 : 700])),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => _handlePlaySpeech(dua),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isSpeaking ? Colors.green[600] : iconBtnBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSpeaking ? Icons.stop : Icons.volume_up,
                        size: 15,
                        color: isSpeaking ? Colors.white : iconBtnColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _handleCopy(dua.id,
                        '${dua.titleBangla}\n${dua.arabicText}\nঅর্থ: ${dua.meaningBangla}'),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: iconBtnBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCopied ? Icons.check : Icons.copy,
                        size: 15,
                        color: isCopied ? Colors.green[400] : iconBtnColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(dua.titleBangla,
              style: TextStyle(
                  fontFamily: 'NotoSansBengali',
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          const SizedBox(height: 10),
          Text(
            dua.arabicText,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                color: dark ? const Color(0xFFFDE68A) : const Color(0xFF92620A),
                fontSize: 20,
                height: 1.9),
          ),
          if (isQuranAyat) ...[
            const SizedBox(height: 6),
            Text(
              '* যান্ত্রিক উচ্চারণ (TTS) — সঠিক তাজবীদের জন্য ক্বারীর তেলাওয়াত শোনার পরামর্শ দেওয়া হচ্ছে।',
              style: TextStyle(
                  fontFamily: 'NotoSansBengali',
                  fontSize: 9.5,
                  fontStyle: FontStyle.italic,
                  color: refColor),
            ),
          ],
          Divider(color: dividerColor, height: 20),
          Text('উচ্চারণ: ${dua.transliterationBangla}',
              style: TextStyle(
                  fontFamily: 'NotoSansBengali',
                  color: Colors.green[dark ? 300 : 700],
                  fontSize: 13.5,
                  height: 1.5)),
          const SizedBox(height: 6),
          Text('অর্থ: ${dua.meaningBangla}',
              style: TextStyle(
                  fontFamily: 'NotoSansBengali',
                  color: meaningColor,
                  fontSize: 13.5,
                  height: 1.5)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'সূত্র: ${dua.reference}',
                  style: TextStyle(
                      fontFamily: 'NotoSansBengali',
                      color: refColor,
                      fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (dua.benefits != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'ফজিলত: ${dua.benefits}',
                    style: TextStyle(
                        fontFamily: 'NotoSansBengali',
                        color: Colors.amber[dark ? 300 : 800],
                        fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
