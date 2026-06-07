// ═══════════════════════════════════════════════
// 1) HAIR PROFILE
// ═══════════════════════════════════════════════

class HairProfile {
  final int hairType;
  final String hairSubtype;
  final String? additionalObjective;

  const HairProfile({
    required this.hairType,
    required this.hairSubtype,
    this.additionalObjective,
  });

  Map<String, dynamic> toJson() => {
        'hairType': hairType,
        'hairSubtype': hairSubtype,
        'additionalObjective': additionalObjective,
      };

  factory HairProfile.fromJson(Map<String, dynamic> json) => HairProfile(
        hairType: json['hairType'] as int,
        hairSubtype: json['hairSubtype'] as String,
        additionalObjective: json['additionalObjective'] as String?,
      );

  HairProfile copyWith({
    int? hairType,
    String? hairSubtype,
    String? additionalObjective,
    bool clearAdditional = false,
  }) =>
      HairProfile(
        hairType: hairType ?? this.hairType,
        hairSubtype: hairSubtype ?? this.hairSubtype,
        additionalObjective: clearAdditional
            ? null
            : (additionalObjective ?? this.additionalObjective),
      );
}

// ═══════════════════════════════════════════════
// 2) OBJECTIVES
// ═══════════════════════════════════════════════

class Objective {
  final String id;
  final String name;
  final String type; // "fundamental" | "additional"
  final String descriptionShort;
  final String? icon;

  const Objective({
    required this.id,
    required this.name,
    required this.type,
    required this.descriptionShort,
    this.icon,
  });
}

const kObjectives = [
  Objective(
      id: 'hydration',
      name: 'Hydratation',
      type: 'fundamental',
      descriptionShort: 'Garder la fibre souple sans l’alourdir'),
  Objective(
      id: 'repair',
      name: 'Réparation',
      type: 'fundamental',
      descriptionShort: 'Réduire la casse avec des soins ciblés'),
  Objective(
      id: 'scalp',
      name: 'Équilibre du cuir chevelu',
      type: 'fundamental',
      descriptionShort: 'Nettoyer les dépôts tout en préservant le confort'),
  Objective(
      id: 'protection',
      name: 'Protection',
      type: 'fundamental',
      descriptionShort: 'Limiter UV, chaleur, frottements et tensions'),
  Objective(
      id: 'growth',
      name: 'Pousse & chute',
      type: 'additional',
      descriptionShort: 'Soutenir le cuir chevelu et surveiller la chute',
      icon: 'sprout'),
  Objective(
      id: 'density',
      name: 'Densité & épaisseur',
      type: 'additional',
      descriptionShort: 'Donner du corps et limiter la casse',
      icon: 'layers'),
  Objective(
      id: 'curl-definition',
      name: 'Définition des boucles',
      type: 'additional',
      descriptionShort: 'Mieux former les boucles avec hydratation et tenue',
      icon: 'waves'),
  Objective(
      id: 'volume',
      name: 'Volume',
      type: 'additional',
      descriptionShort: 'Apporter du lift sans alourdir',
      icon: 'layers'),
  Objective(
      id: 'frizz-control',
      name: 'Anti-frisottis',
      type: 'additional',
      descriptionShort: 'Lisser et protéger contre l’humidité',
      icon: 'shield'),
  Objective(
      id: 'scalp-soothing',
      name: 'Apaisement du cuir chevelu',
      type: 'additional',
      descriptionShort: 'Calmer les irritations et sensibilités',
      icon: 'activity'),
];

List<Objective> get kFundamentalObjectives =>
    kObjectives.where((o) => o.type == 'fundamental').toList();

List<Objective> get kAdditionalObjectives =>
    kObjectives.where((o) => o.type == 'additional').toList();

// ═══════════════════════════════════════════════
// 3) NUTRIENTS
// ═══════════════════════════════════════════════

class Nutrient {
  final String id;
  final String name;
  final String notesShort;
  final String dailyIntake;
  final List<String> foods;
  String priority; // "core" | "support" — set by mapping

  Nutrient({
    required this.id,
    required this.name,
    required this.notesShort,
    required this.dailyIntake,
    required this.foods,
    this.priority = 'support',
  });
}

final kNutrients = [
  Nutrient(
      id: 'electrolytes',
      name: 'Electrolytes (Na/K/Mg)',
      notesShort:
          'Soutiennent l hydratation globale; priorite a une alimentation variee plutot qu aux complements capillaires.',
      dailyIntake: 'Selon alimentation et activite',
      foods: ['Eau de coco', 'Bananes', 'Avocat', 'Epinards']),
  Nutrient(
      id: 'omega3',
      name: 'Acides gras omega-3',
      notesShort:
          'Soutiennent la barriere cutanee; l effet sur la pousse reste limite si l alimentation est deja correcte.',
      dailyIntake: '250-500 mg EPA+DHA',
      foods: ['Saumon', 'Sardines', 'Noix', 'Graines de chia', 'Lin moulu']),
  Nutrient(
      id: 'vitA',
      name: 'Vitamine A',
      notesShort:
          'Utile au fonctionnement normal de la peau, mais les fortes doses en complement peuvent favoriser la chute.',
      dailyIntake: '700-900 mcg RAE',
      foods: ['Patates douces', 'Carottes', 'Chou kale', 'Oeufs']),
  Nutrient(
      id: 'vitE',
      name: 'Vitamine E',
      notesShort:
          'Antioxydant a privilegier via l alimentation sauf avis medical contraire.',
      dailyIntake: '15 mg',
      foods: ['Amandes', 'Graines de tournesol', 'Avocat', 'Epinards']),
  Nutrient(
      id: 'zinc',
      name: 'Zinc',
      notesShort:
          'Soutient la reparation des tissus; l exces peut perturber l equilibre du cuivre.',
      dailyIntake: '8-11 mg',
      foods: ['Huitres', 'Graines de courge', 'Pois chiches', 'Boeuf']),
  Nutrient(
      id: 'protein',
      name: 'Proteines',
      notesShort:
          'Apportent les acides amines necessaires a la fibre; un apport faible peut aggraver chute et casse.',
      dailyIntake: '46-56 g au total',
      foods: ['Oeufs', 'Yaourt grec', 'Poulet', 'Lentilles', 'Quinoa']),
  Nutrient(
      id: 'cysteine',
      name: 'Cysteine & methionine',
      notesShort:
          'Acides amines soufres apportes par un apport proteique suffisant.',
      dailyIntake: 'Inclus dans les proteines',
      foods: ['Oeufs', 'Volaille', 'Flocons d avoine', 'Graines de tournesol']),
  Nutrient(
      id: 'biotin',
      name: 'Biotine (B7)',
      notesShort:
          'Une carence peut affecter les cheveux, mais elle reste rare; eviter les fortes doses sans avis medical.',
      dailyIntake: '30 mcg AI',
      foods: ['Oeufs', 'Patates douces', 'Amandes', 'Avoine']),
  Nutrient(
      id: 'iron',
      name: 'Fer',
      notesShort:
          'Un taux bas peut contribuer a la chute; completer seulement si une carence est confirmee ou probable.',
      dailyIntake: '8-18 mg adulte',
      foods: ['Viande rouge', 'Epinards', 'Lentilles', 'Cereales enrichies']),
  Nutrient(
      id: 'vitC',
      name: 'Vitamine C',
      notesShort:
          'Soutient la formation du collagene et ameliore l absorption du fer vegetal.',
      dailyIntake: '75-90 mg',
      foods: ['Agrumes', 'Poivrons', 'Fraises', 'Brocoli']),
  Nutrient(
      id: 'copper',
      name: 'Cuivre',
      notesShort:
          'Oligo-element utile aux tissus et aux pigments; eviter les fortes doses inutiles.',
      dailyIntake: '900 mcg',
      foods: [
        'Noix de cajou',
        'Chocolat noir',
        'Lentilles',
        'Champignons shiitake'
      ]),
  Nutrient(
      id: 'vitD',
      name: 'Vitamine D',
      notesShort:
          'Importante pour la sante generale; un dosage sanguin aide a guider la supplementation.',
      dailyIntake: '600-800 UI adulte',
      foods: [
        'Poissons gras',
        'Jaunes d oeufs',
        'Champignons exposes aux UV',
        'Lait enrichi'
      ]),
  Nutrient(
      id: 'bComplex',
      name: 'Vitamines B',
      notesShort:
          'Soutiennent le metabolisme normal; en ajouter ne garantit pas une pousse plus rapide.',
      dailyIntake: 'Selon la vitamine B',
      foods: [
        'Cereales completes',
        'Viande',
        'Oeufs',
        'Legumineuses',
        'Feuilles vertes'
      ]),
  Nutrient(
      id: 'selenium',
      name: 'Selenium',
      notesShort:
          'Oligo-element antioxydant; un exces en complement peut fragiliser cheveux et ongles.',
      dailyIntake: '55 mcg',
      foods: ['Noix du Bresil', 'Thon', 'Sardines', 'Riz complet']),
  Nutrient(
      id: 'carotenoids',
      name: 'Carotenoides (pro-vitamine A)',
      notesShort:
          'Pigments vegetaux antioxydants; option alimentaire plus sure pour soutenir la vitamine A.',
      dailyIntake: 'Pas d AJR; alimentation d abord',
      foods: ['Carottes', 'Tomates', 'Patates douces', 'Papaye']),
  Nutrient(
      id: 'water',
      name: 'Hydratation',
      notesShort:
          'Soutient l hydratation generale; le toucher du cheveu depend surtout des soins et des agressions limitees.',
      dailyIntake: 'Boire selon la soif',
      foods: ['Eau', 'Concombre', 'Pasteque', 'Celeri']),
];

// ═══════════════════════════════════════════════
// 4) OBJECTIVE ↔ NUTRIENT MAPPING
// ═══════════════════════════════════════════════

class _ObjectiveNutrient {
  final String objectiveId;
  final String nutrientId;
  final String priority;
  const _ObjectiveNutrient(this.objectiveId, this.nutrientId, this.priority);
}

