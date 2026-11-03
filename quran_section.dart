import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'quran_data.dart';

class QuranSection extends StatefulWidget {
  const QuranSection({super.key});

  @override
  State<QuranSection> createState() => _QuranSectionState();
}

class _QuranSectionState extends State<QuranSection> {
  String searchQuery = '';
  List<int> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nur_quran_bookmarks');

    if (saved == null || saved.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(saved);

      if (decoded is List) {
        if (!mounted) {
          return;
        }

        setState(() {
          bookmarks = decoded
              .map((e) => int.tryParse(e.toString()))
              .whereType<int>()
              .toList();
        });
      }
    } catch (_) {
      await prefs.remove('nur_quran_bookmarks');
    }
  }

  Future<void> _toggleBookmark(int surahNumber) async {
    setState(() {
      if (bookmarks.contains(surahNumber)) {
        bookmarks.remove(surahNumber);
      } else {
        bookmarks.add(surahNumber);
      }
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'nur_quran_bookmarks',
      jsonEncode(bookmarks),
    );
  }

  List<SurahMeta> get _filteredSurahs {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return surahsList;
    }

    return surahsList.where((surah) {
      return surah.nameBangla.toLowerCase().contains(query) ||
          surah.nameEnglish.toLowerCase().contains(query) ||
          surah.nameArabic.contains(query) ||
          surah.number.toString() == query;
    }).toList();
  }

  void _openSurah(SurahMeta surah) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahReaderPage(
          surah: surah,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 16),
        _buildSurahList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF064E3B),
            Color(0xFF0F2E2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.menu_book,
                color: Colors.amber,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'আল-কুরআন',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'সম্পূর্ণ ১১৪ টি সূরা, আরবি আয়াত, বাংলা অনুবাদ ও অডিও তেলাওয়াত',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'সূরার নাম বা নম্বর খুঁজুন...',
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white54,
                size: 18,
              ),
              filled: true,
              fillColor: Colors.black26,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList() {
    final surahs = _filteredSurahs;

    if (surahs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'কোনো সূরা পাওয়া যায়নি।',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final surah = surahs[index];
        final isBookmarked = bookmarks.contains(surah.number);

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openSurah(surah),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[700]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.green[950],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green[800]!,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Colors.green[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surah.nameBangla} (${surah.nameEnglish})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'অর্থ: ${surah.meaningBangla} • '
                        '${surah.numberOfAyahs} আয়াত • '
                        '${surah.revelationType == "Meccan" ? "মাক্কী" : "মাদানী"}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  surah.nameArabic,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _toggleBookmark(surah.number),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: isBookmarked ? Colors.amber : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================================
// SURAH READER
// ==========================================================

class SurahReaderPage extends StatefulWidget {
  final SurahMeta surah;

  // নির্দিষ্ট কোনো আয়াতে (যেমন আয়াতুল কুরসীর জন্য ২৫৫) সরাসরি
  // স্ক্রল করে নিয়ে যাওয়ার জন্য — না দিলে শুরু থেকে দেখাবে।
  final int? initialAyahNumber;

  // true হলে পুরো সূরা না দেখিয়ে শুধু initialAyahNumber-এর আয়াতটাই
  // দেখাবে (যেমন আয়াতুল কুরসীর জন্য শুধু ২৫৫ নম্বর আয়াত, বাকি ২৮৫টা না)।
  final bool showOnlyInitialAyah;

  const SurahReaderPage({
    super.key,
    required this.surah,
    this.initialAyahNumber,
    this.showOnlyInitialAyah = false,
  });

  @override
  State<SurahReaderPage> createState() => _SurahReaderPageState();
}

class _SurahReaderPageState extends State<SurahReaderPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<int, GlobalKey> _ayahKeys = {};

  List<Ayah> currentAyahs = [];

  bool isLoadingAyahs = true;
  bool isPlaying = false;
  bool isAudioLoading = false;

  int? playingAyahIndex;

  String fontSize = 'md';

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) {
        return;
      }

      if (playingAyahIndex != null &&
          playingAyahIndex! + 1 < currentAyahs.length) {
        _playAyah(playingAyahIndex! + 1);
      } else {
        setState(() {
          isPlaying = false;
          playingAyahIndex = null;
          isAudioLoading = false;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) {
        return;
      }

      setState(() {
        isPlaying = state == PlayerState.playing;

        if (state == PlayerState.stopped || state == PlayerState.completed) {
          isAudioLoading = false;
        }
      });
    });

    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheKey = 'quran_surah_${widget.surah.number}';

      final cached = prefs.getString(cacheKey);

      if (cached != null && cached.isNotEmpty) {
        try {
          final decoded = jsonDecode(cached);

          if (decoded is List) {
            final cachedAyahs = decoded
                .map(
                  (item) => _ayahFromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList();

            if (cachedAyahs.isNotEmpty) {
              if (!mounted) {
                return;
              }

              setState(() {
                currentAyahs = _applyAyahFilter(cachedAyahs);
                isLoadingAyahs = false;
              });

              _scrollToInitialAyahIfNeeded();
              return;
            }
          }
        } catch (_) {
          await prefs.remove(cacheKey);
        }
      }

      // ------------------------------------------------------
      // OFFLINE SAMPLE DATA
      // ------------------------------------------------------

      final sampleData = sampleSurahsData[widget.surah.number];

      if (sampleData != null && sampleData.isNotEmpty) {
        if (!mounted) {
          return;
        }

        final fullList = List<Ayah>.from(sampleData);
        setState(() {
          currentAyahs = _applyAyahFilter(fullList);
          isLoadingAyahs = false;
        });

        await prefs.setString(
          cacheKey,
          jsonEncode(
            fullList.map(_ayahToJson).toList(),
          ),
        );

        _scrollToInitialAyahIfNeeded();
        return;
      }

      // ------------------------------------------------------
      // ONLINE API
      // ------------------------------------------------------

      final url = Uri.parse(
        'https://api.alquran.cloud/v1/surah/'
        '${widget.surah.number}/editions/'
        'quran-uthmani,bn.bengali,ar.alafasy',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'কুরআনের ডাটা পাওয়া যায়নি।',
        );
      }

      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is! Map<String, dynamic>) {
        throw Exception(
          'কুরআনের ডাটা সঠিক নয়।',
        );
      }

      final data = decodedResponse['data'];

      if (data is! List || data.length < 3) {
        throw Exception(
          'কুরআনের ডাটা অসম্পূর্ণ।',
        );
      }

      final arabicEdition = data[0];
      final banglaEdition = data[1];
      final audioEdition = data[2];

      if (arabicEdition is! Map ||
          banglaEdition is! Map ||
          audioEdition is! Map) {
        throw Exception(
          'কুরআনের edition data সঠিক নয়।',
        );
      }

      final arabicData = arabicEdition['ayahs'];
      final banglaData = banglaEdition['ayahs'];
      final audioData = audioEdition['ayahs'];

      if (arabicData is! List || banglaData is! List || audioData is! List) {
        throw Exception(
          'আয়াতের ডাটা পাওয়া যায়নি।',
        );
      }

      final ayahs = <Ayah>[];

      final length = [
        arabicData.length,
        banglaData.length,
        audioData.length,
      ].reduce(
        (a, b) => a < b ? a : b,
      );

      for (int i = 0; i < length; i++) {
        final arabic = Map<String, dynamic>.from(
          arabicData[i],
        );

        final bangla = Map<String, dynamic>.from(
          banglaData[i],
        );

        final audio = Map<String, dynamic>.from(
          audioData[i],
        );

        final number = _toInt(
          arabic['number'],
        );

        final numberInSurah = _toInt(
          arabic['numberInSurah'],
        );

        final arabicText = arabic['text']?.toString() ?? '';

        final banglaText = bangla['text']?.toString() ?? '';

        final audioUrl = audio['audio']?.toString() ?? '';

        if (arabicText.isEmpty) {
          continue;
        }

        ayahs.add(
          Ayah(
            number: number,
            numberInSurah: numberInSurah,
            textArabic: arabicText,
            textBangla: banglaText,
            transliterationBangla: 'আয়াত নম্বর $numberInSurah',
            audioUrl: audioUrl,
          ),
        );
      }

      if (ayahs.isEmpty) {
        throw Exception(
          'কোনো আয়াত পাওয়া যায়নি।',
        );
      }

      await prefs.setString(
        cacheKey,
        jsonEncode(
          ayahs.map(_ayahToJson).toList(),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        currentAyahs = _applyAyahFilter(ayahs);
        isLoadingAyahs = false;
      });

      _scrollToInitialAyahIfNeeded();
    } catch (e) {
      final sampleData = sampleSurahsData[widget.surah.number];

      if (sampleData != null && sampleData.isNotEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          currentAyahs = _applyAyahFilter(List<Ayah>.from(sampleData));
          isLoadingAyahs = false;
        });

        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        currentAyahs = [];
        isLoadingAyahs = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'কুরআন লোড করা যায়নি।\n$e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // widget.showOnlyInitialAyah true হলে, লোড হওয়া সব আয়াত থেকে
  // শুধু widget.initialAyahNumber-এর আয়াতটা রেখে বাকি সব বাদ দেয় —
  // যাতে আয়াতুল কুরসীর জন্য পুরো সূরা না দেখিয়ে শুধু ওই একটাই দেখায়।
  // ==========================================================
  List<Ayah> _applyAyahFilter(List<Ayah> ayahs) {
    if (!widget.showOnlyInitialAyah || widget.initialAyahNumber == null) {
      return ayahs;
    }
    return ayahs
        .where((a) => a.numberInSurah == widget.initialAyahNumber)
        .toList();
  }

  // ==========================================================
  // widget.initialAyahNumber দেওয়া থাকলে (যেমন আয়াতুল কুরসীর জন্য
  // ২৫৫), সেই আয়াতের কাছে স্বয়ংক্রিয়ভাবে স্ক্রল করে নিয়ে যায়।
  // ==========================================================
  void _scrollToInitialAyahIfNeeded() {
    if (widget.showOnlyInitialAyah) return;
    final target = widget.initialAyahNumber;
    if (target == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _ayahKeys[target];
      final ctx = key?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          alignment: 0.1,
        );
      }
    });
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  Map<String, dynamic> _ayahToJson(Ayah ayah) {
    return {
      'number': ayah.number,
      'numberInSurah': ayah.numberInSurah,
      'textArabic': ayah.textArabic,
      'textBangla': ayah.textBangla,
      'transliterationBangla': ayah.transliterationBangla,
      'audioUrl': ayah.audioUrl,
    };
  }

  Ayah _ayahFromJson(
    Map<String, dynamic> json,
  ) {
    return Ayah(
      number: _toInt(json['number']),
      numberInSurah: _toInt(json['numberInSurah']),
      textArabic: json['textArabic']?.toString() ?? '',
      textBangla: json['textBangla']?.toString() ?? '',
      transliterationBangla: json['transliterationBangla']?.toString() ?? '',
      audioUrl: json['audioUrl']?.toString() ?? '',
    );
  }

  Future<void> _playAyah(int index) async {
    if (index < 0 || index >= currentAyahs.length) {
      return;
    }

    final ayah = currentAyahs[index];

    if (ayah.audioUrl.trim().isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'এই আয়াতের অডিও পাওয়া যায়নি।',
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        playingAyahIndex = index;
        isPlaying = false;
        isAudioLoading = true;
      });

      await _audioPlayer.stop();

      await _audioPlayer.play(
        UrlSource(
          ayah.audioUrl.trim(),
          mimeType: 'audio/mpeg',
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        playingAyahIndex = index;
        isPlaying = true;
        isAudioLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isPlaying = false;
        isAudioLoading = false;
        playingAyahIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'অডিও চালু করা যায়নি। আবার চেষ্টা করুন।',
          ),
        ),
      );
    }
  }

  Future<void> _togglePlayPause() async {
    if (isAudioLoading) {
      return;
    }

    if (playingAyahIndex == null) {
      if (currentAyahs.isNotEmpty) {
        await _playAyah(0);
      }

      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.pause();

        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      } else {
        await _audioPlayer.resume();

        if (mounted) {
          setState(() {
            isPlaying = true;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();

      if (!mounted) {
        return;
      }

      setState(() {
        isPlaying = false;
        playingAyahIndex = null;
        isAudioLoading = false;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSizes = {
      'sm': {
        'ar': 18.0,
        'bn': 11.0,
      },
      'md': {
        'ar': 24.0,
        'bn': 14.0,
      },
      'lg': {
        'ar': 29.0,
        'bn': 17.0,
      },
    }[fontSize]!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.showOnlyInitialAyah
                  ? 'আয়াতুল কুরসী'
                  : 'সূরা ${widget.surah.nameBangla}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.showOnlyInitialAyah
                  ? '${widget.surah.nameBangla} • আয়াত ${widget.initialAyahNumber}'
                  : '${widget.surah.nameArabic} • '
                      '${widget.surah.numberOfAyahs} আয়াত',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.text_fields,
            ),
            onSelected: (value) {
              setState(() {
                fontSize = value;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'sm',
                child: Text('ছোট'),
              ),
              PopupMenuItem(
                value: 'md',
                child: Text('মাঝারি'),
              ),
              PopupMenuItem(
                value: 'lg',
                child: Text('বড়'),
              ),
            ],
          ),
          IconButton(
            tooltip: isPlaying ? 'Pause' : 'Play',
            onPressed: isAudioLoading ? null : _togglePlayPause,
            icon: Icon(
              isAudioLoading
                  ? Icons.hourglass_top
                  : isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
            ),
          ),
          if (playingAyahIndex != null)
            IconButton(
              tooltip: 'Stop',
              onPressed: isAudioLoading ? null : _stopAudio,
              icon: const Icon(
                Icons.stop,
              ),
            ),
        ],
      ),
      body: isLoadingAyahs
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentAyahs.isEmpty
              ? const Center(
                  child: Text(
                    'কোনো আয়াত পাওয়া যায়নি।',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (!widget.showOnlyInitialAyah) _buildSurahInfo(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: currentAyahs.length,
                        itemBuilder: (context, index) {
                          return _buildAyahCard(
                            currentAyahs[index],
                            index,
                            fontSizes,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSurahInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        4,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E293B),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.surah.nameArabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            widget.surah.nameBangla,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${widget.surah.meaningBangla} • '
            '${widget.surah.revelationType == "Meccan" ? "মাক্কী" : "মাদানী"} • '
            '${widget.surah.numberOfAyahs} আয়াত',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(
    Ayah ayah,
    int index,
    Map<String, double> fontSizes,
  ) {
    final isCurrent = playingAyahIndex == index;
    final isHighlighted = widget.initialAyahNumber == ayah.numberInSurah;

    final key = _ayahKeys.putIfAbsent(ayah.numberInSurah, () => GlobalKey());

    return Container(
      key: key,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isHighlighted ? const Color(0xFF1B3A2E) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent || isHighlighted
              ? Colors.green
              : const Color(0xFF1E293B),
          width: isCurrent || isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green[800],
                child: Text(
                  '${ayah.numberInSurah}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: isAudioLoading ? null : () => _playAyah(index),
                icon: Icon(
                  isCurrent && isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ayah.textArabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizes['ar'],
              height: 2,
            ),
          ),
          if (ayah.transliterationBangla.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              ayah.transliterationBangla,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.green[300],
                fontSize: fontSizes['bn'],
                height: 1.7,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            ayah.textBangla,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: fontSizes['bn'],
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
