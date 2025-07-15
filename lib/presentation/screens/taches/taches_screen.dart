import 'package:co_habit_frontend/config/theme/app_theme.dart';
import 'package:co_habit_frontend/core/controllers/floating_navbar_controller.dart';
import 'package:co_habit_frontend/core/di/injection.dart';
import 'package:co_habit_frontend/data/models/models.dart';
import 'package:co_habit_frontend/domain/entities/entities.dart';
import 'package:co_habit_frontend/domain/usecases/taches/create_tache_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_all_taches_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_last_created_taches_uc.dart';
import 'package:co_habit_frontend/domain/usecases/taches/get_tache_by_id_uc.dart';
import 'package:co_habit_frontend/presentation/providers/auth_provider.dart';
import 'package:co_habit_frontend/presentation/providers/foyer_provider.dart';
import 'package:co_habit_frontend/presentation/providers/taches_provider.dart';
import 'package:co_habit_frontend/presentation/screens/depenses/widgets/add_category_modal.dart';
import 'package:co_habit_frontend/presentation/screens/taches/controller/taches_controller.dart';
import 'package:co_habit_frontend/presentation/screens/taches/utils/tache_status_enum.dart';
import 'package:co_habit_frontend/presentation/screens/taches/widgets/taches_card.dart';
import 'package:co_habit_frontend/presentation/widgets/common/custom_action_sheet.dart';
import 'package:co_habit_frontend/presentation/widgets/common/screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TachesScreen extends StatefulWidget {
  const TachesScreen({super.key});

  @override
  State<TachesScreen> createState() => _TachesScreenState();
}

class _TachesScreenState extends State<TachesScreen> {
  late TachesController _tachesController;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /*final*/var colocId = context.read<FoyerProvider>().colocId;
      /*final*/var user = context.read<AuthProvider>().user;
// Retrait temporaire des final car tant que je ne peux pas test avec
      //le vrai back j'assigne des valeurs en dur
      if(colocId==null || user==null) {
        // ASSIGNEMENT DES VALEURS EN DUR
        colocId = 42;
        user = UtilisateurModel(
            id: 100,
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            dateDeNaissance: DateTime(1970, 01, 01),
            keyCloakSub: "keycloak",
            phoneNumber: "phoneNumber",
            username: "username",
            fullName: "fullName",
            gender: "gender",
            createdAt: DateTime(2025,05,05),
            updatedAt: DateTime(2025,05,05)
        );

        // ÇA DOIT ÊTRE CE CODE EN VRAI
        // setState(() {
        //   _controllerInitialized = true;
        // });
        // return;
      };

      _tachesController = TachesController(
          creerTacheUC: getIt<CreerTacheUc>(),
          getAllTachesUC: getIt<GetAllTachesUc>(),
          getLastCreatedTachesUc: getIt<GetLastCreatedTachesUc>(),
          getTacheByIdUC: getIt<GetTacheByIdUc>(),
          tachesProvider: context.read<TachesProvider>(),
          colocationId: colocId
      );

      await _tachesController.loadTaches();

      if(mounted) {
        setState(() {
          _controllerInitialized = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<FloatingNavbarController>().setActionForRoute(
      '/taches',
      () {
        showCustomActionSheet(
            context: context,
            title: 'Ajouter une nouvelle tâche',
            subTitle: 'Tu peux ajouter une tâche ou une catégorie',
            actions: [
              ListTile(
                title: const Text('Ajouter une tâche',style: TextStyle(color:Colors.blue)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/creerTache');
                }
              ),
              ListTile(
                title: const Text('Ajouter une nouvelle catégorie',style:TextStyle(color:Colors.blue)),
                onTap:(){
                  Navigator.pop(context);
                  showDialog(
                    context:context,builder:(_) => const AddCategoryModal()
                  );
                }
              )
            ]
        )  ;
      }
    );
  }

  String _getMonthName(int month) {
    const months = [
      "JANVIER",
      "FÉVRIER",
      "MARS",
      "AVRIL",
      "MAI",
      "JUIN",
      "JUILLET",
      "AOÛT",
      "SEPTEMBRE",
      "OCTOBRE",
      "NOVEMBRE",
      "DÉCEMBRE"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // marche pas
    // if(!_controllerInitialized){
    //   return const Scaffold(
    //     body:Center(child: CircularProgressIndicator()),
    //   );
    // }

    final provider = context.watch<TachesProvider>();
    print('BUILD : nombre de taches dans provider.taches = ${provider.taches.length}');
    // final user = context.read<AuthProvider>().user;
    // final colocId = context.read<FoyerProvider>().colocId;

    // COMMENTÉ EN ATTENDANT QUE CE QUI SE TROUVE SUR LES LIGNES
    // 41 À 65 SOIT OPÉRATIONNEL
    // if(user == null || colocId == null) {
    //   return const Scaffold(
    //     body: Center(child: Text("Impossible de charger les tâches"))
    //   );
    // }

    if (provider.taches.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );

      // marche pas
      // // Force rebuild sans rien faire, pour forcer le provider à renvoyer les données
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   setState(() {});
      // });
    }

    // return Scaffold(
    //   backgroundColor: AppTheme.backgroundColor,
    //   appBar: const ScreenAppBar(title: 'Tâches'),
    //   body: SafeArea(
    //     child:SingleChildScrollView(
    //       padding:const EdgeInsets.all(16),
    //       child:Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children:[
    //           _buildMesTachesCard(provider.taches)
    //         ]
    //       )
    //     )
    //   )
    // );
    // le code commenté ne marche pas ci-dessus
    return Scaffold(
      appBar: const ScreenAppBar(title: 'Tâches'),
      body: ListView(
        children: provider.taches.map((tache) {
          return ListTile(
            title: Text(tache.title),
            subtitle: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: tache.status.color,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text('Status : ${tache.status.label}'),
              ),
            ),
          );
        }).toList(),
      )
    );
  }

  Widget _buildMesTachesCard(List<TacheModel> taches) {
    if(taches.isEmpty) {
      return const Center(child: Text('Aucune tâche pour le moment.'));
    }
    return Column(
      children: taches.map((tache) {
        // TODO revoir le modèle tache qui ne correspond pas trop à ce qu'on a en back
        return TachesCard(
            title: tache.title,
            text: tache.firstName,
            date: tache.date,
            status: tache.status,
            initials: tache.lastName,
            width: 12,
            height: 12,
            borderRadius: 5,
            avatarColor: Colors.red
        );
      }).toList()
    );
  }
}