const _objectiveNutrients = [
  _ObjectiveNutrient('hydration', 'electrolytes', 'core'),
  _ObjectiveNutrient('hydration', 'omega3', 'core'),
  _ObjectiveNutrient('hydration', 'vitA', 'support'),
  _ObjectiveNutrient('hydration', 'vitE', 'support'),
  _ObjectiveNutrient('hydration', 'zinc', 'support'),
  _ObjectiveNutrient('hydration', 'water', 'core'),
  _ObjectiveNutrient('repair', 'protein', 'core'),
  _ObjectiveNutrient('repair', 'cysteine', 'core'),
  _ObjectiveNutrient('repair', 'biotin', 'support'),
  _ObjectiveNutrient('repair', 'zinc', 'support'),
  _ObjectiveNutrient('repair', 'iron', 'support'),
  _ObjectiveNutrient('repair', 'vitC', 'support'),
  _ObjectiveNutrient('repair', 'copper', 'support'),
  _ObjectiveNutrient('scalp', 'zinc', 'core'),
  _ObjectiveNutrient('scalp', 'vitD', 'support'),
  _ObjectiveNutrient('scalp', 'omega3', 'support'),
  _ObjectiveNutrient('scalp', 'bComplex', 'support'),
  _ObjectiveNutrient('scalp', 'selenium', 'support'),
  _ObjectiveNutrient('protection', 'vitC', 'core'),
  _ObjectiveNutrient('protection', 'vitE', 'core'),
  _ObjectiveNutrient('protection', 'carotenoids', 'core'),
  _ObjectiveNutrient('protection', 'omega3', 'support'),
  _ObjectiveNutrient('protection', 'zinc', 'support'),
  _ObjectiveNutrient('protection', 'selenium', 'support'),
  _ObjectiveNutrient('growth', 'protein', 'core'),
  _ObjectiveNutrient('growth', 'iron', 'core'),
  _ObjectiveNutrient('growth', 'zinc', 'core'),
  _ObjectiveNutrient('growth', 'vitD', 'support'),
  _ObjectiveNutrient('growth', 'omega3', 'support'),
  _ObjectiveNutrient('growth', 'bComplex', 'support'),
  _ObjectiveNutrient('density', 'protein', 'core'),
  _ObjectiveNutrient('density', 'iron', 'core'),
  _ObjectiveNutrient('density', 'zinc', 'support'),
  _ObjectiveNutrient('density', 'vitD', 'support'),
  _ObjectiveNutrient('density', 'omega3', 'support'),
  _ObjectiveNutrient('curl-definition', 'protein', 'core'),
  _ObjectiveNutrient('curl-definition', 'omega3', 'core'),
  _ObjectiveNutrient('curl-definition', 'zinc', 'support'),
];

List<Nutrient> getNutrientsForObjective(String objectiveId) {
  final mappings =
      _objectiveNutrients.where((m) => m.objectiveId == objectiveId).toList();
  final result = <Nutrient>[];
  for (final m in mappings) {
    final nutrient = kNutrients.firstWhere(
      (n) => n.id == m.nutrientId,
      orElse: () => Nutrient(
          id: '', name: '', notesShort: '', dailyIntake: '', foods: []),
    );
    if (nutrient.id.isNotEmpty) {
      final copy = Nutrient(
        id: nutrient.id,
        name: nutrient.name,
        notesShort: nutrient.notesShort,
        dailyIntake: nutrient.dailyIntake,
        foods: nutrient.foods,
        priority: m.priority,
      );
      result.add(copy);
    }
  }
  result.sort((a, b) {
    if (a.priority == b.priority) return a.name.compareTo(b.name);
    return a.priority == 'core' ? -1 : 1;
  });
  return result;
}

// ═══════════════════════════════════════════════
// 4b) DETAILS NUTRITIONNELS PAR ALIMENT
// ═══════════════════════════════════════════════

class FoodDetail {
  final String per100g;
  final String? perUnitLabel;
  final String? perUnitAmount;
  final String? perLiter; // si défini, affiche uniquement cette valeur (liquides)
  final String? note;

  const FoodDetail({
    this.per100g = '',
    this.perUnitLabel,
    this.perUnitAmount,
    this.perLiter,
    this.note,
  });
}

// Clé : `nutrientId::nomAliment` (nom en minuscules)
final kFoodDetails = <String, FoodDetail>{
  // ── ÉLECTROLYTES (potassium comme marqueur principal) ──
  'electrolytes::eau de coco': const FoodDetail(perLiter: '2 500 mg K', note: 'Riche en sodium, potassium et magnésium naturels'),
  'electrolytes::bananes':     const FoodDetail(per100g: '358 mg K', perUnitLabel: '1 banane (≈120 g)', perUnitAmount: '430 mg K'),
  'electrolytes::avocat':      const FoodDetail(per100g: '485 mg K', perUnitLabel: '½ avocat (≈75 g)', perUnitAmount: '364 mg K', note: 'Contient aussi 29 mg de magnésium/100g'),
  'electrolytes::epinards':    const FoodDetail(per100g: '558 mg K', perUnitLabel: '1 tasse crue (≈30 g)', perUnitAmount: '167 mg K', note: 'Contient aussi 79 mg de magnésium/100g'),
  // ── OMÉGA-3 ──
  'omega3::saumon':            const FoodDetail(per100g: '2 150 mg EPA+DHA', perUnitLabel: '1 filet (≈150 g)', perUnitAmount: '3 225 mg EPA+DHA'),
  'omega3::sardines':          const FoodDetail(per100g: '1 480 mg EPA+DHA', perUnitLabel: '1 boîte (≈90 g)', perUnitAmount: '1 332 mg EPA+DHA'),
  'omega3::noix':              const FoodDetail(per100g: '9 080 mg ALA', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '2 724 mg ALA', note: "ALA (oméga-3 végétal), moins biodisponible que l'EPA+DHA marin"),
  'omega3::graines de chia':   const FoodDetail(per100g: '17 830 mg ALA', perUnitLabel: '1 c. à soupe (≈12 g)', perUnitAmount: '2 140 mg ALA', note: "ALA végétal – compléter avec des sources marines pour l'EPA+DHA"),
  'omega3::lin moulu':         const FoodDetail(per100g: '22 800 mg ALA', perUnitLabel: '1 c. à soupe (≈7 g)', perUnitAmount: '1 596 mg ALA', note: 'Moudre avant consommation pour une meilleure absorption'),
  // ── VITAMINE A ──
  'vitA::patates douces':      const FoodDetail(per100g: '961 mcg RAE', perUnitLabel: '1 patate douce moy. (≈130 g)', perUnitAmount: '1 249 mcg RAE', note: "Couvre environ 140% de l'apport journalier recommandé"),
  'vitA::carottes':            const FoodDetail(per100g: '835 mcg RAE', perUnitLabel: '1 carotte moy. (≈61 g)', perUnitAmount: '509 mcg RAE'),
  'vitA::chou kale':           const FoodDetail(per100g: '241 mcg RAE', perUnitLabel: '1 tasse (≈67 g)', perUnitAmount: '162 mcg RAE'),
  'vitA::oeufs':               const FoodDetail(per100g: '160 mcg RAE', perUnitLabel: '1 œuf entier (≈50 g)', perUnitAmount: '80 mcg RAE'),
  // ── VITAMINE E ──
  'vitE::amandes':             const FoodDetail(per100g: '25.6 mg', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '7.7 mg', note: "Couvre ~51% de l'apport journalier recommandé par poignée"),
  'vitE::graines de tournesol':const FoodDetail(per100g: '35.2 mg', perUnitLabel: '1 c. à soupe (≈9 g)', perUnitAmount: '3.2 mg'),
  'vitE::avocat':              const FoodDetail(per100g: '2.1 mg', perUnitLabel: '½ avocat (≈75 g)', perUnitAmount: '1.6 mg'),
  'vitE::epinards':            const FoodDetail(per100g: '2.0 mg', perUnitLabel: '1 tasse crue (≈30 g)', perUnitAmount: '0.6 mg'),
  // ── ZINC ──
  'zinc::huitres':             const FoodDetail(per100g: '78.6 mg', perUnitLabel: '1 huître (≈15 g)', perUnitAmount: '11.8 mg', note: "Source de zinc la plus concentrée connue – 1 huître couvre l'AJR"),
  'zinc::graines de courge':   const FoodDetail(per100g: '7.8 mg', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '2.3 mg'),
  'zinc::pois chiches':        const FoodDetail(per100g: '1.5 mg', perUnitLabel: '1 tasse cuite (≈164 g)', perUnitAmount: '2.5 mg'),
  'zinc::boeuf':               const FoodDetail(per100g: '6.3 mg', perUnitLabel: '100 g (portion)', perUnitAmount: '6.3 mg'),
  // ── PROTÉINES ──
  'protein::oeufs':            const FoodDetail(per100g: '13 g', perUnitLabel: '1 œuf entier (≈50 g)', perUnitAmount: '6.5 g'),
  'protein::yaourt grec':      const FoodDetail(per100g: '10 g', perUnitLabel: '1 pot (≈200 g)', perUnitAmount: '20 g'),
  'protein::poulet':           const FoodDetail(per100g: '31 g', perUnitLabel: '1 blanc de poulet (≈150 g)', perUnitAmount: '46 g'),
  'protein::lentilles':        const FoodDetail(per100g: '9 g', perUnitLabel: '1 tasse cuite (≈200 g)', perUnitAmount: '18 g'),
  'protein::quinoa':           const FoodDetail(per100g: '4.4 g', perUnitLabel: '1 tasse cuite (≈185 g)', perUnitAmount: '8.1 g'),
  // ── CYSTÉINE & MÉTHIONINE ──
  'cysteine::oeufs':              const FoodDetail(per100g: '592 mg', perUnitLabel: '1 œuf entier (≈50 g)', perUnitAmount: '296 mg', note: 'Contient les deux acides aminés soufrés essentiels à la kératine'),
  'cysteine::volaille':           const FoodDetail(per100g: '960 mg', perUnitLabel: '100 g de volaille (blanc)', perUnitAmount: '960 mg'),
  'cysteine::flocons d avoine':   const FoodDetail(per100g: '400 mg', perUnitLabel: '1 tasse cuite (≈234 g)', perUnitAmount: '936 mg'),
  'cysteine::graines de tournesol': const FoodDetail(per100g: '870 mg', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '261 mg'),
  // ── BIOTINE ──
  'biotin::oeufs':             const FoodDetail(per100g: '20 mcg', perUnitLabel: '1 œuf entier (≈50 g)', perUnitAmount: '10 mcg', note: "Le blanc cru bloque l'absorption via l'avidine – toujours cuire les œufs"),
  'biotin::patates douces':    const FoodDetail(per100g: '2.4 mcg', perUnitLabel: '1 patate douce moy. (≈130 g)', perUnitAmount: '3.1 mcg'),
  'biotin::amandes':           const FoodDetail(per100g: '4.4 mcg', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '1.3 mcg'),
  'biotin::avoine':            const FoodDetail(per100g: '0.24 mcg', perUnitLabel: '1 tasse cuite (≈234 g)', perUnitAmount: '0.6 mcg'),
  // ── FER ──
  'iron::viande rouge':        const FoodDetail(per100g: '2.7 mg', perUnitLabel: '100 g (bœuf)', perUnitAmount: '2.7 mg', note: 'Fer héminique : absorption ~25%, bien supérieure au fer végétal'),
  'iron::epinards':            const FoodDetail(per100g: '2.7 mg', perUnitLabel: '1 tasse cuite (≈180 g)', perUnitAmount: '4.9 mg', note: 'Fer non héminique : absorption ~5% – associer à la vitamine C pour optimiser'),
  'iron::lentilles':           const FoodDetail(per100g: '3.3 mg', perUnitLabel: '1 tasse cuite (≈200 g)', perUnitAmount: '6.6 mg', note: 'Bonne source végétale – associer à la vitamine C pour meilleure absorption'),
  'iron::cereales enrichies':  const FoodDetail(per100g: '8–18 mg', perUnitLabel: '1 portion (≈30 g)', perUnitAmount: '3–6 mg', note: "Varie selon la marque et le niveau d'enrichissement"),
  // ── VITAMINE C ──
  'vitC::agrumes':             const FoodDetail(per100g: '53 mg', perUnitLabel: '1 orange (≈130 g)', perUnitAmount: '69 mg'),
  'vitC::poivrons':            const FoodDetail(per100g: '128 mg', perUnitLabel: '1 poivron rouge (≈150 g)', perUnitAmount: '192 mg', note: 'Le poivron rouge contient 3× plus de vitamine C qu\'une orange'),
  'vitC::fraises':             const FoodDetail(per100g: '59 mg', perUnitLabel: '1 tasse (≈150 g)', perUnitAmount: '88 mg'),
  'vitC::brocoli':             const FoodDetail(per100g: '89 mg', perUnitLabel: '1 tasse cuite (≈91 g)', perUnitAmount: '81 mg'),
  // ── CUIVRE ──
  'copper::noix de cajou':     const FoodDetail(per100g: '2.2 mg', perUnitLabel: '1 poignée (≈30 g)', perUnitAmount: '0.66 mg'),
  'copper::chocolat noir':     const FoodDetail(per100g: '1.8 mg', perUnitLabel: '1 carré (≈10 g)', perUnitAmount: '0.18 mg'),
  'copper::lentilles':         const FoodDetail(per100g: '0.25 mg', perUnitLabel: '1 tasse cuite (≈200 g)', perUnitAmount: '0.5 mg'),
  'copper::champignons shiitake': const FoodDetail(per100g: '0.89 mg', perUnitLabel: '1 tasse cuite (≈145 g)', perUnitAmount: '1.3 mg'),
  // ── VITAMINE D ──
  'vitD::poissons gras':       const FoodDetail(per100g: '526 UI', perUnitLabel: '1 filet de saumon (≈150 g)', perUnitAmount: '789 UI'),
  'vitD::jaunes d oeufs':      const FoodDetail(per100g: '218 UI', perUnitLabel: "1 jaune d'œuf (≈17 g)", perUnitAmount: '37 UI'),
  'vitD::champignons exposes aux uv': const FoodDetail(per100g: '~400 UI', perUnitLabel: '1 tasse (≈70 g)', perUnitAmount: '~280 UI', note: 'Seulement si exposés aux rayons UV (soleil ou lampe UV spéciale)'),
  'vitD::lait enrichi':        const FoodDetail(perLiter: '420 UI'),
  // ── VITAMINES B ──
  'bComplex::cereales completes': const FoodDetail(per100g: '4.5 mg niacine (B3)', perUnitLabel: '1 tranche pain complet (≈30 g)', perUnitAmount: '1.4 mg B3'),
  'bComplex::viande':          const FoodDetail(per100g: '6.8 mg niacine (B3)', perUnitLabel: '100 g de bœuf', perUnitAmount: '6.8 mg B3'),
  'bComplex::oeufs':           const FoodDetail(per100g: '0.07 mg B12', perUnitLabel: '1 œuf entier (≈50 g)', perUnitAmount: '0.04 mg B12', note: 'Contient aussi B2, B5 (biotine) et folates'),
  'bComplex::legumineuses':    const FoodDetail(per100g: '0.36 mg folates (B9)', perUnitLabel: '1 tasse lentilles (≈200 g)', perUnitAmount: '0.72 mg B9'),
  'bComplex::feuilles vertes': const FoodDetail(per100g: '0.19 mg folates (B9)', perUnitLabel: '1 tasse épinards (≈30 g)', perUnitAmount: '0.06 mg B9'),
  // ── SÉLÉNIUM ──
  'selenium::noix du bresil':  const FoodDetail(per100g: '1 917 mcg', perUnitLabel: '1 noix du Brésil (≈5 g)', perUnitAmount: '96 mcg', note: '1 à 2 noix/jour suffisent à couvrir l\'AJR – au-delà risque de toxicité'),
  'selenium::thon':            const FoodDetail(per100g: '90 mcg', perUnitLabel: '100 g de thon', perUnitAmount: '90 mcg'),
  'selenium::sardines':        const FoodDetail(per100g: '52 mcg', perUnitLabel: '1 boîte (≈90 g)', perUnitAmount: '47 mcg'),
  'selenium::riz complet':     const FoodDetail(per100g: '14 mcg', perUnitLabel: '1 tasse cuite (≈195 g)', perUnitAmount: '27 mcg'),
  // ── CAROTÉNOÏDES (β-carotène) ──
  'carotenoids::carottes':     const FoodDetail(per100g: '8.3 mg β-carotène', perUnitLabel: '1 carotte moy. (≈61 g)', perUnitAmount: '5.1 mg β-carotène'),
  'carotenoids::tomates':      const FoodDetail(per100g: '0.45 mg β-carotène', perUnitLabel: '1 tomate moy. (≈123 g)', perUnitAmount: '0.55 mg β-carotène'),
  'carotenoids::patates douces': const FoodDetail(per100g: '8.5 mg β-carotène', perUnitLabel: '1 patate douce moy. (≈130 g)', perUnitAmount: '11 mg β-carotène'),
  'carotenoids::papaye':       const FoodDetail(per100g: '0.27 mg β-carotène', perUnitLabel: '1 tranche (≈145 g)', perUnitAmount: '0.39 mg β-carotène'),
  // ── HYDRATATION ──
  'water::eau':                const FoodDetail(perLiter: '1 000 ml', note: 'Objectif : 2 à 3 litres par jour toutes sources confondues'),
  'water::concombre':          const FoodDetail(per100g: '96.7 ml eau', perUnitLabel: '1 concombre moy. (≈300 g)', perUnitAmount: '290 ml eau'),
  'water::pasteque':           const FoodDetail(per100g: '91.4 ml eau', perUnitLabel: '1 tranche (≈280 g)', perUnitAmount: '256 ml eau'),
  'water::celeri':             const FoodDetail(per100g: '95.4 ml eau', perUnitLabel: '1 tige (≈40 g)', perUnitAmount: '38 ml eau'),
};

