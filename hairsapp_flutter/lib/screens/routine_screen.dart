import 'package:flutter/material.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';
import 'home_screen.dart' show objIcon;

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  HairProfile? _profile;
  Set<String> _completed = {};
  String _selectedDay = _weekDays[DateTime.now().weekday - 1];
  String? _selectedObjectiveId;

  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _dayNames = {
    'Mon': 'Lundi',
    'Tue': 'Mardi',
    'Wed': 'Mercredi',
    'Thu': 'Jeudi',
    'Fri': 'Vendredi',
    'Sat': 'Samedi',
    'Sun': 'Dimanche',
  };

  String get _todayKey => _weekDays[DateTime.now().weekday - 1];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await Storage.loadProfile();
    final progress = await Storage.loadRoutineProgress();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _completed = progress;
      final objs = _objectivesForDay(_selectedDay);
      _selectedObjectiveId = objs.isNotEmpty ? objs.first.id : null;
    });
  }

  // ── Data helpers ─────────────────────────────────────────────────────────────

  List<Objective> _allObjectives() => [
        ...kFundamentalObjectives,
        if (_profile?.additionalObjective != null)
          ...kAdditionalObjectives
              .where((o) => o.id == _profile!.additionalObjective),
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
      final objectiveMatch = step.objectives.any((obj) => plan.objectives.any(
          (p) =>
              obj.toLowerCase().contains(p.toLowerCase()) ||
              p.toLowerCase().contains(obj.toLowerCase())));
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

  List<Objective> _objectivesForDay(String day) {
    final objectives = _allObjectives();
    if (_profile == null) return objectives.take(2).toList();
    final plan = _weekPlan[day];
    if (plan == null || plan.type == 'rest') return [];
    final steps = _stepsForDay(day);
    final result = <Objective>[];
    for (final obj in objectives) {
      final needle = _needle(obj.id);
      final inPlan =
          plan.objectives.any((name) => name.toLowerCase().contains(needle)) ||
              steps.any((step) => step.objectives
                  .any((name) => name.toLowerCase().contains(needle)));
      if (inPlan) result.add(obj);
    }
    return result.isEmpty ? objectives.take(2).toList() : result;
  }

  List<String> _taskIdsForObjectiveOnDay(Objective obj, String day) {
    final needle = _needle(obj.id);
    final ids = <String>[];
    for (final step in _stepsForDay(day)) {
      if (step.objectives.any((name) => name.toLowerCase().contains(needle))) {
        ids.add('$day-${step.step}-${step.action}');
      }
    }
    return ids.toSet().toList();
  }

  List<RoutineStep> _stepsForObjectiveOnDay(Objective obj, String day) {
    final needle = _needle(obj.id);
    return _stepsForDay(day)
        .where((step) =>
            step.objectives.any((name) => name.toLowerCase().contains(needle)))
        .toList();
  }

  int _doneForObjectiveOnDay(Objective obj, String day) =>
      _taskIdsForObjectiveOnDay(obj, day).where(_completed.contains).length;

  int get _totalTasks =>
      _weekDays.fold(0, (sum, day) => sum + _taskIdsForDay(day).length);

  int get _doneTasks {
    final allIds = _weekDays.expand(_taskIdsForDay).toSet();
    return _completed.where(allIds.contains).length.clamp(0, _totalTasks);
  }

  double get _weekProgress => _totalTasks == 0 ? 0 : _doneTasks / _totalTasks;

  String _needle(String id) {
    if (id == 'scalp') return 'scalp';
    if (id == 'curl-definition') return 'curl';
    return id;
  }

  Future<void> _toggleTask(String id, bool value) async {
    setState(() {
      if (value) {
        _completed.add(id);
      } else {
        _completed.remove(id);
      }
    });
    await Storage.saveRoutineProgress(_completed);
  }

  Future<void> _resetWeek() async {
    setState(() => _completed = {});
    await Storage.clearRoutineProgress();
  }

  void _showCalendarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoutineCalendarSheet(
        selectedDay: _selectedDay,
        completedIds: _completed,
        weekPlan: _weekPlan,
        taskIdsForDay: _taskIdsForDay,
        onDaySelected: (dayKey) {
          setState(() {
            _selectedDay = dayKey;
            _selectedObjectiveId = null;
          });
        },
      ),
    );
  }

  Objective? _selectedObjective(List<Objective> objectives) {
    if (objectives.isEmpty) return null;
    for (final obj in objectives) {
      if (obj.id == _selectedObjectiveId) return obj;
    }
    return objectives.first;
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profileLabel = _profile == null
        ? 'Protocole personnalisé'
        : 'Protocole type ${_profile!.hairType}${_profile!.hairSubtype}';

    final plan = _weekPlan[_selectedDay];
    final isRestDay = plan == null || plan.type == 'rest';
    final dayObjectives = _objectivesForDay(_selectedDay);
    final selected = _selectedObjective(dayObjectives);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _RoutineHeader(
                profileLabel: profileLabel,
                onReset: _completed.isEmpty ? null : _resetWeek,
                onCalendar: () => _showCalendarSheet(context),
              ),
            ),
            const SizedBox(height: 18),
            _WeekProgressBar(
              done: _doneTasks,
              total: _totalTasks,
              progress: _weekProgress,
            ),
            const SizedBox(height: 16),
            _buildCalendarStrip(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _DayTitle(
                dayName: _dayNames[_selectedDay] ?? _selectedDay,
                planLabel: plan?.label,
                isToday: _selectedDay == _todayKey,
              ),
            ),
            const SizedBox(height: 14),
            if (isRestDay)
              const AppCard(
                child: Text(
                  'Journée de repos. Minimisez la manipulation et protégez vos pointes.',
                ),
              )
            else if (dayObjectives.isEmpty)
              const AppCard(child: Text('Aucun objectif pour ce jour.'))
            else
              _ObjectiveTabs(
                objectives: dayObjectives,
                selectedId: selected?.id,
                doneFor: (obj) => _doneForObjectiveOnDay(obj, _selectedDay),
                totalFor: (obj) =>
                    _taskIdsForObjectiveOnDay(obj, _selectedDay).length,
                onSelected: (obj) =>
                    setState(() => _selectedObjectiveId = obj.id),
              ),
            if (selected != null && !isRestDay) ...[
              const SizedBox(height: 16),
              _RoutineObjectiveDetails(
                objective: selected,
                hairType: _profile?.hairType ?? 3,
                tasks: _stepsForObjectiveOnDay(selected, _selectedDay),
                day: _selectedDay,
                completed: _completed,
                onToggle: (id, value) => _toggleTask(id, value),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarStrip(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDays.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final plan = _weekPlan[day];
          final ids = _taskIdsForDay(day);
          final done = ids.where(_completed.contains).length;
          final selected = day == _selectedDay;
          final today = day == _todayKey;
          final complete = ids.isNotEmpty && done == ids.length;

          return SizedBox(
            width: 92,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.primarySoftGradient : null,
                  color: selected ? null : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : today
                            ? AppColors.accent.withValues(alpha: 0.35)
                            : AppColors.border.withValues(alpha: 0.4),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() {
                    _selectedDay = day;
                    _selectedObjectiveId = null;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: today
                                    ? AppColors.accent
                                    : AppColors.foreground,
                              ),
                            ),
                            Icon(
                              complete
                                  ? Icons.check_circle
                                  : today
                                      ? Icons.today
                                      : Icons.circle_outlined,
                              size: 15,
                              color: complete
                                  ? AppColors.emerald
                                  : today
                                      ? AppColors.accent
                                      : AppColors.mutedForeground,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plan?.label ?? 'Repos',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          ids.isEmpty ? 'Repos' : '$done/${ids.length}',
                          style: TextStyle(
                            fontSize: 11,
                            color: complete
                                ? AppColors.emerald
                                : AppColors.mutedForeground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _RoutineHeader extends StatelessWidget {
  final String profileLabel;
  final VoidCallback? onReset;
  final VoidCallback onCalendar;

  const _RoutineHeader({
    required this.profileLabel,
    this.onReset,
    required this.onCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre routine',
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
          ),
        ),
        IconButton(
          onPressed: onCalendar,
          icon: const Icon(Icons.calendar_month_outlined, size: 20),
          color: AppColors.mutedForeground,
          tooltip: 'Calendrier',
        ),
        if (onReset != null)
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt, size: 20),
            color: AppColors.mutedForeground,
            tooltip: 'Réinitialiser la semaine',
          ),
      ],
    );
  }
}

