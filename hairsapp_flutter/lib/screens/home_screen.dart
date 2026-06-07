import 'package:flutter/material.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HairProfile? _profile;
  Set<String> _completed = {};
  String? _selectedObjectiveId;

  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String get _todayKey => _weekDays[DateTime.now().weekday - 1];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await Storage.loadProfile();
    final completed = await Storage.loadRoutineProgress();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _completed = completed;
      final objectives = _todayObjectivesFor(profile);
      _selectedObjectiveId = objectives.isNotEmpty ? objectives.first.id : null;
    });
  }

  List<Objective> _allObjectivesFor(HairProfile? profile) => [
        ...kFundamentalObjectives,
        if (profile?.additionalObjective != null)
          ...kAdditionalObjectives
              .where((o) => o.id == profile!.additionalObjective),
      ];

  List<RoutineStep> get _routine =>
      _profile != null ? getRoutineForProfile(_profile!) : [];

  Map<String, DayPlan> get _weekPlan =>
      _profile != null ? getWeekPlan(_profile!) : {};

  List<RoutineStep> _stepsForDay(String day) {
    final plan = _weekPlan[day];
    if (plan == null || plan.type == 'rest') return [];
    return _routine.where((step) {
      final actionMatch = plan.actions.any((action) {
        final a = action.toLowerCase();
        final s = step.action.toLowerCase();
        return s.contains(a) || a.contains(s);
      });
      final objectiveMatch = step.objectives.any((objective) => plan.objectives
          .any((planned) =>
              objective.toLowerCase().contains(planned.toLowerCase()) ||
              planned.toLowerCase().contains(objective.toLowerCase())));
      return actionMatch || objectiveMatch;
    }).toList();
  }

  List<String> _taskIdsForDay(String day) {
    final plan = _weekPlan[day];
    if (plan == null || plan.type == 'rest') return [];
    final ids = <String>[];
    final steps = _stepsForDay(day);

    for (final action in plan.actions) {
      final matches = steps.where((step) {
        final a = action.toLowerCase();
        final s = step.action.toLowerCase();
        return s.contains(a) || a.contains(s);
      }).toList();

      if (matches.isEmpty) {
        ids.add('$day-$action');
      } else {
        ids.addAll(matches.map((step) => '$day-${step.step}-${step.action}'));
      }
    }
    return ids.toSet().toList();
  }

  List<Objective> get _todayObjectives => _todayObjectivesFor(_profile);

  List<Objective> _todayObjectivesFor(HairProfile? profile) {
    final objectives = _allObjectivesFor(profile);
    if (profile == null) return objectives.take(2).toList();

    final plan = getWeekPlan(profile)[_todayKey];
    if (plan == null) return objectives.take(2).toList();

    final steps = _stepsForDay(_todayKey);
    final result = <Objective>[];
    for (final objective in objectives) {
      final needle = _objectiveNeedle(objective.id);
      final inPlan =
          plan.objectives.any((name) => name.toLowerCase().contains(needle)) ||
              steps.any((step) => step.objectives
                  .any((name) => name.toLowerCase().contains(needle)));
      if (inPlan) result.add(objective);
    }

    return result.isEmpty ? objectives.take(2).toList() : result;
  }

  int _doneForObjective(Objective objective) {
    final ids = _taskIdsForObjective(objective);
    if (ids.isEmpty) return 0;
    return ids.where(_completed.contains).length;
  }

  List<String> _taskIdsForObjective(Objective objective) {
    final needle = _objectiveNeedle(objective.id);
    final ids = <String>[];
    for (final step in _stepsForDay(_todayKey)) {
      final applies =
          step.objectives.any((name) => name.toLowerCase().contains(needle));
      if (applies) ids.add('$_todayKey-${step.step}-${step.action}');
    }
    return ids.toSet().toList();
  }

  int get _todayTotal => _taskIdsForDay(_todayKey).length;
  int get _todayDone =>
      _taskIdsForDay(_todayKey).where((id) => _completed.contains(id)).length;
  double get _todayProgress => _todayTotal == 0 ? 0 : _todayDone / _todayTotal;

  @override
  Widget build(BuildContext context) {
    final objectives = _todayObjectives;
    final selected = _selectedObjective(objectives);
    final profileLabel = _profile == null
        ? 'Protocole personnalisé'
        : 'Protocole type ${_profile!.hairType}${_profile!.hairSubtype}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _HomeHeader(profileLabel: profileLabel),
            ),
            const SizedBox(height: 18),
            _DailyProgressBar(
              done: _todayDone,
              total: _todayTotal,
              progress: _todayProgress,
            ),
            const SizedBox(height: 24),
            const _TodayTitle(),
            const SizedBox(height: 14),
            if (objectives.isEmpty)
              const AppCard(child: Text('No objective scheduled today.'))
            else
              _ObjectiveTabs(
                objectives: objectives,
                selectedId: selected?.id,
                doneFor: _doneForObjective,
                totalFor: (objective) => _taskIdsForObjective(objective).length,
                onSelected: (objective) =>
                    setState(() => _selectedObjectiveId = objective.id),
              ),
            if (selected != null) ...[
              const SizedBox(height: 16),
              _ObjectiveDetails(
                objective: selected,
                hairType: _profile?.hairType ?? 3,
                tasks: _stepsForDay(_todayKey)
                    .where((step) => step.objectives.any((name) => name
                        .toLowerCase()
                        .contains(_objectiveNeedle(selected.id))))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Objective? _selectedObjective(List<Objective> objectives) {
    if (objectives.isEmpty) return null;
    for (final objective in objectives) {
      if (objective.id == _selectedObjectiveId) return objective;
    }
    return objectives.first;
  }

  String _objectiveNeedle(String id) {
    if (id == 'scalp') return 'scalp';
    if (id == 'curl-definition') return 'curl';
    return id;
  }
}

class _HomeHeader extends StatelessWidget {
  final String profileLabel;
  const _HomeHeader({required this.profileLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Votre protocole',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 30,
                height: 1.05,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          profileLabel,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 13, height: 1.35),
        ),
      ],
    );
  }
}