FoodDetail? getFoodDetail(String nutrientId, String foodName) {
  return kFoodDetails['$nutrientId::${foodName.toLowerCase()}'];
}

// ═══════════════════════════════════════════════
// 5) PRODUCT CATEGORIES
// ═══════════════════════════════════════════════

class ProductCategory {
  final String code;
  final String step; // "Cleanse" | "Treat" | "Condition" | "Protect"
  final int hairTypeGroup;
  final String name;
  final String genericCategory;
  final String weight; // "light" | "medium" | "heavy"
  final List<String> keyTopicalActives;
  final List<String> objectiveTags;
  final bool multiObjective;

  const ProductCategory({
    required this.code,
    required this.step,
    required this.hairTypeGroup,
    required this.name,
    required this.genericCategory,
    required this.weight,
    required this.keyTopicalActives,
    required this.objectiveTags,
    this.multiObjective = false,
  });
}

const kProductCategories = [
  // TYPE 1
  ProductCategory(
      code: 'A',
      step: 'Cleanse',
      hairTypeGroup: 1,
      name: 'Hydrating Light Shampoo',
      genericCategory: 'Shampoo',
      weight: 'light',
      keyTopicalActives: ['Moringa Oil', 'Quinoa Protein'],
      objectiveTags: ['hydration']),
  ProductCategory(
      code: 'B',
      step: 'Condition',
      hairTypeGroup: 1,
      name: 'Lightweight Conditioner',
      genericCategory: 'Conditioner',
      weight: 'light',
      keyTopicalActives: ['Keratin', 'Baobab Oil'],
      objectiveTags: ['hydration']),
  ProductCategory(
      code: 'C',
      step: 'Treat',
      hairTypeGroup: 1,
      name: 'Light Bond Repair Treatment',
      genericCategory: 'Treatment',
      weight: 'light',
      keyTopicalActives: [
        'Bis-Aminopropyl Diglycol Dimaleate',
        'Light Proteins'
      ],
      objectiveTags: [
        'repair'
      ]),
  ProductCategory(
      code: 'D',
      step: 'Cleanse',
      hairTypeGroup: 1,
      name: 'Scalp Balance Light Shampoo',
      genericCategory: 'Shampoo',
      weight: 'light',
      keyTopicalActives: ['Piroctone Olamine', 'Niacinamide'],
      objectiveTags: ['scalp']),
  ProductCategory(
      code: 'E',
      step: 'Protect',
      hairTypeGroup: 1,
      name: 'Heat & UV Light Protector',
      genericCategory: 'Heat Protectant',
      weight: 'light',
      keyTopicalActives: ['Dimethicone', 'UV Filters', 'Vitamin E'],
      objectiveTags: ['protection']),
  ProductCategory(
      code: 'U',
      step: 'Treat',
      hairTypeGroup: 1,
      name: 'Root Volumizing Spray/Mousse',
      genericCategory: 'Styling',
      weight: 'light',
      keyTopicalActives: ['Biotin', 'Polymers', 'Rice Protein'],
      objectiveTags: ['density']),
  ProductCategory(
      code: 'V1',
      step: 'Treat',
      hairTypeGroup: 1,
      name: 'Root Volumizing Spray',
      genericCategory: 'Styling',
      weight: 'light',
      keyTopicalActives: ['Biotin', 'Polymers', 'Rice Protein'],
      objectiveTags: ['volume']),
  ProductCategory(
      code: 'GL1',
      step: 'Treat',
      hairTypeGroup: 1,
      name: 'Lightweight Scalp Serum',
      genericCategory: 'Serum',
      weight: 'light',
      keyTopicalActives: ['Caffeine', 'Peptides', 'Niacinamide'],
      objectiveTags: ['growth']),
  // TYPE 2
  ProductCategory(
      code: 'F',
      step: 'Cleanse',
      hairTypeGroup: 2,
      name: 'Gentle Hydrating Shampoo',
      genericCategory: 'Shampoo',
      weight: 'light',
      keyTopicalActives: ['Coconut Oil', 'Silk Protein', 'Neem Oil'],
      objectiveTags: ['hydration', 'scalp'],
      multiObjective: true),
  ProductCategory(
      code: 'G',
      step: 'Condition',
      hairTypeGroup: 2,
      name: 'Medium Hydrating Conditioner',
      genericCategory: 'Conditioner',
      weight: 'medium',
      keyTopicalActives: ['Argan Oil', 'Vitamins A & E'],
      objectiveTags: ['hydration']),
  ProductCategory(
      code: 'H',
      step: 'Treat',
      hairTypeGroup: 2,
      name: 'Hydra+Repair Moderate Mask',
      genericCategory: 'Mask',
      weight: 'medium',
      keyTopicalActives: ['K18Peptide™', 'Keratin', 'Argan Oil'],
      objectiveTags: ['repair', 'hydration']),
  ProductCategory(
      code: 'I',
      step: 'Cleanse',
      hairTypeGroup: 2,
      name: 'Soothing Scalp Gentle Shampoo',
      genericCategory: 'Shampoo',
      weight: 'light',
      keyTopicalActives: ['Glycolic Acid', 'Aloe', 'Salicylic Acid'],
      objectiveTags: ['scalp', 'scalp-soothing']),
  ProductCategory(
      code: 'J',
      step: 'Protect',
      hairTypeGroup: 2,
      name: 'Heat & UV Light-Medium Protector',
      genericCategory: 'Heat Protectant',
      weight: 'medium',
      keyTopicalActives: ['Argan Oil', 'UV Filters', 'Silk Amino Acids'],
      objectiveTags: ['protection']),
  ProductCategory(
      code: 'V',
      step: 'Protect',
      hairTypeGroup: 2,
      name: 'Light Mousse / Wave Spray',
      genericCategory: 'Styling',
      weight: 'light',
      keyTopicalActives: ['Rice Curl Complex', 'Hydrolyzed Protein'],
      objectiveTags: ['curl-definition', 'frizz-control']),
  ProductCategory(
      code: 'W',
      step: 'Treat',
      hairTypeGroup: 2,
      name: 'Root Densifying Spray',
      genericCategory: 'Styling',
      weight: 'light',
      keyTopicalActives: ['Wheat Protein', 'Biotin', 'Caffeine'],
      objectiveTags: ['density', 'volume']),
  ProductCategory(
      code: 'GL2',
      step: 'Treat',
      hairTypeGroup: 2,
      name: 'Light-Medium Scalp Serum',
      genericCategory: 'Serum',
      weight: 'light',
      keyTopicalActives: [
        'Caffeine',
        'Peptides',
        'Niacinamide',
        'Saw Palmetto'
      ],
      objectiveTags: [
        'growth'
      ]),
  // TYPE 3
  ProductCategory(
      code: 'K',
      step: 'Cleanse',
      hairTypeGroup: 3,
      name: 'Sulfate-Free Hydrating Shampoo',
      genericCategory: 'Shampoo',
      weight: 'medium',
      keyTopicalActives: ['Coconut Oil', 'Shea Butter', 'Aloe'],
      objectiveTags: ['hydration', 'scalp'],
      multiObjective: true),
  ProductCategory(
      code: 'L',
      step: 'Condition',
      hairTypeGroup: 3,
      name: 'Rich Moisturizing Conditioner',
      genericCategory: 'Conditioner',
      weight: 'heavy',
      keyTopicalActives: ['Shea Butter', 'Castor Oil', 'Jojoba'],
      objectiveTags: ['hydration']),
  ProductCategory(
      code: 'M',
      step: 'Treat',
      hairTypeGroup: 3,
      name: 'Deep Repair Mask',
      genericCategory: 'Mask',
      weight: 'heavy',
      keyTopicalActives: ['Rosehip Oil', 'Algae', 'B-Vitamins', 'Keratin'],
      objectiveTags: ['repair', 'hydration'],
      multiObjective: true),
  ProductCategory(
      code: 'N',
      step: 'Cleanse',
      hairTypeGroup: 3,
      name: 'Sensitive Scalp Shampoo',
      genericCategory: 'Shampoo',
      weight: 'medium',
      keyTopicalActives: ['Tea Tree Oil', 'Aloe Vera', 'Zinc'],
      objectiveTags: ['scalp', 'scalp-soothing']),
  ProductCategory(
      code: 'O',
      step: 'Protect',
      hairTypeGroup: 3,
      name: 'Leave-In + Heat Protector',
      genericCategory: 'Leave-in',
      weight: 'medium',
      keyTopicalActives: ['Argan Oil', 'Silk Protein', 'UV Filters'],
      objectiveTags: ['protection', 'frizz-control']),
  ProductCategory(
      code: 'X',
      step: 'Protect',
      hairTypeGroup: 3,
      name: 'Defining Cream + Medium Gel',
      genericCategory: 'Styling',
      weight: 'medium',
      keyTopicalActives: ['Aloe', 'Flaxseed', 'Coconut Oil'],
      objectiveTags: ['curl-definition', 'frizz-control']),
  ProductCategory(
      code: 'Y',
      step: 'Treat',
      hairTypeGroup: 3,
      name: 'Thickening Cream + Light Gel',
      genericCategory: 'Styling',
      weight: 'medium',
      keyTopicalActives: ['Jojoba', 'Cactus Extract', 'Biotin'],
      objectiveTags: ['density']),
  ProductCategory(
      code: 'GL3',
      step: 'Treat',
      hairTypeGroup: 3,
      name: 'Hydrating Scalp Serum',
      genericCategory: 'Serum',
      weight: 'medium',
      keyTopicalActives: ['Caffeine', 'Peptides', 'Niacinamide', 'Jojoba Oil'],
      objectiveTags: ['growth']),
  // TYPE 4
  ProductCategory(
      code: 'P',
      step: 'Cleanse',
      hairTypeGroup: 4,
      name: 'Ultra Gentle Cleanser / Co-Wash',
      genericCategory: 'Shampoo',
      weight: 'heavy',
      keyTopicalActives: ['Coconut Oil', 'Honey', 'Aloe Vera'],
      objectiveTags: ['hydration', 'scalp'],
      multiObjective: true),
  ProductCategory(
      code: 'Q',
      step: 'Condition',
      hairTypeGroup: 4,
      name: 'Very Rich Deep Conditioner',
      genericCategory: 'Conditioner',
      weight: 'heavy',
      keyTopicalActives: ['Pomegranate Extract', 'Honey', 'Babassu Oil'],
      objectiveTags: ['hydration']),
  ProductCategory(
      code: 'R',
      step: 'Treat',
      hairTypeGroup: 4,
      name: 'Deep Structuring Treatment',
      genericCategory: 'Mask',
      weight: 'heavy',
      keyTopicalActives: ['Hydrolyzed Collagen', 'Keratin', 'Raw Honey'],
      objectiveTags: ['repair', 'hydration'],
      multiObjective: true),
  ProductCategory(
      code: 'S',
      step: 'Cleanse',
      hairTypeGroup: 4,
      name: 'Soothing Nourishing Scalp Cleanser',
      genericCategory: 'Shampoo',
      weight: 'heavy',
      keyTopicalActives: ['Piroctone Olamine', 'Aloe Vera', 'Shea Butter'],
      objectiveTags: ['scalp', 'scalp-soothing']),
  ProductCategory(
      code: 'T',
      step: 'Protect',
      hairTypeGroup: 4,
      name: 'Leave-In Cream + Sealing Oil',
      genericCategory: 'Leave-in',
      weight: 'heavy',
      keyTopicalActives: [
        'Jamaican Black Castor Oil',
        'Shea Butter',
        'Vitamin E'
      ],
      objectiveTags: [
        'protection',
        'frizz-control'
      ]),
  ProductCategory(
      code: 'Z',
      step: 'Protect',
      hairTypeGroup: 4,
      name: 'Rich Leave-In + Strong Gel + Light Oil',
      genericCategory: 'Styling',
      weight: 'heavy',
      keyTopicalActives: ['Olive Oil', 'Flaxseed', 'Marshmallow Root'],
      objectiveTags: ['curl-definition']),
  ProductCategory(
      code: 'AA',
      step: 'Treat',
      hairTypeGroup: 4,
      name: 'Structuring Cream + Sealing Oil',
      genericCategory: 'Oil',
      weight: 'heavy',
      keyTopicalActives: ['Castor Oil', 'Shea Butter', 'Biotin'],
      objectiveTags: ['density']),
  ProductCategory(
      code: 'GL4',
      step: 'Treat',
      hairTypeGroup: 4,
      name: 'Nourishing Scalp Serum / Oil-Based Scalp Tonic',
      genericCategory: 'Serum',
      weight: 'heavy',
      keyTopicalActives: [
        'Caffeine',
        'Peptides',
        'Niacinamide',
        'Castor Oil',
        'Peppermint'
      ],
      objectiveTags: [
        'growth'
      ]),
];

