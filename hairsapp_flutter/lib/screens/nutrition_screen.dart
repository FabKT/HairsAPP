import 'package:flutter/material.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';
import 'home_screen.dart' show objIcon;

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  HairProfile? _profile;
  String _activeObjective = 'hydration';
  String _activePriority = 'all'; // 'all' | 'core' | 'support'

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await Storage.loadProfile();
    if (mounted) setState(() => _profile = p);
  }

  List<Objective> get _objectives => kObjectives.where((o) {
        if (o.type == 'fundamental') return true;
        return o.type == 'additional' && _profile?.additionalObjective == o.id;
      }).toList();

  List<Nutrient> get _filteredNutrients {
    final all = getNutrientsForObjective(_activeObjective);
    if (_activePriority == 'all') return all;
    return all.where((n) => n.priority == _activePriority).toList();
  }

  bool get _hasActiveFilters => _activePriority != 'all';

  String get _filterSummary {
    final obj =
        _objectives.where((o) => o.id == _activeObjective).firstOrNull;
    final parts = <String>[if (obj != null) obj.name];
    if (_activePriority != 'all') {
      parts.add(_activePriority == 'core' ? 'Core' : 'Support');
    }
    return parts.join(' · ');
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _NutritionFilterSheet(
        objectives: _objectives,
        activeObjective: _activeObjective,
        activePriority: _activePriority,
        onApply: (objective, priority) {
          setState(() {
            _activeObjective = objective;
            _activePriority = priority;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileLabel = _profile == null
        ? 'Protocole personnalisé'
        : 'Protocole type ${_profile!.hairType}${_profile!.hairSubtype}';
    final nutrients = _filteredNutrients;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutrition',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                            fontSize: 30,
                            height: 1.05,
                            fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  _FilterButton(
                    active: _hasActiveFilters,
                    summary: _filterSummary,
                    onTap: _openFilterSheet,
                  ),
                ],
              ),
            ),
            // ── Scrollable list ──
            Expanded(
              child: nutrients.isEmpty
                  ? const _EmptyNutrition()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      itemCount: nutrients.length + 1,
                      itemBuilder: (context, i) {
                        if (i == nutrients.length) {
                          return const _DisclaimerCard();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _NutrientCard(nutrient: nutrients[i]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter button ──────────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  final bool active;
  final String summary;
  final VoidCallback onTap;
  const _FilterButton(
      {required this.active, required this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: active
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? AppColors.accent.withValues(alpha: 0.45)
                : AppColors.border.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.secondary.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 17,
                color:
                    active ? AppColors.accent : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: active
                          ? AppColors.accent
                          : AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: active ? AppColors.accent : AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nutrition filter sheet ─────────────────────────────────────────────────────

class _NutritionFilterSheet extends StatefulWidget {
  final List<Objective> objectives;
  final String activeObjective;
  final String activePriority;
  final void Function(String objective, String priority) onApply;

  const _NutritionFilterSheet({
    required this.objectives,
    required this.activeObjective,
    required this.activePriority,
    required this.onApply,
  });

  @override
  State<_NutritionFilterSheet> createState() =>
      _NutritionFilterSheetState();
}

class _NutritionFilterSheetState extends State<_NutritionFilterSheet> {
  late String _objective;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _objective = widget.activeObjective;
    _priority = widget.activePriority;
  }

  bool get _hasChanges => _priority != 'all';

  void _reset() => setState(() => _priority = 'all');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title + reset
            Row(
              children: [
                Text('Filtres',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                if (_hasChanges)
                  TextButton(
                    onPressed: _reset,
                    child: const Text('Réinitialiser',
                        style: TextStyle(
                            color: AppColors.accent, fontSize: 13)),
                  ),
              ],
            ),
            const SizedBox(height: 22),

            // ── Objectif ──
            _SheetSection(
              label: 'Objectif',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.objectives.map((obj) {
                  final sel = obj.id == _objective;
                  return _SelectChip(
                    label: obj.name,
                    icon: objIcon(obj.id),
                    selected: sel,
                    onTap: () => setState(() => _objective = obj.id),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ── Importance ──
            _SheetSection(
              label: 'Importance',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SelectChip(
                    label: 'Tous',
                    selected: _priority == 'all',
                    onTap: () => setState(() => _priority = 'all'),
                  ),
                  _SelectChip(
                    label: 'Essentiel',
                    icon: Icons.star_rounded,
                    selected: _priority == 'core',
                    onTap: () => setState(() => _priority = 'core'),
                  ),
                  _SelectChip(
                    label: 'Complémentaire',
                    icon: Icons.star_border_rounded,
                    selected: _priority == 'support',
                    onTap: () => setState(() => _priority = 'support'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Apply ──
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onApply(_objective, _priority),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Voir les nutriments',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nutrient card ──────────────────────────────────────────────────────────────

class _NutrientCard extends StatelessWidget {
  final Nutrient nutrient;
  const _NutrientCard({required this.nutrient});

  @override
  Widget build(BuildContext context) {
    final isCore = nutrient.priority == 'core';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutrient.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    _PriorityBadge(isCore: isCore),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  nutrient.dailyIntake,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            nutrient.notesShort,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: nutrient.foods.map((f) {
              final detail = getFoodDetail(nutrient.id, f);
              final isClickable = detail != null;
              return GestureDetector(
                onTap: isClickable
                    ? () => showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.background,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24)),
                          ),
                          builder: (_) => _FoodDetailSheet(
                            foodName: f,
                            nutrientName: nutrient.name,
                            detail: detail,
                          ),
                        )
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isClickable
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.secondary.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: isClickable
                        ? Border.all(
                            color: AppColors.primary
                                .withValues(alpha: 0.3))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.secondaryForeground)),
                      if (isClickable) ...[
                        const SizedBox(width: 3),
                        const Icon(Icons.chevron_right_rounded,
                            size: 11,
                            color: AppColors.mutedForeground),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final bool isCore;
  const _PriorityBadge({required this.isCore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        gradient: isCore ? AppColors.primaryGradient : null,
        color: isCore ? null : AppColors.secondary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCore ? 'Essentiel' : 'Complémentaire',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          color: isCore ? Colors.white : AppColors.mutedForeground,
        ),
      ),
    );
  }
}

// ── Disclaimer card ────────────────────────────────────────────────────────────

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline,
                size: 15, color: AppColors.mutedForeground),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Alimentation d\'abord : ces nutriments soutiennent la santé générale et la fonction normale des cheveux. Les compléments n\'aident que si l\'apport alimentaire ou les niveaux sanguins sont insuffisants. Ces informations sont éducatives et ne remplacent pas un avis médical.',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared sheet widgets ───────────────────────────────────────────────────────

class _SheetSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _SheetSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _SelectChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 13,
                  color: selected
                      ? AppColors.accent
                      : AppColors.mutedForeground),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected
                    ? AppColors.accent
                    : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyNutrition extends StatelessWidget {
  const _EmptyNutrition();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_food_outlined,
                size: 48, color: AppColors.mutedForeground),
            const SizedBox(height: 12),
            Text('Aucun nutriment pour cette sélection.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Food detail sheet ──────────────────────────────────────────────────────────

class _FoodDetailSheet extends StatelessWidget {
  final String foodName;
  final String nutrientName;
  final FoodDetail detail;

  const _FoodDetailSheet({
    required this.foodName,
    required this.nutrientName,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Titre
          Text(foodName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            'Teneur en $nutrientName',
            style: const TextStyle(fontSize: 12, color: AppColors.accent),
          ),
          const SizedBox(height: 20),
          if (detail.perLiter != null) ...[
            // Liquide : uniquement par litre
            _DetailRow(
              label: 'Par litre',
              value: detail.perLiter!,
              highlighted: true,
            ),
          ] else ...[
            // Solide : pour 100 g + par unité
            _DetailRow(
              label: 'Pour 100 g',
              value: detail.per100g,
              highlighted: false,
            ),
            if (detail.perUnitLabel != null &&
                detail.perUnitAmount != null) ...[
              const SizedBox(height: 10),
              _DetailRow(
                label: detail.perUnitLabel!,
                value: detail.perUnitAmount!,
                highlighted: true,
              ),
            ],
          ],
          // Note
          if (detail.note != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 14, color: AppColors.mutedForeground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      detail.note!,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: highlighted
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.2))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.mutedForeground),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlighted ? AppColors.accent : AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
