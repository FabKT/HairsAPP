import 'package:flutter/material.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum _Phase { type, subtype, fundamentals, additional, loading }

class _OnboardingScreenState extends State<OnboardingScreen> {
  _Phase _phase = _Phase.type;
  int? _selectedType;
  String? _selectedSubtype;
  String? _additionalObj;

  HairType? get _selectedTypeData => _selectedType != null
      ? kHairTypes.firstWhere((t) => t.type == _selectedType)
      : null;

  int get _stepIndex => _phase.index.clamp(0, 3);
  double get _progress => ((_stepIndex + 1) / 4).clamp(0.0, 1.0);

  void _goBack() {
    setState(() {
      switch (_phase) {
        case _Phase.subtype:
          _phase = _Phase.type;
          _selectedSubtype = null;
        case _Phase.fundamentals:
          _phase = _Phase.subtype;
        case _Phase.additional:
          _phase = _Phase.fundamentals;
        default:
          break;
      }
    });
  }

  Future<void> _finishOnboarding() async {
    setState(() => _phase = _Phase.loading);
    await Future.delayed(const Duration(milliseconds: 2200));
    await Storage.saveProfile(HairProfile(
      hairType: _selectedType!,
      hairSubtype: _selectedSubtype!,
      additionalObjective: _additionalObj,
    ));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.loading) return _buildLoading();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: _phase != _Phase.type
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              )
            : null,
        title: _buildProgressBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_stepIndex + 1} / 4',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.mutedForeground)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: _buildCurrentPhase(),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: _progress,
        backgroundColor: AppColors.secondary,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        minHeight: 4,
      ),
    );
  }

  Widget _buildCurrentPhase() {
    switch (_phase) {
      case _Phase.type:
        return _buildTypeStep();
      case _Phase.subtype:
        return _buildSubtypeStep();
      case _Phase.fundamentals:
        return _buildFundamentalsStep();
      case _Phase.additional:
        return _buildAdditionalStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTypeStep() {
    const illustrations = ['〰️', '〜', '🌀', '🔗'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choisissez votre type de cheveux',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text('Selectionnez la forme la plus proche de la votre',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: kHairTypes.map((ht) {
              final isSelected = _selectedType == ht.type;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isSelected ? null : AppColors.card,
                      gradient:
                          isSelected ? AppColors.primarySoftGradient : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => setState(() {
                        _selectedType = ht.type;
                        _phase = _Phase.subtype;
                      }),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                  color: AppColors.secondary
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.center,
                              child: Text(illustrations[ht.type - 1],
                                  style: const TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type ${ht.type} – ${ht.label}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 2),
                                Text(ht.desc,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            )),
                            const Icon(Icons.chevron_right,
                                size: 18, color: AppColors.mutedForeground),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtypeStep() {
    final typeData = _selectedTypeData!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type ${typeData.type} – ${typeData.label}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text('Selectionnez votre sous-type',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: typeData.subtypes.map((st) {
              final isSelected = _selectedSubtype == st.letter;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isSelected ? null : AppColors.card,
                      gradient:
                          isSelected ? AppColors.primarySoftGradient : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selectedSubtype = st.letter),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isSelected
                                    ? null
                                    : AppColors.secondary
                                        .withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(st.letter,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.mutedForeground)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${typeData.type}${st.letter}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text(st.desc,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _selectedSubtype != null
              ? () => setState(() => _phase = _Phase.fundamentals)
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continuer'),
              SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 18)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFundamentalsStep() {
    const icons = [
      Icons.water_drop_outlined,
      Icons.build_outlined,
      Icons.spa_outlined,
      Icons.security_outlined
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vos objectifs fondamentaux',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text('Ils sont automatiquement actifs dans votre routine',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: List.generate(kFundamentalObjectives.length, (i) {
              final obj = kFundamentalObjectives[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primarySoftGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      GradientBox(
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.all(8),
                        child: Icon(icons[i], size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(obj.name,
                              style: Theme.of(context).textTheme.titleSmall),
                          Text(obj.descriptionShort,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      )),
                      Icon(Icons.auto_awesome,
                          size: 14,
                          color: AppColors.accent.withValues(alpha: 0.7)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => setState(() => _phase = _Phase.additional),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continuer'),
              SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 18)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personnalisez votre routine',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text('Ajoutez un objectif complementaire si besoin',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: kAdditionalObjectives.map((obj) {
              final isSelected = _additionalObj == obj.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isSelected ? null : AppColors.card,
                      gradient:
                          isSelected ? AppColors.primarySoftGradient : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => setState(
                          () => _additionalObj = isSelected ? null : obj.id),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isSelected
                                    ? null
                                    : AppColors.secondary
                                        .withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Icon(_iconForObjective(obj.icon),
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.accent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(obj.name,
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text(obj.descriptionShort,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            )),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  size: 18, color: AppColors.accent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _finishOnboarding,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Generer ma routine'),
              SizedBox(width: 6),
              Icon(Icons.auto_awesome, size: 16)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            ),
            const SizedBox(height: 28),
            Text(
              'Creation de votre routine\nhebdomadaire personnalisee...',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Adaptation des produits et des taches a votre type de cheveux et a vos objectifs.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForObjective(String? icon) {
    switch (icon) {
      case 'sprout':
        return Icons.eco_outlined;
      case 'layers':
        return Icons.layers_outlined;
      case 'waves':
        return Icons.waves_outlined;
      case 'shield':
        return Icons.security_outlined;
      case 'activity':
        return Icons.spa_outlined;
      default:
        return Icons.auto_awesome;
    }
  }
}
