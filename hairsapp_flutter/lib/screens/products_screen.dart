import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';
import 'home_screen.dart' show objIcon;
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  HairProfile? _profile;
  String _activeObjective = 'hydration';
  String? _activeStep;
  double _priceMin = 0;
  double _priceMax = 100;

  static const _stepOrder = ['Cleanse', 'Treat', 'Condition', 'Protect'];
  static const _stepLabels = {
    'Cleanse': 'Lavage',
    'Treat': 'Soin',
    'Condition': 'Après-shampoing',
    'Protect': 'Protection',
  };
  static const _tierPrice = {
    'budget': (5.0, 20.0),
    'mid': (20.0, 45.0),
    'premium': (45.0, 100.0),
  };

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

  List<SmartProductGroup> get _allGroups =>
      getSmartProductsForObjective(_profile?.hairType ?? 3, _activeObjective);

  List<SmartProductGroup> get _filteredGroups {
    var groups = _allGroups;
    if (_activeStep != null) {
      groups = groups.where((g) => g.catInfo.step == _activeStep).toList();
    }
    return groups.map((g) {
      final filtered =
          g.products.where((p) => _matchesPrice(p.priceTier)).toList();
      return SmartProductGroup(
          category: g.category, products: filtered, catInfo: g.catInfo);
    }).where((g) => g.products.isNotEmpty).toList();
  }

  bool _matchesPrice(String tier) {
    final range = _tierPrice[tier];
    if (range == null) return true;
    return range.$1 <= _priceMax && range.$2 >= _priceMin;
  }

  bool get _hasActiveFilters =>
      _activeStep != null || _priceMin > 0 || _priceMax < 100;

  String get _filterSummary {
    final parts = <String>[];
    final obj = _objectives.where((o) => o.id == _activeObjective).firstOrNull;
    if (obj != null) parts.add(obj.name);
    if (_activeStep != null) {
      parts.add(_stepLabels[_activeStep!] ?? _activeStep!);
    }
    if (_priceMin > 0 || _priceMax < 100) {
      parts.add('${_priceMin.round()}€ – ${_priceMax.round()}€');
    }
    return parts.join(' · ');
  }

  String _tierPriceLabel(String tier) {
    final range = _tierPrice[tier];
    if (range == null) return '';
    return '~${range.$1.round()}€ – ${range.$2.round()}€';
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ProductFilterSheet(
        objectives: _objectives,
        hairType: _profile?.hairType ?? 3,
        activeObjective: _activeObjective,
        activeStep: _activeStep,
        priceMin: _priceMin,
        priceMax: _priceMax,
        stepOrder: _stepOrder,
        stepLabels: _stepLabels,
        tierPrice: _tierPrice,
        onApply: (objective, step, min, max) {
          setState(() {
            _activeObjective = objective;
            _activeStep = step;
            _priceMin = min;
            _priceMax = max;
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
    final groups = _filteredGroups;

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
                    'Vos produits',
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
              child: groups.isEmpty
                  ? const _EmptyProducts()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      itemCount: groups.length,
                      itemBuilder: (context, i) => _ProductGroupSection(
                        group: groups[i],
                        tierPriceLabel: _tierPriceLabel,
                        profile: _profile,
                      ),
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
                  Text(
                    'Filtres',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: active
                          ? AppColors.foreground
                          : AppColors.foreground,
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

// ── Product filter sheet ───────────────────────────────────────────────────────

class _ProductFilterSheet extends StatefulWidget {
  final List<Objective> objectives;
  final int hairType;
  final String activeObjective;
  final String? activeStep;
  final double priceMin;
  final double priceMax;
  final List<String> stepOrder;
  final Map<String, String> stepLabels;
  final Map<String, (double, double)> tierPrice;
  final void Function(String objective, String? step, double min, double max)
      onApply;

  const _ProductFilterSheet({
    required this.objectives,
    required this.hairType,
    required this.activeObjective,
    required this.activeStep,
    required this.priceMin,
    required this.priceMax,
    required this.stepOrder,
    required this.stepLabels,
    required this.tierPrice,
    required this.onApply,
  });

  @override
  State<_ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<_ProductFilterSheet> {
  late String _objective;
  late String? _step;
  late double _priceMin;
  late double _priceMax;

  @override
  void initState() {
    super.initState();
    _objective = widget.activeObjective;
    _step = widget.activeStep;
    _priceMin = widget.priceMin;
    _priceMax = widget.priceMax;
  }

  List<String> get _availableSteps {
    final groups = getSmartProductsForObjective(widget.hairType, _objective);
    return groups
        .map((g) => g.catInfo.step)
        .toSet()
        .toList()
      ..sort((a, b) => widget.stepOrder
          .indexOf(a)
          .compareTo(widget.stepOrder.indexOf(b)));
  }

  bool get _hasChanges =>
      _step != null || _priceMin > 0 || _priceMax < 100;

  void _reset() => setState(() {
        _step = null;
        _priceMin = 0;
        _priceMax = 100;
      });

  @override
  Widget build(BuildContext context) {
    final steps = _availableSteps;
    final tierRange = widget.tierPrice;

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom),
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
            // Title
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
                    onTap: () => setState(() {
                      _objective = obj.id;
                      final newSteps = getSmartProductsForObjective(
                              widget.hairType, obj.id)
                          .map((g) => g.catInfo.step)
                          .toSet();
                      if (_step != null && !newSteps.contains(_step)) {
                        _step = null;
                      }
                    }),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ── Étape ──
            _SheetSection(
              label: 'Étape de routine',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SelectChip(
                    label: 'Toutes',
                    selected: _step == null,
                    onTap: () => setState(() => _step = null),
                  ),
                  ...steps.map((s) => _SelectChip(
                        label: widget.stepLabels[s] ?? s,
                        selected: _step == s,
                        onTap: () => setState(() => _step = s),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Prix ──
            _SheetSection(
              label:
                  'Prix — ${_priceMin.round()}€ à ${_priceMax.round()}€',
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.secondary,
                      thumbColor: AppColors.accent,
                      overlayColor:
                          AppColors.accent.withValues(alpha: 0.12),
                      rangeThumbShape:
                          const RoundRangeSliderThumbShape(
                              enabledThumbRadius: 8),
                    ),
                    child: RangeSlider(
                      values: RangeValues(_priceMin, _priceMax),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      onChanged: (v) => setState(() {
                        _priceMin = v.start;
                        _priceMax = v.end;
                      }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: tierRange.entries.map((e) {
                      final active =
                          e.value.$1 <= _priceMax && e.value.$2 >= _priceMin;
                      return _TierIndicator(
                        tier: e.key,
                        range: '${e.value.$1.round()}€–${e.value.$2.round()}€',
                        active: active,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Apply ──
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () =>
                    widget.onApply(_objective, _step, _priceMin, _priceMax),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Voir les produits',
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

// ── Product group section ──────────────────────────────────────────────────────

class _ProductGroupSection extends StatelessWidget {
  final SmartProductGroup group;
  final String Function(String tier) tierPriceLabel;
  final HairProfile? profile;

  const _ProductGroupSection({
    required this.group,
    required this.tierPriceLabel,
    required this.profile,
  });

  static const _stepLabels = {
    'Cleanse': 'Lavage',
    'Treat': 'Soin',
    'Condition': 'Après-shampoing',
    'Protect': 'Protection',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _stepLabels[group.catInfo.step] ?? group.catInfo.step,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                group.catInfo.name,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...group.products.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: p,
                      category: group.catInfo,
                    ),
                  ),
                ),
                child: _ProductCard(
                  product: p,
                  priceLabel: tierPriceLabel(p.priceTier),
                ),
              ),
            )),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ── Product card (1/4 image | 3/4 content) ────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final AmazonProduct product;
  final String priceLabel;

  const _ProductCard({required this.product, required this.priceLabel});

  Color get _tierColor {
    switch (product.priceTier) {
      case 'budget':
        return AppColors.emerald;
      case 'premium':
        return AppColors.amber;
      default:
        return AppColors.accent;
    }
  }

  String get _tierLabel {
    switch (product.priceTier) {
      case 'budget':
        return 'Budget';
      case 'premium':
        return 'Premium';
      default:
        return 'Milieu de gamme';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = product.amazonAffiliateUrl != '#' &&
        product.amazonAffiliateUrl.isNotEmpty;

    return Container(
      decoration: cardDecoration(radius: 14),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageWidth = constraints.maxWidth * 0.25;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Image (1/4) ──
                SizedBox(
                  width: imageWidth,
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
                // ── Content (3/4) ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand + price row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.brand,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  priceLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                Text(
                                  _tierLabel,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: _tierColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 13,
                                  height: 1.25,
                                  fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.notesShort,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(height: 1.35),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: product.keyActives.take(3).map((a) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondary
                                    .withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(a,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color:
                                          AppColors.secondaryForeground)),
                            );
                          }).toList(),
                        ),
                        if (hasUrl) ...[
                          const SizedBox(height: 10),
                          _AmazonButton(url: product.amazonAffiliateUrl),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Amazon button ──────────────────────────────────────────────────────────────

class _AmazonButton extends StatelessWidget {
  final String url;
  const _AmazonButton({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 12, color: Colors.white),
            SizedBox(width: 5),
            Text('Amazon',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            SizedBox(width: 3),
            Icon(Icons.open_in_new, size: 10, color: Colors.white70),
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

class _TierIndicator extends StatelessWidget {
  final String tier;
  final String range;
  final bool active;
  const _TierIndicator(
      {required this.tier, required this.range, required this.active});

  Color get _color {
    switch (tier) {
      case 'budget':
        return AppColors.emerald;
      case 'premium':
        return AppColors.amber;
      default:
        return AppColors.accent;
    }
  }

  String get _label {
    switch (tier) {
      case 'budget':
        return 'Budget';
      case 'premium':
        return 'Premium';
      default:
        return 'Milieu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? _color
                : AppColors.mutedForeground.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: active ? _color : AppColors.mutedForeground)),
            Text(range,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.mutedForeground)),
          ],
        ),
      ],
    );
  }
}

// ── Image placeholder ──────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary.withValues(alpha: 0.4),
      child: const Center(
        child: Icon(Icons.science_outlined,
            size: 32, color: AppColors.mutedForeground),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined,
                size: 48, color: AppColors.mutedForeground),
            const SizedBox(height: 12),
            Text('Aucun produit pour cette sélection.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text('Essayez d\'élargir la fourchette de prix.',
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
