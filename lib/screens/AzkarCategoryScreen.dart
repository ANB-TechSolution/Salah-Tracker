import 'package:flutter/material.dart';
import 'package:salahtracker/screens/AzkarListScreen.dart';

class AzkarCategoryScreen extends StatelessWidget {
  final List<Map<String, String>> azkarCategories = [
    {
      'name': 'Morning/Evening Azkar',
      'urdu': 'صبح/شام کے اذکار',
      'arabic': 'أذكار المساء/أذكار الصباح'
    },
    {
      'name': 'Before Sleep',
      'urdu': 'سونے سے پہلے',
      'arabic': 'أذكار قبل النوم'
    },
    {
      'name': 'After Waking Up',
      'urdu': 'اٹھنے کے بعد',
      'arabic': 'أذكار الاستيقاظ'
    },
    {'name': 'Prayer Azkar', 'urdu': 'نماز کے اذکار', 'arabic': 'أذكار الصلاة'},
    {'name': 'Travel Azkar', 'urdu': 'سفر کے اذکار', 'arabic': 'أذكار السفر'},
    {
      'name': 'Gratitude Azkar',
      'urdu': 'شکر کے اذکار',
      'arabic': 'أذكار الشكر'
    },
    {
      'name': 'Forgiveness Azkar',
      'urdu': 'معافی کے اذکار',
      'arabic': 'أذكار الاستغفار'
    },
    {
      'name': 'Protection Azkar',
      'urdu': 'حفاظت کے اذکار',
      'arabic': 'أذكار الحماية'
    },
    {'name': 'Health Azkar', 'urdu': 'صحت کے اذکار', 'arabic': 'أذكار الصحة'},
    {'name': 'Rain Azkar', 'urdu': 'بارش کے اذکار', 'arabic': 'أذكار المطر'},
    {
      'name': 'Hajj & Umrah Azkar',
      'urdu': 'حج و عمرہ کے اذکار',
      'arabic': 'أذكار الحج والعمرة'
    },
    {
      'name': 'Repentance Azkar',
      'urdu': 'توبہ کے اذکار',
      'arabic': 'أذكار التوبة'
    },
    {
      'name': 'Eating Azkar',
      'urdu': 'کھانے کے اذکار',
      'arabic': 'أذكار الطعام'
    },
    {
      'name': 'Dua for Anxiety',
      'urdu': 'پریشانی کے اذکار',
      'arabic': 'أذكار القلق'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Azkar Categories'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: azkarCategories.length,
        itemBuilder: (context, index) {
          final category = azkarCategories[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                category['name']!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${category['urdu']} | ${category['arabic']}',
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AzkarListScreen(
                      categoryName: category['name']!,
                      categoryAzkar: _getAzkarByCategory(category['name']!),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getAzkarByCategory(String category) {
    // Example Azkar for different categories
    final Map<String, List<Map<String, String>>> azkarData = {
      'Morning/Evening Azkar': [
        {
          'arabic': 'اللّهُمَّ أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ...',
          'english':
              'O Allah! We have entered the morning, and so has the dominion of Allah...',
          'urdu': 'اے اللہ! ہم نے صبح کی اور بادشاہت بھی اللہ کی ہوئی...'
        },
        {
          'arabic': 'اللّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ...',
          'english':
              'O Allah! Whatever blessing I or anyone else received this morning...',
          'urdu': 'اے اللہ! جو بھی نعمت میں نے یا کسی اور نے آج صبح حاصل کی...'
        }
      ],
      'Before Sleep': [
        {
          'arabic': 'اللّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا...',
          'english': 'O Allah! In Your Name I die and I live...',
          'urdu': 'اے اللہ! تیرے نام پر میں مرتا اور زندہ ہوتا ہوں...'
        },
        {
          'arabic': 'اللّهُمَّ احْفَظْنِي فِي لَيْلِي...',
          'english': 'O Allah! Protect me in my night...',
          'urdu': 'اے اللہ! مجھے میری رات میں محفوظ رکھ...'
        }
      ],
      'After Waking Up': [
        {
          'arabic':
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا...',
          'english': 'All praise is to Allah who gave us life after death...',
          'urdu':
              'تمام تعریفیں اللہ کے لئے ہیں جس نے ہمیں موت کے بعد زندگی عطا کی...'
        }
      ],
      'Prayer Azkar': [
        {
          'arabic': 'اللّهُمَّ اجْعَلْنِي مِنَ الْمُخْلِصِينَ...',
          'english': 'O Allah! Make me among the sincere...',
          'urdu': 'اے اللہ! مجھے مخلص لوگوں میں شامل کر...'
        }
      ],
      'Travel Azkar': [
        {
          'arabic':
              'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ...',
          'english': 'Glory is to Him who has subjected this to us...',
          'urdu': 'پاک ہے وہ جس نے ہمارے لئے اسے تابع کیا...'
        }
      ],
      'Gratitude Azkar': [
        {
          'arabic': 'الْحَمْدُ لِلَّهِ عَلَى كُلِّ حَالٍ...',
          'english': 'Praise be to Allah in every condition...',
          'urdu': 'ہر حال میں اللہ کا شکر...'
        }
      ],
      'Forgiveness Azkar': [
        {
          'arabic': 'اللّهُمَّ اغْفِرْ لِي ذُنُوبِي كُلَّهَا...',
          'english': 'O Allah! Forgive me all my sins...',
          'urdu': 'اے اللہ! میرے تمام گناہ معاف فرما...'
        }
      ],
      'Protection Azkar': [
        {
          'arabic': 'اللّهُمَّ احْفَظْنَا مِنْ كُلِّ شَرٍّ...',
          'english': 'O Allah! Protect us from every evil...',
          'urdu': 'اے اللہ! ہمیں ہر شر سے محفوظ رکھ...'
        }
      ],
      'Health Azkar': [
        {
          'arabic': 'اللّهُمَّ اشْفِنِي وَاشْفِ كُلَّ مَرِيضٍ...',
          'english': 'O Allah! Heal me and heal every sick person...',
          'urdu': 'اے اللہ! مجھے اور ہر مریض کو شفا دے...'
        }
      ],
      'Rain Azkar': [
        {
          'arabic': 'اللّهُمَّ صَيِّبًا نَافِعًا...',
          'english': 'O Allah! Make it beneficial rain...',
          'urdu': 'اے اللہ! اسے فائدہ مند بارش بنا دے...'
        }
      ],
      'Hajj & Umrah Azkar': [
        {
          'arabic':
              'اللّهُمَّ اجْعَلْ حَجِّي مَبْرُورًا وَسَعْيِي مَشْكُورًا...',
          'english':
              'O Allah! Make my Hajj accepted and my efforts rewarded...',
          'urdu': 'اے اللہ! میرے حج کو قبول اور میری کوششوں کو مشکور بنا...'
        }
      ],
      'Repentance Azkar': [
        {
          'arabic': 'اللّهُمَّ تَبْ عَلَيَّ وَاغْفِرْ لِي ذُنُوبِي...',
          'english': 'O Allah! Accept my repentance and forgive my sins...',
          'urdu': 'اے اللہ! میری توبہ قبول فرما اور میرے گناہ معاف کر دے...'
        }
      ],
      'Eating Azkar': [
        {
          'arabic': 'اللّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا...',
          'english': 'O Allah! Bless us in what You have provided for us...',
          'urdu': 'اے اللہ! جو تو نے عطا کیا ہے اس میں برکت ڈال...'
        }
      ],
      'Dua for Anxiety': [
        {
          'arabic':
              'اللّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحُزْنِ...',
          'english': 'O Allah! I seek refuge in You from anxiety and sorrow...',
          'urdu': 'اے اللہ! میں تجھ سے غم و پریشانی سے پناہ مانگتا ہوں...'
        }
      ],
    };

    return azkarData[category] ?? [];
  }
}