// ── Weekly progress bar ───────────────────────────────────────────────────────

class _WeekProgressBar extends StatelessWidget {
  final int done;
  final int total;
  final double progress;

  const _WeekProgressBar({
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
                  Text('Cette semaine',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    total == 0
                        ? 'Aucune tâche planifiée'
                        : remaining == 0
                            ? 'Toutes les tâches sont validées'
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
            total == 0
                ? 'Aucune tâche active'
                : '$done / $total tâches faites cette semaine',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

// ── Day title ─────────────────────────────────────────────────────────────────

class _DayTitle extends StatelessWidget {
  final String dayName;
  final String? planLabel;
  final bool isToday;

  const _DayTitle({
    required this.dayName,
    this.planLabel,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Objectifs — $dayName',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 22,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            if (isToday)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        if (planLabel != null) ...[
          const SizedBox(height: 5),
          Text(
            planLabel!,
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(height: 1.35),
          ),
        ],
      ],
    );
  }
}

// ── Objective tabs ────────────────────────────────────────────────────────────

class _ObjectiveTabs extends StatelessWidget {
  final List<Objective> objectives;
  final String? selectedId;
  final int Function(Objective) doneFor;
  final int Function(Objective) totalFor;
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
                    Icon(
                      objIcon(objective.id),
                      size: iconSize,
                      color: selected ? AppColors.accent : AppColors.foreground,
                    ),
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

// ── Objective details ─────────────────────────────────────────────────────────

class _RoutineObjectiveDetails extends StatelessWidget {
  final Objective objective;
  final int hairType;
  final List<RoutineStep> tasks;
  final String day;
  final Set<String> completed;
  final void Function(String id, bool value) onToggle;

  const _RoutineObjectiveDetails({
    required this.objective,
    required this.hairType,
    required this.tasks,
    required this.day,
    required this.completed,
    required this.onToggle,
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
                      'Cet objectif est suivi ce jour sans tâche dédiée. Gardez une manipulation douce.',
                )
              : Column(
                  children: tasks.map((step) {
                    final id = '$day-${step.step}-${step.action}';
                    return _CheckableTaskRow(
                      step: step,
                      id: id,
                      checked: completed.contains(id),
                      onToggle: onToggle,
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 14),
        _DetailSection(
          title: 'Utilité',
          icon: Icons.info_outline,
          child: Text(
            _objectiveUtility(objective.id, objective.descriptionShort),
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
                      .map((n) => _NutrientFoodRow(nutrient: n))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

String _objectiveUtility(String id, String fallback) {
  switch (id) {
    case 'hydration':
      return 'L\'hydratation aide la fibre à rester souple, brillante et plus facile à démêler. L\'objectif est d\'éviter la sécheresse sans alourdir les racines.';
    case 'repair':
      return 'La réparation vise surtout à réduire la casse. Elle améliore la résistance et le toucher, même si une fibre très abîmée ne peut pas toujours être réparée totalement.';
    case 'scalp':
      return 'L\'équilibre du cuir chevelu limite l\'accumulation, les démangeaisons et l\'excès de sébum. Un cuir chevelu confortable rend la routine plus régulière.';
    case 'protection':
      return 'La protection limite les dommages évitables liés à la chaleur, aux UV, aux frottements et aux pointes sèches. C\'est essentiel pour conserver la longueur visible.';
    case 'growth':
      return 'Le soutien de la pousse consiste à protéger le cuir chevelu et à surveiller une chute persistante. Il soutient les conditions normales de pousse sans remplacer un avis médical.';
    case 'density':
      return 'La densité cherche à donner une impression de cheveux plus fournis en réduisant la casse et en ajoutant du corps sans surcharge.';
    case 'curl-definition':
      return 'La définition aide les ondulations, boucles et coils à mieux se regrouper avec hydratation, tenue et manipulation douce.';
    case 'volume':
      return 'Le volume apporte du lift aux racines et de la légèreté aux longueurs, surtout quand les cheveux fins retombent vite.';
    case 'frizz-control':
      return 'Le contrôle des frisottis améliore le lissage de la cuticule et réduit la réaction à l\'humidité par conditionnement et protection.';
    case 'scalp-soothing':
      return 'L\'apaisement vise le confort du cuir chevelu. Des plaques, douleurs, croûtes ou une chute soudaine méritent un avis dermatologique.';
    default:
      return fallback;
  }
}

// ── Shared section card ───────────────────────────────────────────────────────

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

// ── Checkable task row ────────────────────────────────────────────────────────

class _CheckableTaskRow extends StatelessWidget {
  final RoutineStep step;
  final String id;
  final bool checked;
  final void Function(String id, bool value) onToggle;

  const _CheckableTaskRow({
    required this.step,
    required this.id,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.secondary.withValues(alpha: checked ? 0.28 : 0.18),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onToggle(id, !checked),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: checked,
                    onChanged: (v) => onToggle(id, v ?? false),
                    visualDensity: VisualDensity.compact,
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.action,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              decoration: checked
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppColors.mutedForeground,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.accent),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        step.duration,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
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

// ── Featured product ──────────────────────────────────────────────────────────

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
          style:
              Theme.of(context).textTheme.labelSmall?.copyWith(height: 1.35),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: group.catInfo.keyTopicalActives.take(4).map((active) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(active,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.accent)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Nutrient row ──────────────────────────────────────────────────────────────

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
              Text(
                nutrient.dailyIntake,
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600),
              ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyDetail extends StatelessWidget {
  final String text;
  const _EmptyDetail({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style:
            Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.35));
  }
}

// ── Calendar sheet ────────────────────────────────────────────────────────────

class _RoutineCalendarSheet extends StatefulWidget {
  final String selectedDay;
  final Set<String> completedIds;
  final Map<String, DayPlan> weekPlan;
  final List<String> Function(String) taskIdsForDay;
  final ValueChanged<String> onDaySelected;

  const _RoutineCalendarSheet({
    required this.selectedDay,
    required this.completedIds,
    required this.weekPlan,
    required this.taskIdsForDay,
    required this.onDaySelected,
  });

  @override
  State<_RoutineCalendarSheet> createState() => _RoutineCalendarSheetState();
}

class _RoutineCalendarSheetState extends State<_RoutineCalendarSheet> {
  late DateTime _month;

  static const _dayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _dayHeaders = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  static const _monthNames = [
    'Janvier', 'Fevrier', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Decembre',
  ];

  @override
  void initState() {
    super.initState();
    _month = DateTime(DateTime.now().year, DateTime.now().month);
  }

  String _dayKeyFor(DateTime date) => _dayKeys[date.weekday - 1];

  bool _isCurrentWeek(DateTime date) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final mondayStart = DateTime(monday.year, monday.month, monday.day);
    final sundayEnd = mondayStart.add(const Duration(days: 6));
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(mondayStart) && !d.isAfter(sundayEnd);
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leadingBlanks = DateTime(_month.year, _month.month, 1).weekday - 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(
                        () => _month = DateTime(_month.year, _month.month - 1)),
                    icon: const Icon(Icons.chevron_left),
                    color: AppColors.foreground,
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Text(
                      '${_monthNames[_month.month - 1]} ${_month.year}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(
                        () => _month = DateTime(_month.year, _month.month + 1)),
                    icon: const Icon(Icons.chevron_right),
                    color: AppColors.foreground,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: _dayHeaders
                    .map((h) => Expanded(
                          child: Center(
                            child: Text(
                              h,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 6),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.1,
                ),
                itemCount: leadingBlanks + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < leadingBlanks) return const SizedBox();
                  final day = index - leadingBlanks + 1;
                  final date = DateTime(_month.year, _month.month, day);
                  final dayKey = _dayKeyFor(date);
                  final inCurrentWeek = _isCurrentWeek(date);
                  final now = DateTime.now();
                  final isToday = date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;
                  final isSelected = inCurrentWeek && dayKey == widget.selectedDay;

                  bool isComplete = false;
                  bool hasActivity = false;
                  if (inCurrentWeek) {
                    final ids = widget.taskIdsForDay(dayKey);
                    hasActivity = ids.isNotEmpty;
                    isComplete =
                        ids.isNotEmpty && ids.every(widget.completedIds.contains);
                  }

                  final plan = widget.weekPlan[dayKey];
                  final isRest = plan == null || plan.type == 'rest';

                  return GestureDetector(
                    onTap: () {
                      widget.onDaySelected(dayKey);
                      Navigator.pop(context);
                    },
                    child: _CalendarDayCell(
                      day: day,
                      isToday: isToday,
                      isSelected: isSelected,
                      isCurrentWeek: inCurrentWeek,
                      isComplete: isComplete,
                      hasActivity: hasActivity,
                      isRest: isRest,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: AppColors.emerald, label: 'Complet'),
                  SizedBox(width: 16),
                  _LegendDot(color: AppColors.accent, label: "Aujourd'hui"),
                  SizedBox(width: 16),
                  _LegendDot(color: AppColors.primary, label: 'Selectionne'),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isCurrentWeek;
  final bool isComplete;
  final bool hasActivity;
  final bool isRest;

  const _CalendarDayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isCurrentWeek,
    required this.isComplete,
    required this.hasActivity,
    required this.isRest,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor = AppColors.foreground;

    if (isSelected) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isComplete) {
      bgColor = AppColors.emerald.withValues(alpha: 0.2);
      textColor = AppColors.emerald;
    } else if (isToday) {
      bgColor = AppColors.accent.withValues(alpha: 0.15);
      textColor = AppColors.accent;
    } else if (isCurrentWeek && !isRest) {
      bgColor = AppColors.secondary.withValues(alpha: 0.45);
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isToday && !isSelected
            ? Border.all(color: AppColors.accent, width: 1.5)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  isToday || isSelected ? FontWeight.w700 : FontWeight.normal,
              color: textColor,
            ),
          ),
          if (isCurrentWeek && hasActivity && !isComplete && !isSelected)
            Positioned(
              bottom: 3,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}
