import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salahtracker/utils/helper_function.dart';
import 'package:share_plus/share_plus.dart';

class SixKalmaScreen extends StatelessWidget {
  final List<Map<String, String>> kalmas = [
    {
      'name': 'First Kalma - Kalma Tayyab',
      'arabic': 'لَا اِلٰهَ اِلَّا اللّهُ مُحَمَّدٌ رَسُوْلُ اللّهِ',
      'english':
          'There is no God but Allah, and Muhammad is the Messenger of Allah.',
      'urdu': 'اللہ کے سوا کوئی معبود نہیں، محمدﷺ اللہ کے رسول ہیں۔',
    },
    {
      'name': 'Second Kalma - Kalma Shahadat',
      'arabic':
          'اَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللّهُ وَ اَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهُ وَ رَسُوْلُهُ',
      'english':
          'I bear witness that there is no God but Allah, and I bear witness that Muhammad is His servant and His Messenger.',
      'urdu':
          'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں اور محمدﷺ اس کے بندے اور رسول ہیں۔',
    },
    {
      'name': 'Third Kalma - Kalma Tamjeed',
      'arabic':
          'سُبْحَانَ اللّهِ وَ الْحَمْدُ لِلّهِ وَ لَا اِلٰهَ اِلَّا اللّهُ وَاللّهُ اَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ اِلَّا بِاللّهِ',
      'english':
          'Glory is for Allah and all praise is for Allah, and there is no God but Allah, and Allah is the Greatest. There is no power or strength except with Allah.',
      'urdu':
          'اللہ پاک ہے، تمام تعریفیں اللہ کے لیے ہیں، اللہ کے سوا کوئی معبود نہیں، اللہ سب سے بڑا ہے۔ طاقت اور قوت صرف اللہ کے ساتھ ہے۔',
    },
    {
      'name': 'Fourth Kalma - Kalma Tawheed',
      'arabic':
          'لَا اِلٰهَ اِلَّا اللّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ اَبَدًا اَبَدًا ذُوالْجَلَالِ وَالْاِكْرَامِ بِيَدِهِ الْخَيْرُ وَهُوَ عَلٰى كُلِّ شَيْءٍ قَدِيرٌ',
      'english':
          'There is no God but Allah. He is One. He has no partner. His is the Kingdom, and His is the Praise. He gives life and causes death. He is Ever-Living and does not die, forever and ever. He is the Possessor of glory and honor. In His hand is all good, and He has power over everything.',
      'urdu':
          'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہی ہے اور تمام تعریفیں اسی کے لیے ہیں، وہی زندگی دیتا ہے اور موت دیتا ہے، وہ ہمیشہ ہمیشہ کے لیے زندہ ہے، اسے کبھی موت نہیں آئے گی۔ عظمت اور بزرگی والا ہے، تمام بھلائی اس کے ہاتھ میں ہے، اور وہ ہر چیز پر قادر ہے۔',
    },
    {
      'name': 'Fifth Kalma - Kalma Astaghfar',
      'arabic':
          'اَسْتَغْفِرُ اللّهَ رَبِّي مِنْ كُلِّ ذَنْبٍ اَذْنَبْتُهُ عَمْدًا اَوْ خَطَاً سِرًّا اَوْ عَلَانِيَةً وَاَتُوْبُ اِلَيْهِ مِنَ الذَّنْبِ الَّذِي اَعْلَمُ وَمِنَ الذَّنْبِ الَّذِي لَا اَعْلَمُ اِنَّكَ اَنْتَ عَلَّامُ الْغُيُوْبِ وَسَتَّارُ الْعُيُوْبِ وَغَفَّارُ الذُّنُوْبِ وَلَا حَوْلَ وَلَا قُوَّةَ اِلَّا بِاللّهِ الْعَلِيِّ الْعَظِيْمِ',
      'english':
          'I seek forgiveness from Allah, my Lord, for all sins I committed knowingly or unknowingly, secretly or openly. I turn to Him in repentance for sins I am aware of and sins I am not aware of. Indeed, You are the Knower of the unseen, the Concealer of faults, the Forgiver of sins, and there is no power or strength except with Allah, the Most High, the Most Great.',
      'urdu':
          'میں اللہ سے معافی مانگتا ہوں، جو میرا رب ہے، ان تمام گناہوں کے لیے جو میں نے جان بوجھ کر یا بھول کر، خفیہ یا اعلانیہ کیے ہیں۔ اور میں ان گناہوں سے توبہ کرتا ہوں جنہیں میں جانتا ہوں اور جنہیں میں نہیں جانتا۔ بے شک، آپ غیب جاننے والے، عیب چھپانے والے، گناہ معاف کرنے والے ہیں، اور اللہ بلند و برتر کے سوا کوئی طاقت یا قوت نہیں۔',
    },
    {
      'name': 'Sixth Kalma - Kalma Radde Kufr',
      'arabic':
          'اَللّهُمَّ اِنِّى اَعُوْذُ بِكَ مِنْ اَنْ اُشْرِكَ بِكَ شَيْئًا وَّاَنَا اَعْلَمُ بِهِ وَ اَسْتَغْفِرُكَ لِمَا لَا اَعْلَمُ بِهِ تُبْتُ عَنْهُ وَتَبَرَّأْتُ مِنَ الْكُفْرِ وَالشِّرْكِ وَالْكِذْبِ وَالْغِيْبَةِ وَالْبِدْعَةِ وَالْبُهْتَانِ وَالْمَعَاصِيْ كُلِّهَا وَاَسْلَمْتُ وَاَقُوْلُ لَا اِلٰهَ اِلَّا اللّهُ مُحَمَّدٌ رَسُوْلُ اللّهِ',
      'english':
          'O Allah! I seek refuge in You from knowingly associating partners with You, and I seek Your forgiveness for what I do not know. I repent from it and declare myself free from disbelief, polytheism, falsehood, slander, innovation, backbiting, and all disobedience. I submit to You and say: There is no God but Allah, Muhammad is the Messenger of Allah.',
      'urdu':
          'اے اللہ! میں آپ کی پناہ چاہتا ہوں کہ جان بوجھ کر آپ کے ساتھ کسی کو شریک کروں اور میں اس کے لیے آپ سے معافی مانگتا ہوں جسے میں نہیں جانتا۔ میں اس سے توبہ کرتا ہوں اور کفر، شرک، جھوٹ، غیبت، بدعت، بہتان اور تمام نافرمانیوں سے براءت کا اعلان کرتا ہوں۔ میں نے اسلام قبول کیا اور کہتا ہوں: اللہ کے سوا کوئی معبود نہیں، محمدﷺ اللہ کے رسول ہیں۔',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text("6 Kalmas"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: kalmas.length,
        itemBuilder: (context, index) {
          final kalma = kalmas[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Section
                  Text(
                    kalma['name']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Arabic Text
                  Text(
                    kalma['arabic']!,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HelperFunction.isDarkMode(context)
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: const Color.fromARGB(255, 207, 207, 207)),
                  SizedBox(height: 10),
                  // English Translation
                  Text(
                    "English Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    kalma['english']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: HelperFunction.isDarkMode(context)
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Urdu Translation
                  Text(
                    "Urdu Translation:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    kalma['urdu']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: HelperFunction.isDarkMode(context)
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Copy and Share Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  "${kalma['name']}\n\n${kalma['arabic']}\n\nEnglish Translation: ${kalma['english']}\n\nUrdu Translation: ${kalma['urdu']}"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied to clipboard")),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text("Copy"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(
                              "${kalma['name']}\n\n${kalma['arabic']}\n\nEnglish Translation: ${kalma['english']}\n\nUrdu Translation: ${kalma['urdu']}");
                        },
                        icon: Icon(Icons.share),
                        label: Text("Share"),
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