class _DailyProgressBar extends StatelessWidget {
  final int done;
  final int total;
  final double progress;

  const _DailyProgressBar({
    required this.done,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (progress * 100).round();
    final remaining = total - done;

    return AppCard(
      glow: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aujourd\'hui',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    total == 0
                        ? 'Journée de faible manipulation'
                        : remaining == 0
                            ? 'Tous les objectifs sont validés'
                            : '$remaining tâche${remaining > 1 ? 's' : ''} restante${remaining > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.secondary,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0 ? 'Aucune tâche active' : '$done / $total tâches faites',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _TodayTitle extends StatelessWidget {
  const _TodayTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Objectifs du jour',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Sélectionnez un objectif pour voir les tâches, produits et apports utiles.',
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ObjectiveTabs extends StatelessWidget {
  final List<Objective> objectives;
  final String? selectedId;
  final int Function(Objective objective) doneFor;
  final int Function(Objective objective) totalFor;
  final ValueChanged<Objective> onSelected;

  const _ObjectiveTabs({
    required this.objectives,
    required this.selectedId,
    required this.doneFor,
    required this.totalFor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final columns = objectives.length == 1 ? 1 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: objectives.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: columns == 1 ? 1.85 : 1,
      ),
      itemBuilder: (context, index) {
        final objective = objectives[index];
        return _ObjectiveTile(
          objective: objective,
          selected: objective.id == selectedId,
          expanded: columns == 1,
          done: doneFor(objective),
          total: totalFor(objective),
          onTap: () => onSelected(objective),
        );
      },
    );
  }
}

class _ObjectiveTile extends StatelessWidget {
  final Objective objective;
  final bool selected;
  final bool expanded;
  final int done;
  final int total;
  final VoidCallback onTap;

  const _ObjectiveTile({
    required this.objective,
    required this.selected,
    required this.expanded,
    required this.done,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    final percent = total == 0 ? 0 : (progress * 100).round();
    final iconSize = expanded ? 34.0 : 25.0;
    final titleSize = expanded ? 22.0 : 16.0;
    final subtitleSize = expanded ? 12.0 : 10.0;
    final progressHeight = expanded ? 7.0 : 5.0;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primarySoftGradient : null,
          color: selected ? null : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.55)
                : AppColors.border.withValues(alpha: 0.55),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(expanded ? 18 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(objIcon(objective.id),
                        size: iconSize,
                        color:
                            selected ? AppColors.accent : AppColors.foreground),
                    const Spacer(),
                    Text(
                      total == 0 ? 'Repos' : '$done/$total',
                      style: TextStyle(
                        color: total > 0 && done == total
                            ? AppColors.emerald
                            : AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  objective.name,
                  maxLines: expanded ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: titleSize,
                        height: 1.12,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: expanded ? 10 : 7),
                Text(
                  objective.descriptionShort,
                  maxLines: expanded ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(height: 1.3, fontSize: subtitleSize),
                ),
                SizedBox(height: expanded ? 16 : 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: progressHeight,
                    backgroundColor: AppColors.secondary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      total > 0 && done == total
                          ? AppColors.emerald
                          : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  total == 0 ? 'Aucune tâche active' : '$percent% complété',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ObjectiveDetails extends StatelessWidget {
  final Objective objective;
  final int hairType;
  final List<RoutineStep> tasks;

  const _ObjectiveDetails({
    required this.objective,
    required this.hairType,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final products = getSmartProductsForObjective(hairType, objective.id);
    final nutrients = getNutrientsForObjective(objective.id);

    return Column(
      children: [
        _DetailSection(
          title: 'Tâches à accomplir',
          icon: Icons.checklist_outlined,
          child: tasks.isEmpty
              ? const _EmptyDetail(
                  text:
                      'Cet objectif est suivi aujourd\'hui sans tâche dédiée. Gardez une manipulation douce et respectez le protocole global.',
                )
              : Column(
                  children: tasks
                      .map((step) => _RoutineFocusRow(step: step))
                      .toList(),
                ),
        ),
        const SizedBox(height: 14),
        _DetailSection(
          title: 'Utilité',
          icon: Icons.info_outline,
          child: Text(
            _objectiveUtility(objective.id),
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
          ),
        ),
        const SizedBox(height: 14),
        _DetailSection(
          title: 'Produit phare',
          icon: Icons.shopping_bag_outlined,
          child: _FeaturedProduct(products: products),
        ),
        const SizedBox(height: 14),
        _DetailSection(
          title: 'Nutriments + aliments',
          icon: Icons.restaurant_outlined,
          child: nutrients.isEmpty
              ? const _EmptyDetail(
                  text: 'Aucune recommandation nutritionnelle.')
              : Column(
                  children: nutrients
                      .take(5)
                      .map((nutrient) => _NutrientFoodRow(nutrient: nutrient))
                      .toList(),
                ),
        ),
      ],
    );
  }

  String _objectiveUtility(String id) {
    switch (id) {
      case 'hydration':
        return 'L\'hydratation aide la fibre à rester souple, brillante et plus facile à démêler. L’objectif est d’éviter la sécheresse sans alourdir les racines.';
      case 'repair':
        return 'La réparation vise surtout à réduire la casse. Elle améliore la résistance et le toucher, même si une fibre très abîmée ne peut pas toujours être réparée totalement.';
      case 'scalp':
        return 'L’équilibre du cuir chevelu limite l’accumulation, les démangeaisons et l’excès de sébum. Un cuir chevelu confortable rend la routine plus régulière.';
      case 'protection':
        return 'La protection limite les dommages évitables liés à la chaleur, aux UV, aux frottements et aux pointes sèches. C’est essentiel pour conserver la longueur visible.';
      case 'growth':
        return 'Le soutien de la pousse consiste à protéger le cuir chevelu et à surveiller une chute persistante. Il soutient les conditions normales de pousse sans remplacer un avis médical.';
      case 'density':
        return 'La densité cherche à donner une impression de cheveux plus fournis en réduisant la casse et en ajoutant du corps sans surcharge.';
      case 'curl-definition':
        return 'La définition aide les ondulations, boucles et coils à mieux se regrouper avec hydratation, tenue et manipulation douce.';
      case 'volume':
        return 'Le volume apporte du lift aux racines et de la légèreté aux longueurs, surtout quand les cheveux fins retombent vite.';
      case 'frizz-control':
        return 'Le contrôle des frisottis améliore le lissage de la cuticule et réduit la réaction à l’humidité par conditionnement et protection.';
      case 'scalp-soothing':
        return 'L’apaisement vise le confort du cuir chevelu. Des plaques, douleurs, croûtes ou une chute soudaine méritent un avis dermatologique.';
      default:
        return objective.descriptionShort;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.accent),
              const SizedBox(width: 9),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _RoutineFocusRow extends StatelessWidget {
  final RoutineStep step;
  const _RoutineFocusRow({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientBox(
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: Text('${step.step}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.action,
                    style: Theme.of(context).textTheme.titleSmall),
                Text(step.product,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.accent)),
                Text(step.duration,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProduct extends StatelessWidget {
  final List<SmartProductGroup> products;
  const _FeaturedProduct({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyDetail(text: 'Aucun produit phare pour cet objectif.');
    }

    final group = products.first;
    final product = group.products.isNotEmpty ? group.products.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product?.title ?? group.catInfo.name,
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(
          product?.notesShort ?? group.catInfo.genericCategory,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(height: 1.35),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: group.catInfo.keyTopicalActives.take(4).map((active) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(active,
                  style:
                      const TextStyle(fontSize: 10, color: AppColors.accent)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _NutrientFoodRow extends StatelessWidget {
  final Nutrient nutrient;
  const _NutrientFoodRow({required this.nutrient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: nutrient.priority == 'core'
                      ? AppColors.accent
                      : AppColors.mutedForeground,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(nutrient.name,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(nutrient.dailyIntake,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 5),
          Text(nutrient.notesShort,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(height: 1.35)),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: nutrient.foods.take(5).map((food) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(food,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.foreground)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  final String text;
  const _EmptyDetail({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35));
  }
}

IconData objIcon(String id) {
  switch (id) {
    case 'hydration':
      return Icons.water_drop_outlined;
    case 'repair':
      return Icons.build_outlined;
    case 'scalp':
      return Icons.spa_outlined;
    case 'protection':
      return Icons.security_outlined;
    case 'growth':
      return Icons.eco_outlined;
    case 'density':
      return Icons.layers_outlined;
    case 'curl-definition':
      return Icons.waves_outlined;
    case 'volume':
      return Icons.air_outlined;
    case 'frizz-control':
      return Icons.air_outlined;
    case 'scalp-soothing':
      return Icons.favorite_border;
    default:
      return Icons.auto_awesome;
  }
}

String objLabel(String id) => kObjectives
    .firstWhere((o) => o.id == id,
        orElse: () =>
            Objective(id: '', name: id, type: '', descriptionShort: ''))
    .name;