List<ProductCategory> getProductCategoriesForProfile(
        int hairType, String objectiveId) =>
    kProductCategories
        .where((pc) =>
            pc.hairTypeGroup == hairType &&
            pc.objectiveTags.contains(objectiveId))
        .toList();

List<ProductCategory> getAllCategoriesForProfile(HairProfile profile) {
  final activeObjectives = ['hydration', 'repair', 'scalp', 'protection'];
  if (profile.additionalObjective != null) {
    activeObjectives.add(profile.additionalObjective!);
  }
  final seen = <String>{};
  final result = <ProductCategory>[];
  for (final obj in activeObjectives) {
    for (final pc in kProductCategories) {
      if (pc.hairTypeGroup == profile.hairType &&
          pc.objectiveTags.contains(obj) &&
          !seen.contains(pc.code)) {
        seen.add(pc.code);
        result.add(pc);
      }
    }
  }
  return result;
}

// ═══════════════════════════════════════════════
// 6) AMAZON PRODUCTS
// ═══════════════════════════════════════════════

class AmazonProduct {
  final String id;
  final String title;
  final String brand;
  final String imageUrl;
  final String priceTier; // "budget" | "mid" | "premium"
  final String amazonAffiliateUrl;
  final String productCategoryCode;
  final List<String> keyActives;
  final String notesShort;
  final String weight;
  final List<int> hairTypes;
  final bool isDuplicateUrl;
  final String status;
  final List<String> tags;

  const AmazonProduct({
    required this.id,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.priceTier,
    required this.amazonAffiliateUrl,
    required this.productCategoryCode,
    required this.keyActives,
    required this.notesShort,
    required this.weight,
    required this.hairTypes,
    this.isDuplicateUrl = false,
    this.status = 'active',
    this.tags = const [],
  });
}

