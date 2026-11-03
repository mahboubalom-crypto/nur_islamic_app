import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ==========================================================
// DATA
// ==========================================================

class ParaAudio {
  final int number;
  final String titleBangla;
  final String audioUrl;

  const ParaAudio({
    required this.number,
    required this.titleBangla,
    required this.audioUrl,
  });
}

/// 30 Para (Juz) — audio: Qari Maher Al-Muaiqly (archive.org, streamable).
/// Arabic text is fetched live from the alquran.cloud API (juz endpoint)
/// and cached locally, the same way quran_section.dart caches surahs.
final List<ParaAudio> paraAudioList = List.generate(30, (index) {
  final number = index + 1;
  final padded = number.toString().padLeft(2, '0');
  return ParaAudio(
    number: number,
    titleBangla: 'পারা $number',
    audioUrl:
        'https://archive.org/download/quran-juz-audio-mp3/Para%20$padded.mp3',
  );
});

class ParaAyah {
  final int numberInSurah;
  final int surahNumber;
  final String surahNameArabic;
  final String textArabic;

  const ParaAyah({
    required this.numberInSurah,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.textArabic,
  });
}

// ==========================================================
// PARA LIST PAGE
// ==========================================================

class TelawatSection extends StatelessWidget {
  const TelawatSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 16),
        _buildParaList(context, isDark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.graphic_eq, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                'তেলাওয়াত',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'সম্পূর্ণ ৩০ পারা কুরআন — আরবি টেক্সট সহ অডিও তেলাওয়াত • ক্বারী: মাহের আল-মুয়াইক্বলী',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildParaList(BuildContext context, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paraAudioList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final para = paraAudioList[index];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ParaReaderPage(para: para),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
                    border: Border.all(color: Colors.green[800]!),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${para.number}',
                    style: TextStyle(
                      color: Colors.green[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    para.titleBangla,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
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
// PARA READER (Arabic text + continuous audio)
// ==========================================================

class ParaReaderPage extends StatefulWidget {
  final ParaAudio para;

  const ParaReaderPage({super.key, required this.para});

  @override
  State<ParaReaderPage> createState() => _ParaReaderPageState();
}

class _ParaReaderPageState extends State<ParaReaderPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<ParaAyah> ayahs = [];
  bool isLoadingText = true;
  String? loadError;

  bool isPlaying = false;
  bool isAudioLoading = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
        if (state == PlayerState.stopped || state == PlayerState.completed) {
          isAudioLoading = false;
        }
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => position = p);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => duration = d);
    });

    _loadParaText();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadParaText() async {
    final cacheKey = 'quran_para_${widget.para.number}';

    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(cacheKey);

      if (cached != null && cached.isNotEmpty) {
        try {
          final decoded = jsonDecode(cached);
          if (decoded is List) {
            final cachedAyahs = decoded
                .map((e) => _ayahFromJson(Map<String, dynamic>.from(e)))
                .toList();
            if (cachedAyahs.isNotEmpty) {
              if (!mounted) return;
              setState(() {
                ayahs = cachedAyahs;
                isLoadingText = false;
              });
              return;
            }
          }
        } catch (_) {
          await prefs.remove(cacheKey);
        }
      }

      final url = Uri.parse(
        'https://api.alquran.cloud/v1/juz/${widget.para.number}/quran-uthmani',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('পারার টেক্সট পাওয়া যায়নি।');
      }

      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is! Map<String, dynamic>) {
        throw Exception('ডাটা সঠিক নয়।');
      }

      final data = decodedResponse['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('ডাটা অসম্পূর্ণ।');
      }

      final ayahsData = data['ayahs'];

      if (ayahsData is! List) {
        throw Exception('আয়াতের ডাটা পাওয়া যায়নি।');
      }

      final parsed = <ParaAyah>[];

      for (final item in ayahsData) {
        final ayahMap = Map<String, dynamic>.from(item);
        final surah = ayahMap['surah'];
        final surahMap = surah is Map
            ? Map<String, dynamic>.from(surah)
            : <String, dynamic>{};

        parsed.add(
          ParaAyah(
            numberInSurah: _toInt(ayahMap['numberInSurah']),
            surahNumber: _toInt(surahMap['number']),
            surahNameArabic: surahMap['name']?.toString() ?? '',
            textArabic: ayahMap['text']?.toString() ?? '',
          ),
        );
      }

      if (parsed.isEmpty) {
        throw Exception('কোনো আয়াত পাওয়া যায়নি।');
      }

      await prefs.setString(
        cacheKey,
        jsonEncode(parsed.map(_ayahToJson).toList()),
      );

      if (!mounted) return;
      setState(() {
        ayahs = parsed;
        isLoadingText = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingText = false;
        loadError =
            'পারার আরবি টেক্সট লোড করা যায়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> _ayahToJson(ParaAyah a) => {
        'numberInSurah': a.numberInSurah,
        'surahNumber': a.surahNumber,
        'surahNameArabic': a.surahNameArabic,
        'textArabic': a.textArabic,
      };

  ParaAyah _ayahFromJson(Map<String, dynamic> json) => ParaAyah(
        numberInSurah: _toInt(json['numberInSurah']),
        surahNumber: _toInt(json['surahNumber']),
        surahNameArabic: json['surahNameArabic']?.toString() ?? '',
        textArabic: json['textArabic']?.toString() ?? '',
      );

  Future<void> _togglePlayPause() async {
    if (isAudioLoading) return;

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      if (position == Duration.zero && duration == Duration.zero) {
        setState(() => isAudioLoading = true);
        await _audioPlayer.play(
          UrlSource(widget.para.audioUrl, mimeType: 'audio/mpeg'),
        );
        if (!mounted) return;
        setState(() => isAudioLoading = false);
      } else {
        await _audioPlayer.resume();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => isAudioLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অডিও চালু করা যায়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।'),
        ),
      );
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    if (!mounted) return;
    setState(() {
      isPlaying = false;
      position = Duration.zero;
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: Text(widget.para.titleBangla),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoadingText
                ? const Center(child: CircularProgressIndicator())
                : loadError != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            loadError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    : _buildAyahList(),
          ),
          _buildAudioBar(),
        ],
      ),
    );
  }

  Widget _buildAyahList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ayahs.length,
      itemBuilder: (context, index) {
        final ayah = ayahs[index];
        final isNewSurah =
            index == 0 || ayahs[index - 1].surahNumber != ayah.surahNumber;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isNewSurah) ...[
              if (index != 0) const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Text(
                  'সূরা ${ayah.surahNameArabic}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.green[800],
                    child: Text(
                      '${ayah.numberInSurah}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ayah.textArabic,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAudioBar() {
    final total = duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: position.inMilliseconds.clamp(0, total).toDouble(),
            max: total.toDouble(),
            activeColor: Colors.green,
            onChanged: duration == Duration.zero
                ? null
                : (value) {
                    _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                  },
          ),
          Row(
            children: [
              Text(
                '${_formatDuration(position)} / ${_formatDuration(duration)}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const Spacer(),
              IconButton(
                onPressed: isAudioLoading ? null : _togglePlayPause,
                icon: Icon(
                  isAudioLoading
                      ? Icons.hourglass_top
                      : isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                  color: Colors.green,
                  size: 36,
                ),
              ),
              IconButton(
                onPressed: isAudioLoading ? null : _stop,
                icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
