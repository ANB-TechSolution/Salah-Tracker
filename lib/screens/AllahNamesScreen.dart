import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AllahNamesScreen extends StatelessWidget {
  final List<Map<String, String>> allahNames = [
    {
      'arabic': 'الرَّحْمَن',
      'english': 'Ar-Rahman',
      'translationUrdu': 'رحمان',
      'translationEnglish': 'The Beneficent'
    },
    {
      'arabic': 'الرَّحِيم',
      'english': 'Ar-Raheem',
      'translationUrdu': 'رحیم',
      'translationEnglish': 'The Merciful'
    },
    {
      'arabic': 'الْمَلِك',
      'english': 'Al-Malik',
      'translationUrdu': 'مالک',
      'translationEnglish': 'The King'
    },
    {
      'arabic': 'الْقُدُّوس',
      'english': 'Al-Quddus',
      'translationUrdu': 'قدوس',
      'translationEnglish': 'The Most Sacred'
    },
    {
      'arabic': 'السَّلَام',
      'english': 'As-Salam',
      'translationUrdu': 'سلامتی دینے والا',
      'translationEnglish': 'The Source of Peace and Safety'
    },
    {
      'arabic': 'الْمُؤْمِن',
      'english': 'Al-Mu’min',
      'translationUrdu': 'ایمان دینے والا',
      'translationEnglish': 'The Guardian of Faith'
    },
    {
      'arabic': 'الْمُهَيْمِن',
      'english': 'Al-Muhaymin',
      'translationUrdu': 'محافظ',
      'translationEnglish': 'The Overseer'
    },
    {
      'arabic': 'الْعَزِيز',
      'english': 'Al-Aziz',
      'translationUrdu': 'عزت دینے والا',
      'translationEnglish': 'The Almighty'
    },
    {
      'arabic': 'الْجَبَّار',
      'english': 'Al-Jabbar',
      'translationUrdu': 'زبردست',
      'translationEnglish': 'The Compeller'
    },
    {
      'arabic': 'الْمُتَكَبِّر',
      'english': 'Al-Mutakabbir',
      'translationUrdu': 'بڑائی والا',
      'translationEnglish': 'The Supreme'
    },
    {
      'arabic': 'الْخَالِق',
      'english': 'Al-Khaliq',
      'translationUrdu': 'پیدا کرنے والا',
      'translationEnglish': 'The Creator'
    },
    {
      'arabic': 'الْبَارِئ',
      'english': 'Al-Bari',
      'translationUrdu': 'عدم سے وجود میں لانے والا',
      'translationEnglish': 'The Evolver'
    },
    {
      'arabic': 'الْمُصَوِّر',
      'english': 'Al-Musawwir',
      'translationUrdu': 'صورت گری کرنے والا',
      'translationEnglish': 'The Fashioner'
    },
    {
      'arabic': 'الْغَفَّار',
      'english': 'Al-Ghaffar',
      'translationUrdu': 'بہت بخشنے والا',
      'translationEnglish': 'The Constant Forgiver'
    },
    {
      'arabic': 'الْقَهَّار',
      'english': 'Al-Qahhar',
      'translationUrdu': 'زبردست غالب',
      'translationEnglish': 'The All-Subduer'
    },
    {
      'arabic': 'الْوَهَّاب',
      'english': 'Al-Wahhab',
      'translationUrdu': 'بہت عطا کرنے والا',
      'translationEnglish': 'The Supreme Bestower'
    },
    {
      'arabic': 'الرَّزَّاق',
      'english': 'Ar-Razzaq',
      'translationUrdu': 'بہت رزق دینے والا',
      'translationEnglish': 'The Provider'
    },
    {
      'arabic': 'الْفَتَّاح',
      'english': 'Al-Fattah',
      'translationUrdu': 'فتح دینے والا',
      'translationEnglish': 'The Supreme Solver'
    },
    {
      'arabic': 'اَلْعَلِيْمُ',
      'english': 'Al-Alim',
      'translationUrdu': 'سب کچھ جاننے والا',
      'translationEnglish': 'The All-Knowing'
    },
    {
      'arabic': 'الْقَابِض',
      'english': 'Al-Qabid',
      'translationUrdu': 'قبض کرنے والا',
      'translationEnglish': 'The Withholder'
    },
    {
      'arabic': 'الْبَاسِط',
      'english': 'Al-Basit',
      'translationUrdu': 'کشادگی کرنے والا',
      'translationEnglish': 'The Extender'
    },
    {
      'arabic': 'الْخَافِض',
      'english': 'Al-Khafid',
      'translationUrdu': 'پست کرنے والا',
      'translationEnglish': 'The Reducer'
    },
    {
      'arabic': 'الرَّافِع',
      'english': 'Ar-Rafi',
      'translationUrdu': 'بلند کرنے والا',
      'translationEnglish': 'The Exalter'
    },
    {
      'arabic': 'المعز',
      'english': 'Al-Mu’izz',
      'translationUrdu': 'عزت دینے والا',
      'translationEnglish': 'The Honourer'
    },
    {
      'arabic': 'المذل',
      'english': 'Al-Muzil',
      'translationUrdu': 'ذلت دینے والا',
      'translationEnglish': 'The Dishonourer'
    },
    {
      'arabic': 'السَّمِيع',
      'english': 'As-Sami’',
      'translationUrdu': 'سننے والا',
      'translationEnglish': 'The All-Hearing'
    },
    {
      'arabic': 'الْبَصِير',
      'english': 'Al-Basir',
      'translationUrdu': 'دیکھنے والا',
      'translationEnglish': 'The All-Seeing'
    },
    {
      'arabic': 'الْحَكَم',
      'english': 'Al-Hakam',
      'translationUrdu': 'فیصلہ کرنے والا',
      'translationEnglish': 'The Impartial Judge'
    },
    {
      'arabic': 'العَدْل',
      'english': 'Al-Adl',
      'translationUrdu': 'انصاف کرنے والا',
      'translationEnglish': 'The Utterly Just'
    },
    {
      'arabic': 'اللَّطِيف',
      'english': 'Al-Latif',
      'translationUrdu': 'مہربان',
      'translationEnglish': 'The Subtle One'
    },
    {
      'arabic': 'الخَبِير',
      'english': 'Al-Khabir',
      'translationUrdu': 'خبر رکھنے والا',
      'translationEnglish': 'The All-Aware'
    },
    {
      'arabic': 'الحلِيم',
      'english': 'Al-Halim',
      'translationUrdu': 'بردبار',
      'translationEnglish': 'The Most Forbearing'
    },
    {
      'arabic': 'العَظِيم',
      'english': 'Al-Azim',
      'translationUrdu': 'بزرگ',
      'translationEnglish': 'The Magnificent'
    },
    {
      'arabic': 'الغَفُور',
      'english': 'Al-Ghafoor',
      'translationUrdu': 'بہت بخشنے والا',
      'translationEnglish': 'The Great Forgiver'
    },
    {
      'arabic': 'الشَّكُور',
      'english': 'Ash-Shakoor',
      'translationUrdu': 'قدردان',
      'translationEnglish': 'The Most Appreciative'
    },
    {
      'arabic': 'العَلِي',
      'english': 'Al-Aliyy',
      'translationUrdu': 'بلند و برتر',
      'translationEnglish': 'The Most High'
    },
    {
      'arabic': 'الكَبِير',
      'english': 'Al-Kabeer',
      'translationUrdu': 'سب سے بڑا',
      'translationEnglish': 'The Most Great'
    },
    {
      'arabic': 'الحَفِيظ',
      'english': 'Al-Hafiz',
      'translationUrdu': 'حفاظت کرنے والا',
      'translationEnglish': 'The Preserver'
    },
    {
      'arabic': 'المُقيِت',
      'english': 'Al-Muqeet',
      'translationUrdu': 'ہر چیز کا نگہبان',
      'translationEnglish': 'The Sustainer'
    },
    {
      'arabic': 'الحسِيب',
      'english': 'Al-Hasib',
      'translationUrdu': 'حساب لینے والا',
      'translationEnglish': 'The Reckoner'
    },
    {
      'arabic': 'الجَلِيل',
      'english': 'Al-Jaleel',
      'translationUrdu': 'جلال والا',
      'translationEnglish': 'The Majestic'
    },
    {
      'arabic': 'الكَرِيم',
      'english': 'Al-Karim',
      'translationUrdu': 'نہایت کریم',
      'translationEnglish': 'The Most Generous'
    },
    {
      'arabic': 'الرَّقِيب',
      'english': 'Ar-Raqib',
      'translationUrdu': 'نگران',
      'translationEnglish': 'The Watchful'
    },
    {
      'arabic': 'المُجِيب',
      'english': 'Al-Mujib',
      'translationUrdu': 'قبول کرنے والا',
      'translationEnglish': 'The Responsive One'
    },
    {
      'arabic': 'الوَاسِع',
      'english': 'Al-Wasi’',
      'translationUrdu': 'وسعت والا',
      'translationEnglish': 'The All-Encompassing'
    },
    {
      'arabic': 'الحكِيم',
      'english': 'Al-Hakim',
      'translationUrdu': 'حکمت والا',
      'translationEnglish': 'The All-Wise'
    },
    {
      'arabic': 'الوَدُود',
      'english': 'Al-Wadud',
      'translationUrdu': 'محبت کرنے والا',
      'translationEnglish': 'The Most Loving'
    },
    {
      'arabic': 'المَجِيد',
      'english': 'Al-Majeed',
      'translationUrdu': 'عظمت والا',
      'translationEnglish': 'The Glorious, the Most Honorable'
    },
    {
      'arabic': 'البَاعِث',
      'english': 'Al-Ba’ith',
      'translationUrdu': 'اٹھانے والا',
      'translationEnglish': 'The Infuser of New Life'
    },
    {
      'arabic': 'الشَّهِيد',
      'english': 'Ash-Shaheed',
      'translationUrdu': 'گواہ',
      'translationEnglish': 'The All-and-Ever Witnessing'
    },
    {
      'arabic': 'الحَق',
      'english': 'Al-Haqq',
      'translationUrdu': 'سچ',
      'translationEnglish': 'The Absolute Truth'
    },
    {
      'arabic': 'الوَكِيل',
      'english': 'Al-Wakeel',
      'translationUrdu': 'کارساز',
      'translationEnglish': 'The Trustee'
    },
    {
      'arabic': 'القَوِي',
      'english': 'Al-Qawwiyy',
      'translationUrdu': 'بہت طاقتور',
      'translationEnglish': 'The All-Strong'
    },
    {
      'arabic': 'المَتِين',
      'english': 'Al-Mateen',
      'translationUrdu': 'نہایت مضبوط',
      'translationEnglish': 'The Firm One'
    },
    {
      'arabic': 'الوَلِي',
      'english': 'Al-Waliyy',
      'translationUrdu': 'دوست و مددگار',
      'translationEnglish': 'The Sole-Authority'
    },
    {
      'arabic': 'الحَمِيد',
      'english': 'Al-Hamid',
      'translationUrdu': 'لائقِ تعریف',
      'translationEnglish': 'The Praiseworthy'
    },
    {
      'arabic': 'المُحصِي',
      'english': 'Al-Muhsi',
      'translationUrdu': 'گننے والا',
      'translationEnglish': 'The All-Enumerating, the Counter'
    },
    {
      'arabic': 'المُبدِئ',
      'english': 'Al-Mubdi',
      'translationUrdu': 'عدم سے وجود میں لانے والا',
      'translationEnglish': 'The Originator, the Initiator'
    },
    {
      'arabic': 'المُعِيد',
      'english': 'Al-Mueed',
      'translationUrdu': 'دوبارہ زندہ کرنے والا',
      'translationEnglish': 'The Restorer, the Reinstater'
    },
    {
      'arabic': 'المُحيِي',
      'english': 'Al-Muhyi',
      'translationUrdu': 'زندگی دینے والا',
      'translationEnglish': 'The Giver of Life'
    },
    {
      'arabic': 'المُمِيت',
      'english': 'Al-Mumeet',
      'translationUrdu': 'موت دینے والا',
      'translationEnglish': 'The Creator of Death'
    },
    {
      'arabic': 'الحَي',
      'english': 'Al-Hayy',
      'translationUrdu': 'زندہ',
      'translationEnglish': 'The Ever-Living'
    },
    {
      'arabic': 'القَيُّوم',
      'english': 'Al-Qayyum',
      'translationUrdu': 'قائم رہنے والا',
      'translationEnglish': 'The Sustainer, the Self-Subsisting'
    },
    {
      'arabic': 'الوَاجِد',
      'english': 'Al-Wajid',
      'translationUrdu': 'پانے والا',
      'translationEnglish': 'The Perceiver'
    },
    {
      'arabic': 'المَاجِد',
      'english': 'Al-Majid',
      'translationUrdu': 'بزرگی والا',
      'translationEnglish': 'The Glorious, the Most Honorable'
    },
    {
      'arabic': 'الوَاحِد',
      'english': 'Al-Wahid',
      'translationUrdu': 'واحد',
      'translationEnglish': 'The Only One'
    },
    {
      'arabic': 'أَحَد',
      'english': 'Al-Ahad',
      'translationUrdu': 'واحد',
      'translationEnglish': 'The One'
    },
    {
      'arabic': 'الصَّمَد',
      'english': 'As-Samad',
      'translationUrdu': 'بے نیاز',
      'translationEnglish': 'The Self-Sufficient, the Impregnable'
    },
    {
      'arabic': 'القَادِر',
      'english': 'Al-Qadir',
      'translationUrdu': 'قدرت رکھنے والا',
      'translationEnglish': 'The Omnipotent'
    },
    {
      'arabic': 'المُقتَدِر',
      'english': 'Al-Muqtadir',
      'translationUrdu': 'ہر چیز پر قدرت رکھنے والا',
      'translationEnglish': 'The Creator of All Power'
    },
    {
      'arabic': 'المُقَدِّم',
      'english': 'Al-Muqaddim',
      'translationUrdu': 'آگے بڑھانے والا',
      'translationEnglish': 'The Expediter, the Promoter'
    },
    {
      'arabic': 'المُؤَخِّر',
      'english': 'Al-Mu’akhkhir',
      'translationUrdu': 'پیچھے رکھنے والا',
      'translationEnglish': 'The Delayer'
    },
    {
      'arabic': 'الأوَّل',
      'english': 'Al-Awwal',
      'translationUrdu': 'سب سے پہلا',
      'translationEnglish': 'The First'
    },
    {
      'arabic': 'الآخِر',
      'english': 'Al-Akhir',
      'translationUrdu': 'سب کے بعد آنے والا',
      'translationEnglish': 'The Last'
    },
    {
      'arabic': 'الظَّاهِر',
      'english': 'Az-Zahir',
      'translationUrdu': 'ظاہر',
      'translationEnglish': 'The Manifest'
    },
    {
      'arabic': 'البَاطِن',
      'english': 'Al-Batin',
      'translationUrdu': 'پوشیدہ',
      'translationEnglish': 'The Hidden One, Knower of the Hidden'
    },
    {
      'arabic': 'الوَالِي',
      'english': 'Al-Wali',
      'translationUrdu': 'نگہبان',
      'translationEnglish': 'The Sole Governor'
    },
    {
      'arabic': 'المُتَعَالِي',
      'english': 'Al-Muta’ali',
      'translationUrdu': 'بلند مرتبہ',
      'translationEnglish': 'The Self Exalted'
    },
    {
      'arabic': 'البَرّ',
      'english': 'Al-Barr',
      'translationUrdu': 'نیکی کرنے والا',
      'translationEnglish': 'The Source of All Goodness'
    },
    {
      'arabic': 'التَّوَاب',
      'english': 'At-Tawwab',
      'translationUrdu': 'توبہ قبول کرنے والا',
      'translationEnglish': 'The Ever-Accepter of Repentance'
    },
    {
      'arabic': 'المُنتَقِم',
      'english': 'Al-Muntaqim',
      'translationUrdu': 'بدلہ لینے والا',
      'translationEnglish': 'The Avenger'
    },
    {
      'arabic': 'العَفُو',
      'english': 'Al-Afuww',
      'translationUrdu': 'معاف کرنے والا',
      'translationEnglish': 'The Pardoner'
    },
    {
      'arabic': 'الرَّؤُوف',
      'english': 'Ar-Ra’uf',
      'translationUrdu': 'نہایت مہربان',
      'translationEnglish': 'The Most Kind'
    },
    {
      'arabic': 'مَالِكُ ٱلْمُلْك',
      'english': 'Malik-ul-Mulk',
      'translationUrdu': 'بادشاہوں کا بادشاہ',
      'translationEnglish': 'Master of the Kingdom, Owner of the Dominion'
    },
    {
      'arabic': 'ذُوالْجَلَالِ وَالإكْرَام',
      'english': 'Dhul-Jalali Wal-Ikram',
      'translationUrdu': 'جلال اور عزت والا',
      'translationEnglish':
          'Possessor of Glory and Honour, Lord of Glory and Generosity'
    },
    {
      'arabic': 'المُقْسِط',
      'english': 'Al-Muqsit',
      'translationUrdu': 'انصاف کرنے والا',
      'translationEnglish': 'The Just One'
    },
    {
      'arabic': 'الجَامِع',
      'english': 'Al-Jami’',
      'translationUrdu': 'اکٹھا کرنے والا',
      'translationEnglish': 'The Gatherer, the Uniter'
    },
    {
      'arabic': 'الغَني',
      'english': 'Al-Ghaniyy',
      'translationUrdu': 'بے نیاز',
      'translationEnglish': 'The Self-Sufficient, the Wealthy'
    },
    {
      'arabic': 'المُغنِي',
      'english': 'Al-Mughni',
      'translationUrdu': 'غنی کرنے والا',
      'translationEnglish': 'The Enricher'
    },
    {
      'arabic': 'المَانِع',
      'english': 'Al-Mani’',
      'translationUrdu': 'روکنے والا',
      'translationEnglish': 'The Withholder'
    },
    {
      'arabic': 'الضَّار',
      'english': 'Ad-Darr',
      'translationUrdu': 'نقصان دینے والا',
      'translationEnglish': 'The Creator of The Harmful'
    },
    {
      'arabic': 'النَّافِع',
      'english': 'An-Nafi’',
      'translationUrdu': 'فائدہ دینے والا',
      'translationEnglish': 'The Creator of Good'
    },
    {
      'arabic': 'النُّور',
      'english': 'An-Nur',
      'translationUrdu': 'روشنی',
      'translationEnglish': 'The Light'
    },
    {
      'arabic': 'الهَادِي',
      'english': 'Al-Hadi',
      'translationUrdu': 'رہنمائی کرنے والا',
      'translationEnglish': 'The Guide'
    },
    {
      'arabic': 'البَدِيع',
      'english': 'Al-Badi',
      'translationUrdu': 'انوکھا',
      'translationEnglish': 'The Incomparable Originator'
    },
    {
      'arabic': 'البَاقِي',
      'english': 'Al-Baqi',
      'translationUrdu': 'ہمیشہ باقی رہنے والا',
      'translationEnglish': 'The Ever-Surviving'
    },
    {
      'arabic': 'الوَارِث',
      'english': 'Al-Warith',
      'translationUrdu': 'سب کا وارث',
      'translationEnglish': 'The Inheritor, the Heir'
    },
    {
      'arabic': 'الرَّشِيد',
      'english': 'Ar-Rashid',
      'translationUrdu': 'رہنمائی دینے والا',
      'translationEnglish': 'The Guide, Infallible Teacher, and Knower'
    },
    {
      'arabic': 'الصَّبُور',
      'english': 'As-Sabur',
      'translationUrdu': 'صبر کرنے والا',
      'translationEnglish': 'The Forbearing, the Patient'
    }
  ];

  Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('99 Names of Allah'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allahNames.length,
        itemBuilder: (context, index) {
          final name = allahNames[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        name['arabic']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        name['english']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      name['translationEnglish']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      name['translationUrdu']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.teal),
                        onPressed: () => copyToClipboard(context,
                            '${name['arabic']} (${name['english']}): ${name['translationEnglish']}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.teal),
                        onPressed: () => Share.share(
                            '${name['arabic']} (${name['english']}): ${name['translationEnglish']}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