const kAmazonProducts = [
  // ── TYPE 1 ──
  AmazonProduct(
      id: 'a1',
      title: 'KÉRASTASE Gloss Absolu Bain Hydra-Glaze',
      brand: 'Kérastase',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0G7J7JXKV',
      productCategoryCode: 'A',
      keyActives: ['Hyaluronic Acid', 'Gloss Complex'],
      notesShort: 'Shampoing hydratant leger pour cheveux fins',
      weight: 'light',
      hairTypes: [1, 2],
      tags: ['lightweight', 'hydrating', 'fine hair']),
  AmazonProduct(
      id: 'b1',
      title: 'Les Secrets de Loly Pink Paradise',
      brand: 'Les Secrets de Loly',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B017KGU7LS',
      productCategoryCode: 'B',
      keyActives: ['Detangling Agents', 'Hydrating Complex'],
      notesShort: 'Apres-shampoing leger et demelant pour cheveux fins',
      weight: 'light',
      hairTypes: [1, 2]),
  AmazonProduct(
      id: 'c1',
      title: 'Olaplex No.3 Hair Perfector',
      brand: 'Olaplex',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B08TWTQDCX',
      productCategoryCode: 'C',
      keyActives: ['Bis-Aminopropyl Diglycol Dimaleate'],
      notesShort: 'Soin reparateur de liaisons pour tous types de cheveux',
      weight: 'light',
      hairTypes: [1, 2, 3, 4]),
  AmazonProduct(
      id: 'd1',
      title: 'Uriage DS Hair Shampooing Doux Équilibrant',
      brand: 'Uriage',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0849VSLYK',
      productCategoryCode: 'D',
      keyActives: ['Piroctone Olamine', 'Gentle Surfactants'],
      notesShort: 'Shampoing doux pour equilibrer le cuir chevelu',
      weight: 'light',
      hairTypes: [1, 2]),
  AmazonProduct(
      id: 'e1',
      title: "L'Oréal Paris Thermo-Protecteur 230°",
      brand: "L'Oréal Paris",
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0CDH9D6J9',
      productCategoryCode: 'E',
      keyActives: ['Heat Shield Complex', 'UV Filters'],
      notesShort: 'Spray protecteur de chaleur pour le coiffage quotidien',
      weight: 'light',
      hairTypes: [1, 2]),
  AmazonProduct(
      id: 'gl1_1',
      title: 'Briogeo Destined for Density MegaStrength+',
      brand: 'Briogeo',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0BS71XY2M',
      productCategoryCode: 'GL1',
      keyActives: ['Peptides', 'Biotin', 'Caffeine'],
      notesShort: 'Serum cuir chevelu leger pour soutenir la pousse',
      weight: 'light',
      hairTypes: [1]),
  AmazonProduct(
      id: 'u1',
      title: 'Redken Root Lifter Volumisant Racines',
      brand: 'Redken',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0BGHPGL92',
      productCategoryCode: 'U',
      keyActives: ['Biotin', 'Volumizing Polymers'],
      notesShort: 'Spray volumateur en racines pour plus de densite',
      weight: 'light',
      hairTypes: [1, 2]),
  AmazonProduct(
      id: 'v1_1',
      title: 'Redken Root Lifter Volumisant Racines',
      brand: 'Redken',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0BGHPGL92',
      productCategoryCode: 'V1',
      keyActives: ['Biotin', 'Volumizing Polymers'],
      notesShort: 'Spray racines pour apporter corps et volume',
      weight: 'light',
      hairTypes: [1],
      isDuplicateUrl: true),
  // ── TYPE 2 ──
  AmazonProduct(
      id: 'f1',
      title: 'Dessange Hydra-Apaisant',
      brand: 'Dessange',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0FH73BNNY',
      productCategoryCode: 'F',
      keyActives: ['Niacinamide', 'Hydrating Complex'],
      notesShort: 'Shampoing hydratant doux pour cheveux ondules',
      weight: 'light',
      hairTypes: [2]),
  AmazonProduct(
      id: 'g1',
      title: 'Creme of Nature Argan Oil Intensive Conditioning Treatment',
      brand: 'Creme of Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B004YRVCGQ',
      productCategoryCode: 'G',
      keyActives: ['Argan Oil', 'Vitamins A & E'],
      notesShort: 'Apres-shampoing hydratant moyen pour ondulations',
      weight: 'medium',
      hairTypes: [2, 3]),
  AmazonProduct(
      id: 'h1',
      title: 'Dessange Masque Reconstructeur Kératine',
      brand: 'Dessange',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0F99L61JF',
      productCategoryCode: 'H',
      keyActives: ['Keratin', 'Hyaluronic Acid'],
      notesShort: 'Masque reparateur a la keratine pour ondulations abimees',
      weight: 'medium',
      hairTypes: [2, 3]),
  AmazonProduct(
      id: 'i1',
      title: 'Dessange Hydra-Apaisant',
      brand: 'Dessange',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0FH73BNNY',
      productCategoryCode: 'I',
      keyActives: ['Niacinamide', 'Soothing Complex'],
      notesShort: 'Nettoyant apaisant du cuir chevelu pour cheveux ondules',
      weight: 'light',
      hairTypes: [2],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'j1',
      title: 'Schwarzkopf Spray Protection 230°C',
      brand: 'Schwarzkopf',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0DZJ1KJRR',
      productCategoryCode: 'J',
      keyActives: ['Apricot Oil', 'Heat Shield'],
      notesShort: 'Spray protecteur de chaleur pour cheveux ondules',
      weight: 'medium',
      hairTypes: [2]),
  AmazonProduct(
      id: 'gl2_1',
      title: 'Energie Fruit Sérum Cuir Chevelu Rééquilibrant',
      brand: 'Energie Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0DT9S1L7B',
      productCategoryCode: 'GL2',
      keyActives: ['Balancing Agents', 'Hydrating Serum'],
      notesShort: 'Serum cuir chevelu pour pousse et equilibre',
      weight: 'light',
      hairTypes: [2]),
  AmazonProduct(
      id: 'w1',
      title: 'Kerargan Spray Épaississant Collagène',
      brand: 'Kerargan',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0BS1QGTL1',
      productCategoryCode: 'W',
      keyActives: ['Collagen', 'Thickening Polymers'],
      notesShort: 'Spray epaississant pour cheveux ondules fins',
      weight: 'light',
      hairTypes: [2]),
  AmazonProduct(
      id: 'v2_1',
      title: 'Creme of Nature Moisture Whip Twisting Cream',
      brand: 'Creme of Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B07B541D8P',
      productCategoryCode: 'V',
      keyActives: ['Argan Oil', 'Twisting Butter'],
      notesShort: 'Creme definissante pour cheveux ondules',
      weight: 'medium',
      hairTypes: [2]),
  // ── TYPE 3 ──
  AmazonProduct(
      id: 'k1',
      title: 'Lavera Shampooing Fraîcheur & Équilibre',
      brand: 'Lavera',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B08X57GHDB',
      productCategoryCode: 'K',
      keyActives: ['Natural Extracts', 'Gentle Cleansers'],
      notesShort: 'Shampoing hydratant sans sulfates pour boucles',
      weight: 'medium',
      hairTypes: [3]),
  AmazonProduct(
      id: 'l1',
      title: "Lavera Après-shampooing Réparateur & Soin Profond",
      brand: 'Lavera',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0869F26V6',
      productCategoryCode: 'L',
      keyActives: ['Repair Complex', 'Deep Moisture'],
      notesShort: 'Apres-shampoing riche et hydratant pour boucles',
      weight: 'heavy',
      hairTypes: [3, 4]),
  AmazonProduct(
      id: 'm1',
      title: "L'Oréal Professionnel Pro Longer Mask",
      brand: "L'Oréal Professionnel",
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0968VX473',
      productCategoryCode: 'M',
      keyActives: ['Filler-A100', 'Amino Acids'],
      notesShort: 'Masque reparateur profond pour cheveux boucles',
      weight: 'heavy',
      hairTypes: [3, 4]),
  AmazonProduct(
      id: 'n1',
      title: 'Kérastase Spécifique Bain Dermo-Calm',
      brand: 'Kérastase',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01HYOB0LC',
      productCategoryCode: 'N',
      keyActives: ['Calming Complex', 'Gentle Surfactants'],
      notesShort: 'Shampoing cuir chevelu sensible pour cheveux boucles',
      weight: 'medium',
      hairTypes: [3]),
  AmazonProduct(
      id: 'o1',
      title: 'Redken One United',
      brand: 'Redken',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00YO38G4Q',
      productCategoryCode: 'O',
      keyActives: ['Multi-benefit Complex', 'Heat Shield'],
      notesShort: 'Soin sans rincage protecteur de chaleur pour boucles',
      weight: 'medium',
      hairTypes: [3]),
  AmazonProduct(
      id: 'gl3_1',
      title: 'Generic Peptide Scalp Serum',
      brand: 'Generic',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0GFDHCT9L',
      productCategoryCode: 'GL3',
      keyActives: ['Peptides', 'Hydrating Serum'],
      notesShort: 'Serum hydratant du cuir chevelu pour soutenir la pousse',
      weight: 'medium',
      hairTypes: [3]),
  AmazonProduct(
      id: 'y1',
      title: 'Weleda Lotion Capillaire Tonifiante',
      brand: 'Weleda',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00ANYARFG',
      productCategoryCode: 'Y',
      keyActives: ['Rosemary', 'Tonic Complex'],
      notesShort: 'Tonique epaississant du cuir chevelu pour boucles',
      weight: 'medium',
      hairTypes: [3]),
  AmazonProduct(
      id: 'x1',
      title: 'Creme of Nature Moisture Whip Twisting Cream',
      brand: 'Creme of Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B07B541D8P',
      productCategoryCode: 'X',
      keyActives: ['Argan Oil', 'Twisting Butter'],
      notesShort: 'Creme definissante pour cheveux boucles',
      weight: 'medium',
      hairTypes: [3],
      isDuplicateUrl: true),
  // ── TYPE 4 ──
  AmazonProduct(
      id: 'p1',
      title: 'As I Am Coconut CoWash',
      brand: 'As I Am',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B008DFR2UU',
      productCategoryCode: 'P',
      keyActives: ['Coconut Oil', 'Gentle Cleansers'],
      notesShort: 'Co-wash ultra doux pour cheveux crepus ou tres frises',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 'q1',
      title: 'Kérastase Nutritive Masquintense',
      brand: 'Kérastase',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0BZZK3R5S',
      productCategoryCode: 'Q',
      keyActives: ['Nourishing Complex', 'Intense Moisture'],
      notesShort: 'Soin profond tres riche pour cheveux crepus ou tres frises',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 'r1',
      title: "L'Oréal Professionnel Absolut Repair Molecular",
      brand: "L'Oréal Professionnel",
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B0D7NZ3N7P',
      productCategoryCode: 'R',
      keyActives: ['Molecular Repair Complex', 'Amino Acids'],
      notesShort: 'Reparation moleculaire profonde pour cheveux crepus ou tres frises',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 's1',
      title: 'Soothing Coily Scalp Cleanser',
      brand: 'EU-friendly option',
      imageUrl: '',
      priceTier: 'mid',
      amazonAffiliateUrl: '#',
      productCategoryCode: 'S',
      keyActives: ['Piroctone Olamine', 'Aloe Vera'],
      notesShort:
          'Use on scalp only when flakes or itch appear; follow with conditioner',
      weight: 'heavy',
      hairTypes: [4],
      status: 'active'),
  AmazonProduct(
      id: 't1',
      title: "L'Oréal Professionnel Curl Expression Crème-en-Gelée Leave-In",
      brand: "L'Oréal Professionnel",
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B09W6JLZPH',
      productCategoryCode: 'T',
      keyActives: ['Curl Complex', 'Heat Protection'],
      notesShort: 'Creme sans rincage riche avec protection chaleur',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 'gl4_1',
      title: 'Sunny Isle Jamaican Black Castor Oil Extra Dark',
      brand: 'Sunny Isle',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B003KFFGVA',
      productCategoryCode: 'GL4',
      keyActives: ['Jamaican Black Castor Oil'],
      notesShort: 'Huile nourrissante du cuir chevelu pour soutenir la pousse',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 'aa1',
      title: 'Weleda Lotion Capillaire Tonifiante',
      brand: 'Weleda',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00ANYARFG',
      productCategoryCode: 'AA',
      keyActives: ['Rosemary', 'Tonic Complex'],
      notesShort: 'Tonique cuir chevelu pour densite et epaisseur',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'z1',
      title: "L'Oreal Professionnel Curl Expression Creme-en-Gelee Leave-In",
      brand: "L'Oreal Professionnel",
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B09W6JLZPH',
      productCategoryCode: 'Z',
      keyActives: ['Curl Complex', 'Sealing Agents'],
      notesShort: 'Soin sans rincage riche pour definir et sceller les boucles',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),

  // ── TYPE 1 additions ──
  AmazonProduct(
      id: 'a2',
      title: 'Klorane Shampoing Nutri-Reparateur au Beurre de Mangue',
      brand: 'Klorane',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00RMLHCNI',
      productCategoryCode: 'A',
      keyActives: ['Mango Butter', 'Rice Protein'],
      notesShort: 'Shampoing hydratant doux pour cheveux fins lisses',
      weight: 'light',
      hairTypes: [1],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'b2',
      title: "L'Oreal Paris Elvive Apres-Shampoing Huile Extraordinaire",
      brand: "L'Oreal Paris",
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00QV2KPKU',
      productCategoryCode: 'B',
      keyActives: ['Extraordinary Oils', 'Keratin'],
      notesShort: 'Apres-shampoing leger a base d\'huile pour cheveux fins',
      weight: 'light',
      hairTypes: [1],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'c2',
      title: 'Olaplex N.3 Hair Perfector',
      brand: 'Olaplex',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01LXH4JST',
      productCategoryCode: 'C',
      keyActives: ['Bis-Aminopropyl Diglycol Dimaleate'],
      notesShort: 'Soin reparateur de liaisons capillaires numero 1 mondial',
      weight: 'light',
      hairTypes: [1, 2],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'd2',
      title: 'Ducray Kelual DS Shampooing Antipelliculaire Intensif',
      brand: 'Ducray',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B003OCIZ6O',
      productCategoryCode: 'D',
      keyActives: ['Piroctone Olamine', 'Zinc PCA', 'Salicylic Acid'],
      notesShort: 'Shampoing intensif antipelliculaire pour cuir chevelu sensible',
      weight: 'light',
      hairTypes: [1, 2]),
  AmazonProduct(
      id: 'e2',
      title: 'Schwarzkopf Gliss Total Repair Spray Protecteur Thermique',
      brand: 'Schwarzkopf',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B079MHNNQ8',
      productCategoryCode: 'E',
      keyActives: ['Heat Shield Complex', 'UV Filters', 'Keratin'],
      notesShort: 'Spray protecteur chaleur et UV jusqu\'a 230 degres',
      weight: 'light',
      hairTypes: [1],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'u2',
      title: 'Kerastase Densifique Mousse Densimorphose',
      brand: 'Kerastase',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B07FXYWM4K',
      productCategoryCode: 'U',
      keyActives: ['Biotin', 'Hyaluronic Acid', 'Rice Protein'],
      notesShort: 'Mousse volumisante densifiante pour cheveux fins',
      weight: 'light',
      hairTypes: [1],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'gl1_2',
      title: 'The Ordinary Multi-Peptide Serum for Hair Density',
      brand: 'The Ordinary',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B089LNR1D5',
      productCategoryCode: 'GL1',
      keyActives: ['Caffeine', 'Peptides', 'Niacinamide', 'Redensyl'],
      notesShort: 'Serum peptides actifs pour densite et pousse capillaire',
      weight: 'light',
      hairTypes: [1, 2]),

  // ── TYPE 2 additions ──
  AmazonProduct(
      id: 'f2',
      title: 'Cantu Sulfate-Free Cleansing Cream Shampoo',
      brand: 'Cantu',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01MY0MQIW',
      productCategoryCode: 'F',
      keyActives: ['Coconut Oil', 'Shea Butter', 'Silk Protein'],
      notesShort: 'Shampoing creme sans sulfates pour ondulations',
      weight: 'light',
      hairTypes: [2, 3]),
  AmazonProduct(
      id: 'g2',
      title: 'SheaMoisture Coconut & Hibiscus Curl & Shine Conditioner',
      brand: 'SheaMoisture',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B07L89BFWL',
      productCategoryCode: 'G',
      keyActives: ['Coconut Oil', 'Hibiscus', 'Silk Protein'],
      notesShort: 'Apres-shampoing brillance et boucle pour cheveux ondules',
      weight: 'medium',
      hairTypes: [2, 3],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'h2',
      title: 'Olaplex N.8 Bond Intense Moisture Mask',
      brand: 'Olaplex',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B08VRBGP99',
      productCategoryCode: 'H',
      keyActives: ['Bond Building Technology', 'Hydrolyzed Silk', 'Vitamin E'],
      notesShort: 'Masque intensif reparateur de liaisons pour cheveux abimes',
      weight: 'medium',
      hairTypes: [2, 3],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'i2',
      title: 'Klorane Shampoing Purifiant a la Pivoine',
      brand: 'Klorane',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00PB8YQXK',
      productCategoryCode: 'I',
      keyActives: ['Peony Extract', 'Niacinamide'],
      notesShort: 'Shampoing apaisant pour cuir chevelu sensible et reactive',
      weight: 'light',
      hairTypes: [2],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'j2',
      title: 'Moroccanoil Treatment Original',
      brand: 'Moroccanoil',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B002A5B2AU',
      productCategoryCode: 'J',
      keyActives: ['Argan Oil', 'Vitamin E', 'UV Filters'],
      notesShort: 'Soin a l\'huile d\'argan pour brillance et protection thermique',
      weight: 'medium',
      hairTypes: [2, 3],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'gl2_2',
      title: 'Nioxin Systeme 2 Soin Fortifiant Cuir Chevelu',
      brand: 'Nioxin',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00EYEJTD8',
      productCategoryCode: 'GL2',
      keyActives: ['Caffeine', 'Biotin', 'Saw Palmetto'],
      notesShort: 'Soin fortifiant cuir chevelu contre la chute et clairsemement',
      weight: 'light',
      hairTypes: [2],
      isDuplicateUrl: true),

  // ── TYPE 3 additions ──
  AmazonProduct(
      id: 'k2',
      title: 'SheaMoisture Raw Shea Butter Moisture Retention Shampoo',
      brand: 'SheaMoisture',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00K5XZ3OO',
      productCategoryCode: 'K',
      keyActives: ['Raw Shea Butter', 'Sea Kelp', 'Argan Oil'],
      notesShort: 'Shampoing sans sulfates ultra-nourrissant pour boucles prononcees',
      weight: 'medium',
      hairTypes: [3, 4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'l2',
      title: "Aunt Jackie's Oh So Clean! Moisturizing & Softening Conditioner",
      brand: "Aunt Jackie's",
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01AW1OAQM',
      productCategoryCode: 'L',
      keyActives: ['Castor Oil', 'Jojoba', 'Shea Butter'],
      notesShort: 'Apres-shampoing riche hydratant pour boucles et coils',
      weight: 'heavy',
      hairTypes: [3, 4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'm2',
      title: 'K18 Leave-In Molecular Repair Hair Mask',
      brand: 'K18',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B09KN2ZHJM',
      productCategoryCode: 'M',
      keyActives: ['K18Peptide', 'Biologically Active Peptides'],
      notesShort: 'Masque reparateur moleculaire sans rincage haute performance',
      weight: 'heavy',
      hairTypes: [3, 4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'n2',
      title: 'Nizoral Shampooing Antipelliculaire 2% Ketoconazole',
      brand: 'Nizoral',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B000MF1SHW',
      productCategoryCode: 'N',
      keyActives: ['Ketoconazole 2%'],
      notesShort: 'Shampoing medical contre pellicules et dermite seborrheique',
      weight: 'medium',
      hairTypes: [3, 4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'o2',
      title: 'Mielle Organics Pomegranate & Honey Leave-In Conditioner',
      brand: 'Mielle Organics',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B07YD8KQ8B',
      productCategoryCode: 'O',
      keyActives: ['Pomegranate Extract', 'Honey', 'Babassu Oil'],
      notesShort: 'Soin sans rincage hydratant et frizz-control pour boucles',
      weight: 'medium',
      hairTypes: [3],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'x2',
      title: 'Cantu Shea Butter Moisturizing Twist & Lock Gel',
      brand: 'Cantu',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01B3U7NVS',
      productCategoryCode: 'X',
      keyActives: ['Aloe Vera', 'Flaxseed Oil', 'Shea Butter'],
      notesShort: 'Gel definissant boucles sans alcool pour type 3',
      weight: 'medium',
      hairTypes: [3, 4],
      isDuplicateUrl: true),

  // ── TYPE 4 additions ──
  AmazonProduct(
      id: 'p2',
      title: 'As I Am Coconut CoWash Cleansing Conditioner',
      brand: 'As I Am',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01F8AR5GI',
      productCategoryCode: 'P',
      keyActives: ['Coconut Oil', 'Phytosterols', 'Castor Oil'],
      notesShort: 'Co-wash nettoyant doux sans detergent fort pour coils',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'q2',
      title: 'Cantu Shea Butter Deep Treatment Masque',
      brand: 'Cantu',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B009NR2PAY',
      productCategoryCode: 'Q',
      keyActives: ['Shea Butter', 'Honey', 'Coconut Oil', 'Avocado Oil'],
      notesShort: 'Masque traitement profond ultra-nourrissant pour type 4',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'r2',
      title: "Briogeo Don't Despair Repair! Deep Conditioning Mask",
      brand: 'Briogeo',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'premium',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01HE39JHQ',
      productCategoryCode: 'R',
      keyActives: ['Rosehip Oil', 'Algae Extract', 'B-Vitamin Complex'],
      notesShort: 'Masque soin intensif reparateur pour coils et kinks abimes',
      weight: 'heavy',
      hairTypes: [4]),
  AmazonProduct(
      id: 's2',
      title: 'TGIN Moisture Rich Sulfate Free Shampoo',
      brand: 'TGIN',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00QWVCBYQ',
      productCategoryCode: 'S',
      keyActives: ['Aloe Vera', 'Shea Butter', 'Coconut Oil', 'Green Tea'],
      notesShort: 'Shampoing hydratant sans sulfates pour cuir chevelu sec type 4',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 't2',
      title: 'Cantu Shea Butter Leave-In Conditioning Repair Cream',
      brand: 'Cantu',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop',
      priceTier: 'budget',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B00KMVBS66',
      productCategoryCode: 'T',
      keyActives: ['Shea Butter', 'Castor Oil', 'Vitamin E'],
      notesShort: 'Creme sans rincage hydratante et protectrice pour coils',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'z2',
      title: 'SheaMoisture Coconut & Hibiscus Curl Enhancing Smoothie',
      brand: 'SheaMoisture',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B009NR1VVY',
      productCategoryCode: 'Z',
      keyActives: ['Coconut Oil', 'Hibiscus', 'Silk Protein', 'Neem Oil'],
      notesShort: 'Smoothie definissant boucles et coils pour type 4',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'aa2',
      title: 'Mielle Organics Rosemary Mint Scalp & Hair Strengthening Oil',
      brand: 'Mielle Organics',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B09FHZFGD9',
      productCategoryCode: 'AA',
      keyActives: ['Rosemary Oil', 'Biotin', 'Castor Oil', 'Peppermint'],
      notesShort: 'Huile stimulante cuir chevelu pour renforcement et pousse type 4',
      weight: 'heavy',
      hairTypes: [4],
      isDuplicateUrl: true),
  AmazonProduct(
      id: 'gl4_2',
      title: 'Tropic Isle Living Jamaican Black Castor Oil',
      brand: 'Tropic Isle Living',
      imageUrl:
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop',
      priceTier: 'mid',
      amazonAffiliateUrl: 'https://www.amazon.fr/dp/B01N6B2G9O',
      productCategoryCode: 'GL4',
      keyActives: ['Jamaican Black Castor Oil', 'Peppermint', 'Vitamin E'],
      notesShort: 'Huile de ricin noir jamaicaine pour pousse et nourrissage du cuir chevelu',
      weight: 'heavy',
      hairTypes: [4]),
];

const _tierOrder = {'budget': 0, 'mid': 1, 'premium': 2};

List<AmazonProduct> getAmazonProductsForCode(String code) => kAmazonProducts
    .where((p) => p.productCategoryCode == code)
    .toList()
  ..sort((a, b) =>
      (_tierOrder[a.priceTier] ?? 0).compareTo(_tierOrder[b.priceTier] ?? 0));

const _weightCompat = {
  1: ['light'],
  2: ['light', 'medium'],
  3: ['light', 'medium', 'heavy'],
  4: ['light', 'medium', 'heavy']
};

List<String> getAllowedWeights(int hairType) =>
    _weightCompat[hairType] ?? ['light', 'medium', 'heavy'];

class SmartProductGroup {
  final String category;
  final List<AmazonProduct> products;
  final ProductCategory catInfo;
  const SmartProductGroup(
      {required this.category, required this.products, required this.catInfo});
}

List<SmartProductGroup> getSmartProductsForObjective(
    int hairType, String objectiveId) {
  final categories = getProductCategoriesForProfile(hairType, objectiveId);
  final allowedWeights = getAllowedWeights(hairType);
  final seenProductIds = <String>{};
  final result = <SmartProductGroup>[];

  for (final cat in categories) {
    final products = kAmazonProducts
        .where((p) =>
            p.productCategoryCode == cat.code &&
            p.status == 'active' &&
            p.hairTypes.contains(hairType) &&
            allowedWeights.contains(p.weight) &&
            !seenProductIds.contains(p.id))
        .toList()
      ..sort((a, b) => (_tierOrder[a.priceTier] ?? 0)
          .compareTo(_tierOrder[b.priceTier] ?? 0));

    final limited = products.take(3).toList();
    for (final p in limited) {
      seenProductIds.add(p.id);
    }
    result.add(SmartProductGroup(
        category: cat.genericCategory, products: limited, catInfo: cat));
  }
  return result;
}

// ═══════════════════════════════════════════════
// 7) HAIR TYPES
// ═══════════════════════════════════════════════

class HairSubtype {
  final String letter;
  final String desc;
  const HairSubtype({required this.letter, required this.desc});
}

class HairType {
  final int type;
  final String label;
  final String desc;
  final List<HairSubtype> subtypes;
  const HairType(
      {required this.type,
      required this.label,
      required this.desc,
      required this.subtypes});
}

const kHairTypes = [
  HairType(
      type: 1,
      label: 'Raides',
      desc: 'Cheveux raides, sans ondulation visible.',
      subtypes: [
        HairSubtype(letter: 'A', desc: 'Fins et plats, difficiles à boucler'),
        HairSubtype(letter: 'B', desc: 'Corps moyen, légère courbe'),
        HairSubtype(letter: 'C', desc: 'Épais, avec plus de volume'),
      ]),
  HairType(type: 2, label: 'Ondulés', desc: 'Ondulations visibles.', subtypes: [
    HairSubtype(letter: 'A', desc: 'Ondulations très légères'),
    HairSubtype(letter: 'B', desc: 'Ondulations en S définies'),
    HairSubtype(letter: 'C', desc: 'Ondulations fortes, proches des boucles'),
  ]),
  HairType(type: 3, label: 'Bouclés', desc: 'Boucles visibles.', subtypes: [
    HairSubtype(letter: 'A', desc: 'Boucles larges en spirale'),
    HairSubtype(letter: 'B', desc: 'Boucles rebondies et définies'),
    HairSubtype(letter: 'C', desc: 'Boucles serrées en tire-bouchon'),
  ]),
  HairType(
      type: 4,
      label: 'Crépus / très frisés',
      desc: 'Coils serrés ou motif en zigzag.',
      subtypes: [
        HairSubtype(letter: 'A', desc: 'Coils souples et définis'),
        HairSubtype(letter: 'B', desc: 'Motif en Z, moins défini'),
        HairSubtype(letter: 'C', desc: 'Très serrés et denses'),
      ]),
];

// ═══════════════════════════════════════════════
// 8) ROUTINE GENERATION
// ═══════════════════════════════════════════════

class HairCareGuidance {
  final String washFrequency;
  final String conditionerUse;
  final String detangling;
  final String heatAndStyling;
  final String scalpWatch;

  const HairCareGuidance({
    required this.washFrequency,
    required this.conditionerUse,
    required this.detangling,
    required this.heatAndStyling,
    required this.scalpWatch,
  });
}

HairCareGuidance getHairCareGuidance(int hairType) {
  switch (hairType) {
    case 1:
      return const HairCareGuidance(
        washFrequency:
            'Lavez quand le cuir chevelu devient gras ou chargé en produits; les cheveux fins peuvent demander des lavages plus fréquents.',
        conditionerUse:
            'Appliquez l’après-shampoing surtout sur les longueurs et pointes pour garder les racines légères.',
        detangling:
            'Démêlez doucement des pointes vers les racines lorsque les cheveux sont légèrement essorés.',
        heatAndStyling:
            'Utilisez une chaleur faible à moyenne, évitez l’eau trop chaude et protégez avant brushing ou soleil.',
        scalpWatch:
            'Si le sébum ou les pellicules reviennent vite, augmentez légèrement la fréquence de nettoyage.',
      );
    case 2:
      return const HairCareGuidance(
        washFrequency:
            'Lavez quand le cuir chevelu est gras ou chargé; beaucoup de routines ondulées tournent autour de 2 à 3 lavages par semaine.',
        conditionerUse:
            'Conditionnez les pointes et longueurs sèches, puis utilisez un leave-in léger ou une mousse si besoin.',
        detangling:
            'Démêlez avec l’après-shampoing puis scrunchez; évitez de brosser les ondulations à sec.',
        heatAndStyling:
            'Diffusez à chaleur douce ou laissez sécher à l’air; protégez avant chaleur, UV ou eau très chaude.',
        scalpWatch:
            'Évitez les produits coiffants sur le cuir chevelu s’ils causent démangeaisons ou dépôts.',
      );
    case 3:
      return const HairCareGuidance(
        washFrequency:
            'Lavez selon le cuir chevelu, souvent chaque semaine à 10 jours selon transpiration et dépôts.',
        conditionerUse:
            'Conditionnez toute la longueur et ajoutez un soin profond si sécheresse ou casse.',
        detangling:
            'Démêlez sous la douche avec du glissant, aux doigts ou au peigne à dents larges.',
        heatAndStyling:
            'Privilégiez chaleur douce, protection des pointes, eau tiède et réduction des frottements la nuit.',
        scalpWatch:
            'Démangeaisons persistantes, plaques ou chute soudaine méritent un avis médical.',
      );
    default:
      return const HairCareGuidance(
        washFrequency:
            'Lavez selon les besoins, souvent chaque semaine ou une semaine sur deux pour les cheveux très crépus.',
        conditionerUse:
            'Utilisez un après-shampoing à chaque lavage et un soin profond si la sécheresse persiste.',
        detangling:
            'Démêlez par sections avec du glissant; évitez le brossage à sec et les coiffures trop serrées.',
        heatAndStyling:
            'Réduisez chaleur, eau très chaude, UV, frottements et traction; scellez les pointes si besoin.',
        scalpWatch:
            'N’ignorez pas douleurs, coiffures serrées, croûtes, plaques ou chute persistante; consultez si besoin.',
      );
  }
}

class RoutineStep {
  final int step;
  final String action;
  final String product;
  final String productCategoryCode;
  final String why;
  final String duration;
  final List<String> objectives;

  const RoutineStep({
    required this.step,
    required this.action,
    required this.product,
    required this.productCategoryCode,
    required this.why,
    required this.duration,
    required this.objectives,
  });
}

List<RoutineStep> getRoutineForProfile(HairProfile profile) {
  final t = profile.hairType;
  final steps = <RoutineStep>[];
  final cats = getAllCategoriesForProfile(profile);

  ProductCategory? findCat(String step, [String? objPref]) {
    if (objPref != null) {
      final match = cats.firstWhere(
        (c) => c.step == step && c.objectiveTags.contains(objPref),
        orElse: () =>
            cats.firstWhere((c) => c.step == step, orElse: () => cats.first),
      );
      if (match.step == step) return match;
    }
    try {
      return cats.firstWhere((c) => c.step == step);
    } catch (_) {
      return null;
    }
  }

  String objName(String id) => kObjectives
      .firstWhere((o) => o.id == id,
          orElse: () =>
              const Objective(id: '', name: '', type: '', descriptionShort: ''))
      .name;

  // Step 1: Nettoyer
  final cleanCat = findCat('Cleanse', 'hydration') ?? findCat('Cleanse');
  if (cleanCat != null) {
    final products = getAmazonProductsForCode(cleanCat.code);
    steps.add(RoutineStep(
      step: 1,
      action: 'Nettoyer',
      product: products.isNotEmpty ? products.first.title : cleanCat.name,
      productCategoryCode: cleanCat.code,
      why:
          '${cleanCat.name} choisi pour le cuir chevelu et la fibre de type $t',
      duration: t <= 2
          ? 'Masser le cuir chevelu 1 à 3 min, rincer les longueurs'
          : 'Masser doucement le cuir chevelu, surtout aux racines',
      objectives: cleanCat.objectiveTags.map(objName).toList(),
    ));
  }

  // Step 2: Traiter
  final treatCat = findCat('Treat', 'repair') ?? findCat('Treat');
  if (treatCat != null) {
    final products = getAmazonProductsForCode(treatCat.code);
    steps.add(RoutineStep(
      step: 2,
      action: 'Traiter',
      product: products.isNotEmpty ? products.first.title : treatCat.name,
      productCategoryCode: treatCat.code,
      why:
          '${treatCat.name} aide à limiter la casse quand la fibre est fragilisée',
      duration: t <= 2
          ? '5 à 10 min, chaque semaine ou selon besoin'
          : '10 à 20 min, chaque semaine à deux fois par mois',
      objectives: treatCat.objectiveTags.map(objName).toList(),
    ));
  }

  // Step 3: Conditionner
  final condCat = findCat('Condition');
  if (condCat != null) {
    final products = getAmazonProductsForCode(condCat.code);
    steps.add(RoutineStep(
      step: 3,
      action: 'Conditionner',
      product: products.isNotEmpty ? products.first.title : condCat.name,
      productCategoryCode: condCat.code,
      why:
          '${condCat.name} apporte du glissant, de la douceur et facilite le démêlage',
      duration: t <= 2
          ? '2 à 5 min, longueurs et pointes'
          : 'Appliquer généreusement, démêler, puis rincer ou laisser légèrement si le produit le permet',
      objectives: condCat.objectiveTags.map(objName).toList(),
    ));
  }

  // Step 4: Protéger
  final protCat = findCat('Protect', 'protection') ?? findCat('Protect');
  if (protCat != null) {
    final products = getAmazonProductsForCode(protCat.code);
    steps.add(RoutineStep(
      step: 4,
      action: 'Protéger',
      product: products.isNotEmpty ? products.first.title : protCat.name,
      productCategoryCode: protCat.code,
      why:
          '${protCat.name} limite les dommages liés aux UV, à la chaleur, aux frottements et aux pointes sèches',
      duration: t <= 2
          ? 'Éviter les UV prolongés, l’eau trop chaude et la chaleur sans protecteur'
          : 'Protéger les longueurs, éviter l’eau trop chaude et limiter frottements/UV',
      objectives: protCat.objectiveTags.map(objName).toList(),
    ));
    steps.add(RoutineStep(
      step: steps.length + 1,
      action: 'Éviter l’eau trop chaude',
      product: 'Eau tiède ou fraîche en rinçage final',
      productCategoryCode: protCat.code,
      why:
          'L’eau trop chaude peut accentuer la sécheresse et l’inconfort du cuir chevelu',
      duration: 'Utiliser de l’eau tiède, surtout au rinçage final',
      objectives: [objName('protection')],
    ));
    steps.add(RoutineStep(
      step: steps.length + 1,
      action: 'Limiter UV et chaleur',
      product: products.isNotEmpty ? products.first.title : protCat.name,
      productCategoryCode: protCat.code,
      why:
          'Les UV et la chaleur répétée peuvent fragiliser la cuticule et ternir la fibre',
      duration:
          'Couvrir les cheveux au soleil ou appliquer une protection avant exposition/chaleur',
      objectives: [objName('protection')],
    ));
  }

  // Additional objective add-on
  if (profile.additionalObjective != null) {
    const addOnCodes = {
      'growth': {1: 'GL1', 2: 'GL2', 3: 'GL3', 4: 'GL4'},
      'density': {1: 'U', 2: 'W', 3: 'Y', 4: 'AA'},
      'curl-definition': {1: 'V', 2: 'V', 3: 'X', 4: 'Z'},
      'volume': {1: 'V1', 2: 'W'},
    };
    final addCode = addOnCodes[profile.additionalObjective!]?[t];
    if (addCode != null) {
      try {
        final addCat = kProductCategories.firstWhere((c) => c.code == addCode);
        final products = getAmazonProductsForCode(addCode);
        final addObjName = objName(profile.additionalObjective!);
        steps.add(RoutineStep(
          step: steps.length + 1,
          action: 'Complément $addObjName',
          product: products.isNotEmpty ? products.first.title : addCat.name,
          productCategoryCode: addCat.code,
          why:
              '${addCat.name} apporte un soutien ciblé sans remplacer un avis médical',
          duration: 'Appliquer selon les indications',
          objectives: [addObjName],
        ));
      } catch (_) {}
    }
  }

  return steps;
}

// ═══════════════════════════════════════════════
// 9) WEEK PLAN
// ═══════════════════════════════════════════════

class DayPlan {
  final String type; // "wash" | "rest" | "treatment" | "oil"
  final String label;
  final List<String> objectives;
  final List<String> actions;

  const DayPlan({
    required this.type,
    required this.label,
    required this.objectives,
    required this.actions,
  });
}

Map<String, DayPlan> getWeekPlan(HairProfile profile) {
  final addObj = profile.additionalObjective != null
      ? kAdditionalObjectives
          .firstWhere((a) => a.id == profile.additionalObjective,
              orElse: () => const Objective(
                  id: '', name: '', type: '', descriptionShort: ''))
          .name
      : null;
  final hasAddObj = addObj != null && addObj.isNotEmpty;

  final washObjectives = [
    'Hydratation',
    'Équilibre du cuir chevelu',
    'Réparation',
    'Protection',
    if (hasAddObj) addObj
  ];
  final washActions = [
    'Nettoyer',
    'Conditionner',
    'Protéger',
    if (hasAddObj) 'Complément $addObj'
  ];
  final treatmentObjectives = [
    'Réparation',
    'Hydratation',
    if (hasAddObj) addObj
  ];
  final treatmentActions = ['Traiter', 'Conditionner'];
  final oilObjectives = ['Protection', 'Hydratation'];
  final oilActions = ['Protéger'];
  final restObjectives = ['Protection'];
  final restActions = <String>[];

  if (profile.hairType == 1) {
    return {
      'Mon': DayPlan(
          type: 'wash',
          label: 'Jour de lavage',
          objectives: washObjectives,
          actions: washActions),
      'Tue': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Wed': DayPlan(
          type: 'wash',
          label: 'Rafraîchissement du cuir chevelu',
          objectives: washObjectives,
          actions: ['Nettoyer', 'Conditionner']),
      'Thu': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Fri': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Sat': DayPlan(
          type: 'treatment',
          label: 'Soin léger',
          objectives: treatmentObjectives,
          actions: treatmentActions),
      'Sun': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
    };
  }
  if (profile.hairType == 2) {
    return {
      'Mon': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Tue': DayPlan(
          type: 'wash',
          label: 'Jour de lavage',
          objectives: washObjectives,
          actions: washActions),
      'Wed': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Thu': DayPlan(
          type: 'treatment',
          label: 'Soin léger',
          objectives: treatmentObjectives,
          actions: treatmentActions),
      'Fri': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Sat': DayPlan(
          type: 'wash',
          label: 'Lavage ou rafraîchissement',
          objectives: washObjectives,
          actions: ['Nettoyer', 'Conditionner', 'Protéger']),
      'Sun': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
    };
  }
  if (profile.hairType == 3) {
    return {
      'Mon': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Tue': DayPlan(
          type: 'wash',
          label: 'Jour de lavage',
          objectives: washObjectives,
          actions: washActions),
      'Wed': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Thu': DayPlan(
          type: 'treatment',
          label: 'Soin profond',
          objectives: treatmentObjectives,
          actions: treatmentActions),
      'Fri': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
      'Sat': DayPlan(
          type: 'oil',
          label: 'Scellage hydratation',
          objectives: oilObjectives,
          actions: oilActions),
      'Sun': DayPlan(
          type: 'rest',
          label: 'Repos',
          objectives: restObjectives,
          actions: restActions),
    };
  }
  return {
    'Mon': DayPlan(
        type: 'rest',
        label: 'Repos',
        objectives: restObjectives,
        actions: restActions),
    'Tue': DayPlan(
        type: 'oil',
        label: 'Contrôle hydratation',
        objectives: oilObjectives,
        actions: ['Protéger']),
    'Wed': DayPlan(
        type: 'rest',
        label: 'Repos',
        objectives: restObjectives,
        actions: restActions),
    'Thu': DayPlan(
        type: 'treatment',
        label: 'Soin profond',
        objectives: treatmentObjectives,
        actions: ['Traiter', 'Conditionner']),
    'Fri': DayPlan(
        type: 'rest',
        label: 'Repos',
        objectives: restObjectives,
        actions: restActions),
    'Sat': DayPlan(
        type: 'wash',
        label: 'Jour de lavage',
        objectives: washObjectives,
        actions: washActions),
    'Sun': DayPlan(
        type: 'rest',
        label: 'Faible manipulation',
        objectives: restObjectives,
        actions: restActions),
  };
}
