import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/custom_app_bar.dart';
import 'package:co_habit_frontend/presentation/screens/home/widgets/home_screen_navbar.dart';
import 'package:co_habit_frontend/presentation/screens/taches/taches_card.dart';
import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';
import 'package:co_habit_frontend/presentation/widgets/common/flexible_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  String firstName = 'Rocio';
  String lastName = 'Sierra';

  final tachesInfosMock = <Map<String, dynamic>>[
    {
      'firstName': 'Carlos',
      'lastName': 'Ceren',
      'title': 'Réparer lavabo',
      'category': 'Réparation',
      'date': DateTime(2025, 5, 31),
      'status': TacheStatus.termine
    },
    {
      'firstName': 'Bertrand',
      'lastName': 'Renaudin',
      'title': 'Faire la vaisselle',
      'category': 'Ménage',
      'date': DateTime(2025, 5, 22),
      'status': TacheStatus.enAttente
    },
    {
      'firstName': 'Dmitri',
      'lastName': 'Chine',
      'title': 'Acheter PQ',
      'category': 'Courses',
      'date': DateTime(2025, 5, 23),
      'status': TacheStatus.enCours
    }
  ];

  String _getInitials(String first, String last) {
    return '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        firstName: firstName,
        lastName: lastName,
        avatarColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BuildHeaderCards(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Tâches récentes',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ...tachesInfosMock.map((tache) => TachesCard(
                title: tache['title'],
                titleWeight: FontWeight.w700,
                titleSize: 18,
                text: tache['category'],
                textColor: Colors.blueGrey,
                date: tache['date'],
                status: tache['status'],
                initials: _getInitials(tache['firstName'], tache['lastName']),
                width: 150,
                height: 90,
                borderRadius: 20,
                avatarColor: Colors.grey)),
            const SizedBox(
              height: 12,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Stock',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          HomeScreenNavbar(currentIndex: _selectedIndex, onTap: (int index) {}),
      backgroundColor: AppTheme.backgroundColor,
    );
  }
}

class _BuildHeaderCards extends StatelessWidget {
  const _BuildHeaderCards();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FlexibleCard(
          title: 'Dépenses',
          width: 200,
          height: 125,
          text: '725.46',
          icon: Icons.euro,
          borderRadius: 10,
          iconPosition: IconPosition.left,
          titleColor: Colors.black,
          titleSize: 17,
          titleWeight: FontWeight.normal,
          cardColor: AppTheme.homeCardBackroundColor,
          iconColor: Colors.black,
          textSize: 30,
          textWeight: FontWeight.bold,
        ),
        SizedBox(
          width: 10,
        ),
        FlexibleCard(
          title: 'Mes tâches',
          width: 170,
          height: 125,
          text: '03',
          icon: null,
          borderRadius: 10,
          textSize: 40,
          padding: EdgeInsets.all(15),
          textWeight: FontWeight.bold,
          titleSize: 17,
          cardColor: AppTheme.homeCardBackroundColor,
          textColor: AppTheme.darkPrimaryColor,
        )
      ],
    );
  }
}
