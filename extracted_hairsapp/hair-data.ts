/* ─── Hair Health Coach – Full Data Model ─── */

// ═══════════════════════════════════════════════
// 1) HAIR PROFILE
// ═══════════════════════════════════════════════

export interface HairProfile {
  hairType: number; // 1–4
  hairSubtype: string; // A, B, C
  additionalObjective: string | null; // "growth" | "density" | "curl-definition" | null
}

// ═══════════════════════════════════════════════
// 2) OBJECTIVES
// ═══════════════════════════════════════════════

export interface Objective {
  id: string;
  name: string;
  type: "fundamental" | "additional";
  description_short: string;
  icon?: string;
}

export const OBJECTIVES: Objective[] = [
  { id: "hydration", name: "Hydration", type: "fundamental", description_short: "Deep moisture balance for resilient hair" },
  { id: "repair", name: "Repair", type: "fundamental", description_short: "Bond rebuilding and structural recovery" },
  { id: "scalp", name: "Scalp Balance", type: "fundamental", description_short: "Healthy scalp environment for optimal growth" },
  { id: "protection", name: "Protection", type: "fundamental", description_short: "Shield from heat, UV, and environmental damage" },
  { id: "growth", name: "Growth & Hair Loss Control", type: "additional", description_short: "Stimulate follicles and reduce shedding", icon: "sprout" },
  { id: "density", name: "Density & Thickness", type: "additional", description_short: "Volumize and strengthen for fuller hair", icon: "layers" },
  { id: "curl-definition", name: "Curl Definition Advanced", type: "additional", description_short: "Enhanced pattern control and hold", icon: "waves" },
  { id: "volume", name: "Volume", type: "additional", description_short: "Lightweight lift and body for flat hair", icon: "layers" },
  { id: "frizz-control", name: "Frizz Control", type: "additional", description_short: "Smooth and seal cuticles against humidity", icon: "shield" },
  { id: "scalp-soothing", name: "Scalp Soothing", type: "additional", description_short: "Calm irritation and reduce sensitivity", icon: "activity" },
];

export const FUNDAMENTAL_OBJECTIVES = OBJECTIVES.filter(o => o.type === "fundamental");
export const ADDITIONAL_OBJECTIVES = OBJECTIVES.filter(o => o.type === "additional");

// ═══════════════════════════════════════════════
// 3) NUTRIENTS
// ═══════════════════════════════════════════════

export interface Nutrient {
  id: string;
  name: string;
  notes_short: string;
  dailyIntake: string;
  foods: string[];
}

export interface FoodDetail {
  per100g: string;
  perUnit?: {
    label: string;
    amount: string;
  };
  note?: string;
}

export const NUTRIENTS: Nutrient[] = [
  { id: "electrolytes", name: "Electrolytes (Na/K/Mg)", notes_short: "Maintain cellular hydration and hair shaft flexibility", dailyIntake: "Varies (balanced diet)", foods: ["Coconut water", "Bananas", "Avocado", "Spinach"] },
  { id: "omega3", name: "Omega-3 Fatty Acids", notes_short: "Essential fatty acids for lipid barrier and elasticity", dailyIntake: "250–500 mg EPA+DHA", foods: ["Salmon", "Sardines", "Walnuts", "Chia seeds", "Flaxseed"] },
  { id: "vitA", name: "Vitamin A", notes_short: "Supports sebum production and scalp moisture", dailyIntake: "700–900 mcg RAE", foods: ["Sweet potatoes", "Carrots", "Kale", "Liver"] },
  { id: "vitE", name: "Vitamin E", notes_short: "Antioxidant that supports scalp circulation and moisture lock", dailyIntake: "15 mg", foods: ["Almonds", "Sunflower seeds", "Avocado", "Spinach"] },
  { id: "zinc", name: "Zinc", notes_short: "Hair tissue growth, repair, and oil gland function", dailyIntake: "8–11 mg", foods: ["Oysters", "Pumpkin seeds", "Chickpeas", "Beef"] },
  { id: "protein", name: "Protein (Keratin building)", notes_short: "Provides amino acids for structural hair repair", dailyIntake: "46–56 g total", foods: ["Eggs", "Greek yogurt", "Chicken", "Lentils", "Quinoa"] },
  { id: "cysteine", name: "Cysteine & Methionine", notes_short: "Sulfur amino acids critical for keratin cross-linking", dailyIntake: "Part of protein intake", foods: ["Eggs", "Poultry", "Oats", "Sunflower seeds"] },
  { id: "biotin", name: "Biotin (B7)", notes_short: "Supports keratin infrastructure; deficiency causes thinning", dailyIntake: "30–100 mcg", foods: ["Eggs", "Sweet potatoes", "Almonds", "Oats"] },
  { id: "iron", name: "Iron", notes_short: "Oxygen delivery to follicles; deficiency causes hair loss", dailyIntake: "8–18 mg", foods: ["Red meat", "Spinach", "Lentils", "Fortified cereals"] },
  { id: "vitC", name: "Vitamin C", notes_short: "Collagen synthesis and iron absorption for hair integrity", dailyIntake: "75–90 mg", foods: ["Citrus", "Bell peppers", "Strawberries", "Broccoli"] },
  { id: "copper", name: "Copper", notes_short: "Supports melanin production and hair pigmentation", dailyIntake: "900 mcg", foods: ["Cashews", "Dark chocolate", "Lentils", "Shiitake mushrooms"] },
  { id: "vitD", name: "Vitamin D", notes_short: "Creates new follicles; low levels linked to alopecia", dailyIntake: "600–1000 IU", foods: ["Fatty fish", "Egg yolks", "Mushrooms", "Fortified milk"] },
  { id: "bComplex", name: "B-Complex Vitamins", notes_short: "Improve scalp circulation and reduce inflammation", dailyIntake: "Varies by B vitamin", foods: ["Whole grains", "Meat", "Eggs", "Legumes", "Leafy greens"] },
  { id: "selenium", name: "Selenium", notes_short: "Antioxidant protecting scalp cells from damage", dailyIntake: "55 mcg", foods: ["Brazil nuts", "Tuna", "Sardines", "Brown rice"] },
  { id: "carotenoids", name: "Carotenoids (Pro-Vitamin A)", notes_short: "Antioxidant protection against environmental damage", dailyIntake: "6–15 mg", foods: ["Carrots", "Tomatoes", "Sweet potatoes", "Papaya"] },
  { id: "water", name: "Water Intake", notes_short: "Foundational for hair shaft flexibility and preventing brittleness", dailyIntake: "2–3 liters", foods: ["Water", "Cucumber", "Watermelon", "Celery"] },
];

// Keyed as `nutrientId::foodName` (food name in lowercase)
export const FOOD_DETAILS: Record<string, FoodDetail> = {
  // ── ELECTROLYTES (potassium comme marqueur principal) ──
  "electrolytes::coconut water":  { per100g: "250 mg K", perUnit: { label: "1 verre (240 ml)", amount: "600 mg K" }, note: "Riche en sodium, potassium et magnésium naturels" },
  "electrolytes::bananas":        { per100g: "358 mg K", perUnit: { label: "1 banane (≈120 g)", amount: "430 mg K" }, note: "Excellente source de potassium naturel" },
  "electrolytes::avocado":        { per100g: "485 mg K", perUnit: { label: "½ avocat (≈75 g)", amount: "364 mg K" }, note: "Contient aussi 29 mg de magnésium/100g" },
  "electrolytes::spinach":        { per100g: "558 mg K", perUnit: { label: "1 tasse crue (≈30 g)", amount: "167 mg K" }, note: "Contient aussi 79 mg de magnésium/100g" },
  // ── OMEGA-3 ──
  "omega3::salmon":               { per100g: "2 150 mg EPA+DHA", perUnit: { label: "1 filet (≈150 g)", amount: "3 225 mg EPA+DHA" } },
  "omega3::sardines":             { per100g: "1 480 mg EPA+DHA", perUnit: { label: "1 boîte (≈90 g)", amount: "1 332 mg EPA+DHA" } },
  "omega3::walnuts":              { per100g: "9 080 mg ALA", perUnit: { label: "1 poignée (≈30 g)", amount: "2 724 mg ALA" }, note: "ALA (oméga-3 végétal), moins biodisponible que l'EPA+DHA marin" },
  "omega3::chia seeds":           { per100g: "17 830 mg ALA", perUnit: { label: "1 c. à soupe (≈12 g)", amount: "2 140 mg ALA" }, note: "ALA végétal – à compléter avec des sources marines pour l'EPA+DHA" },
  "omega3::flaxseed":             { per100g: "22 800 mg ALA", perUnit: { label: "1 c. à soupe moulu (≈7 g)", amount: "1 596 mg ALA" }, note: "Moudre avant consommation pour une meilleure absorption" },
  // ── VITAMIN A ──
  "vitA::sweet potatoes":         { per100g: "961 mcg RAE", perUnit: { label: "1 patate douce moy. (≈130 g)", amount: "1 249 mcg RAE" }, note: "Couvre environ 140% de l'apport journalier recommandé" },
  "vitA::carrots":                { per100g: "835 mcg RAE", perUnit: { label: "1 carotte moy. (≈61 g)", amount: "509 mcg RAE" } },
  "vitA::kale":                   { per100g: "241 mcg RAE", perUnit: { label: "1 tasse (≈67 g)", amount: "162 mcg RAE" } },
  "vitA::liver":                  { per100g: "9 442 mcg RAE", perUnit: { label: "100 g (portion bœuf)", amount: "9 442 mcg RAE" }, note: "Source exceptionnelle, à consommer avec modération (risque d'excès en vitamine A)" },
  // ── VITAMIN E ──
  "vitE::almonds":                { per100g: "25.6 mg", perUnit: { label: "1 poignée (≈30 g)", amount: "7.7 mg" }, note: "Couvre ~51% de l'apport journalier recommandé par poignée" },
  "vitE::sunflower seeds":        { per100g: "35.2 mg", perUnit: { label: "1 c. à soupe (≈9 g)", amount: "3.2 mg" } },
  "vitE::avocado":                { per100g: "2.1 mg", perUnit: { label: "½ avocat (≈75 g)", amount: "1.6 mg" } },
  "vitE::spinach":                { per100g: "2.0 mg", perUnit: { label: "1 tasse crue (≈30 g)", amount: "0.6 mg" } },
  // ── ZINC ──
  "zinc::oysters":                { per100g: "78.6 mg", perUnit: { label: "1 huître (≈15 g)", amount: "11.8 mg" }, note: "Source de zinc la plus concentrée connue – 1 huître couvre l'AJR" },
  "zinc::pumpkin seeds":          { per100g: "7.8 mg", perUnit: { label: "1 poignée (≈30 g)", amount: "2.3 mg" } },
  "zinc::chickpeas":              { per100g: "1.5 mg", perUnit: { label: "1 tasse cuite (≈164 g)", amount: "2.5 mg" } },
  "zinc::beef":                   { per100g: "6.3 mg", perUnit: { label: "100 g (portion)", amount: "6.3 mg" } },
  // ── PROTEIN ──
  "protein::eggs":                { per100g: "13 g", perUnit: { label: "1 œuf entier (≈50 g)", amount: "6.5 g" } },
  "protein::greek yogurt":        { per100g: "10 g", perUnit: { label: "1 pot (≈200 g)", amount: "20 g" } },
  "protein::chicken":             { per100g: "31 g", perUnit: { label: "1 blanc de poulet (≈150 g)", amount: "46 g" } },
  "protein::lentils":             { per100g: "9 g", perUnit: { label: "1 tasse cuite (≈200 g)", amount: "18 g" } },
  "protein::quinoa":              { per100g: "4.4 g", perUnit: { label: "1 tasse cuite (≈185 g)", amount: "8.1 g" } },
  // ── CYSTEINE & METHIONINE ──
  "cysteine::eggs":               { per100g: "592 mg", perUnit: { label: "1 œuf entier (≈50 g)", amount: "296 mg" }, note: "Contient les deux acides aminés soufrés essentiels à la kératine" },
  "cysteine::poultry":            { per100g: "960 mg", perUnit: { label: "100 g de volaille (blanc)", amount: "960 mg" } },
  "cysteine::oats":               { per100g: "400 mg", perUnit: { label: "1 tasse cuite (≈234 g)", amount: "936 mg" } },
  "cysteine::sunflower seeds":    { per100g: "870 mg", perUnit: { label: "1 poignée (≈30 g)", amount: "261 mg" } },
  // ── BIOTIN ──
  "biotin::eggs":                 { per100g: "20 mcg", perUnit: { label: "1 œuf entier (≈50 g)", amount: "10 mcg" }, note: "Le blanc cru contient de l'avidine qui bloque l'absorption – toujours cuire les œufs" },
  "biotin::sweet potatoes":       { per100g: "2.4 mcg", perUnit: { label: "1 patate douce moy. (≈130 g)", amount: "3.1 mcg" } },
  "biotin::almonds":              { per100g: "4.4 mcg", perUnit: { label: "1 poignée (≈30 g)", amount: "1.3 mcg" } },
  "biotin::oats":                 { per100g: "0.24 mcg", perUnit: { label: "1 tasse cuite (≈234 g)", amount: "0.6 mcg" } },
  // ── IRON ──
  "iron::red meat":               { per100g: "2.7 mg", perUnit: { label: "100 g (bœuf)", amount: "2.7 mg" }, note: "Fer héminique : absorption ~25%, bien supérieure au fer végétal" },
  "iron::spinach":                { per100g: "2.7 mg", perUnit: { label: "1 tasse cuite (≈180 g)", amount: "4.9 mg" }, note: "Fer non héminique : absorption ~5% – associer à la vitamine C pour optimiser" },
  "iron::lentils":                { per100g: "3.3 mg", perUnit: { label: "1 tasse cuite (≈200 g)", amount: "6.6 mg" }, note: "Bonne source végétale – à associer à la vitamine C pour meilleure absorption" },
  "iron::fortified cereals":      { per100g: "8–18 mg", perUnit: { label: "1 portion (≈30 g)", amount: "3–6 mg" }, note: "Varie selon la marque et le niveau d'enrichissement" },
  // ── VITAMIN C ──
  "vitC::citrus":                 { per100g: "53 mg", perUnit: { label: "1 orange (≈130 g)", amount: "69 mg" } },
  "vitC::bell peppers":           { per100g: "128 mg", perUnit: { label: "1 poivron rouge (≈150 g)", amount: "192 mg" }, note: "Le poivron rouge contient 3× plus de vitamine C qu'une orange" },
  "vitC::strawberries":           { per100g: "59 mg", perUnit: { label: "1 tasse (≈150 g)", amount: "88 mg" } },
  "vitC::broccoli":               { per100g: "89 mg", perUnit: { label: "1 tasse cuite (≈91 g)", amount: "81 mg" } },
  // ── COPPER ──
  "copper::cashews":              { per100g: "2.2 mg", perUnit: { label: "1 poignée (≈30 g)", amount: "0.66 mg" } },
  "copper::dark chocolate":       { per100g: "1.8 mg", perUnit: { label: "1 carré (≈10 g)", amount: "0.18 mg" } },
  "copper::lentils":              { per100g: "0.25 mg", perUnit: { label: "1 tasse cuite (≈200 g)", amount: "0.5 mg" } },
  "copper::shiitake mushrooms":   { per100g: "0.89 mg", perUnit: { label: "1 tasse cuite (≈145 g)", amount: "1.3 mg" } },
  // ── VITAMIN D ──
  "vitD::fatty fish":             { per100g: "526 UI", perUnit: { label: "1 filet de saumon (≈150 g)", amount: "789 UI" } },
  "vitD::egg yolks":              { per100g: "218 UI", perUnit: { label: "1 jaune d'œuf (≈17 g)", amount: "37 UI" } },
  "vitD::mushrooms":              { per100g: "~400 UI", perUnit: { label: "1 tasse (≈70 g)", amount: "~280 UI" }, note: "Seulement si les champignons ont été exposés aux rayons UV (soleil ou lampe UV)" },
  "vitD::fortified milk":         { per100g: "42 UI", perUnit: { label: "1 verre (240 ml)", amount: "100 UI" } },
  // ── B-COMPLEX ──
  "bComplex::whole grains":       { per100g: "4.5 mg niacine (B3)", perUnit: { label: "1 tranche pain complet (≈30 g)", amount: "1.4 mg B3" } },
  "bComplex::meat":               { per100g: "6.8 mg niacine (B3)", perUnit: { label: "100 g de bœuf", amount: "6.8 mg B3" } },
  "bComplex::eggs":               { per100g: "0.07 mg B12", perUnit: { label: "1 œuf entier (≈50 g)", amount: "0.04 mg B12" }, note: "Contient aussi B2, B5 (biotine) et folates" },
  "bComplex::legumes":            { per100g: "0.36 mg folates (B9)", perUnit: { label: "1 tasse lentilles (≈200 g)", amount: "0.72 mg B9" } },
  "bComplex::leafy greens":       { per100g: "0.19 mg folates (B9)", perUnit: { label: "1 tasse épinards (≈30 g)", amount: "0.06 mg B9" } },
  // ── SELENIUM ──
  "selenium::brazil nuts":        { per100g: "1 917 mcg", perUnit: { label: "1 noix du Brésil (≈5 g)", amount: "96 mcg" }, note: "1 à 2 noix par jour suffisent à couvrir l'AJR – au-delà risque de toxicité" },
  "selenium::tuna":               { per100g: "90 mcg", perUnit: { label: "100 g de thon", amount: "90 mcg" } },
  "selenium::sardines":           { per100g: "52 mcg", perUnit: { label: "1 boîte (≈90 g)", amount: "47 mcg" } },
  "selenium::brown rice":         { per100g: "14 mcg", perUnit: { label: "1 tasse cuite (≈195 g)", amount: "27 mcg" } },
  // ── CAROTENOIDS (β-carotène) ──
  "carotenoids::carrots":         { per100g: "8.3 mg β-carotène", perUnit: { label: "1 carotte moy. (≈61 g)", amount: "5.1 mg β-carotène" } },
  "carotenoids::tomatoes":        { per100g: "0.45 mg β-carotène", perUnit: { label: "1 tomate moy. (≈123 g)", amount: "0.55 mg β-carotène" } },
  "carotenoids::sweet potatoes":  { per100g: "8.5 mg β-carotène", perUnit: { label: "1 patate douce moy. (≈130 g)", amount: "11 mg β-carotène" } },
  "carotenoids::papaya":          { per100g: "0.27 mg β-carotène", perUnit: { label: "1 tranche (≈145 g)", amount: "0.39 mg β-carotène" } },
  // ── WATER ──
  "water::water":                 { per100g: "100 ml", perUnit: { label: "1 verre (250 ml)", amount: "250 ml" }, note: "Objectif : 2 à 3 litres par jour toutes sources confondues" },
  "water::cucumber":              { per100g: "96.7 ml eau", perUnit: { label: "1 concombre moy. (≈300 g)", amount: "290 ml eau" } },
  "water::watermelon":            { per100g: "91.4 ml eau", perUnit: { label: "1 tranche (≈280 g)", amount: "256 ml eau" } },
  "water::celery":                { per100g: "95.4 ml eau", perUnit: { label: "1 tige (≈40 g)", amount: "38 ml eau" } },
};

export function getFoodDetail(nutrientId: string, foodName: string): FoodDetail | undefined {
  return FOOD_DETAILS[`${nutrientId}::${foodName.toLowerCase()}`];
}

// ═══════════════════════════════════════════════
// 4) OBJECTIVE ↔ NUTRIENT MAPPING
// ═══════════════════════════════════════════════

export interface ObjectiveNutrient {
  objective_id: string;
  nutrient_id: string;
  priority: "core" | "support";
}

export const OBJECTIVE_NUTRIENTS: ObjectiveNutrient[] = [
  // Hydration
  { objective_id: "hydration", nutrient_id: "electrolytes", priority: "core" },
  { objective_id: "hydration", nutrient_id: "omega3", priority: "core" },
  { objective_id: "hydration", nutrient_id: "vitA", priority: "support" },
  { objective_id: "hydration", nutrient_id: "vitE", priority: "support" },
  { objective_id: "hydration", nutrient_id: "zinc", priority: "support" },
  { objective_id: "hydration", nutrient_id: "water", priority: "core" },
  // Repair
  { objective_id: "repair", nutrient_id: "protein", priority: "core" },
  { objective_id: "repair", nutrient_id: "cysteine", priority: "core" },
  { objective_id: "repair", nutrient_id: "biotin", priority: "core" },
  { objective_id: "repair", nutrient_id: "zinc", priority: "support" },
  { objective_id: "repair", nutrient_id: "iron", priority: "support" },
  { objective_id: "repair", nutrient_id: "vitC", priority: "support" },
  { objective_id: "repair", nutrient_id: "copper", priority: "support" },
  // Scalp Balance
  { objective_id: "scalp", nutrient_id: "zinc", priority: "core" },
  { objective_id: "scalp", nutrient_id: "vitD", priority: "core" },
  { objective_id: "scalp", nutrient_id: "omega3", priority: "support" },
  { objective_id: "scalp", nutrient_id: "bComplex", priority: "core" },
  { objective_id: "scalp", nutrient_id: "selenium", priority: "support" },
  // Protection
  { objective_id: "protection", nutrient_id: "vitC", priority: "core" },
  { objective_id: "protection", nutrient_id: "vitE", priority: "core" },
  { objective_id: "protection", nutrient_id: "carotenoids", priority: "core" },
  { objective_id: "protection", nutrient_id: "omega3", priority: "support" },
  { objective_id: "protection", nutrient_id: "zinc", priority: "support" },
  { objective_id: "protection", nutrient_id: "selenium", priority: "support" },
  // Growth & Hair Loss
  { objective_id: "growth", nutrient_id: "protein", priority: "core" },
  { objective_id: "growth", nutrient_id: "iron", priority: "core" },
  { objective_id: "growth", nutrient_id: "zinc", priority: "core" },
  { objective_id: "growth", nutrient_id: "vitD", priority: "core" },
  { objective_id: "growth", nutrient_id: "omega3", priority: "support" },
  { objective_id: "growth", nutrient_id: "bComplex", priority: "support" },
  // Density & Thickness
  { objective_id: "density", nutrient_id: "protein", priority: "core" },
  { objective_id: "density", nutrient_id: "iron", priority: "core" },
  { objective_id: "density", nutrient_id: "zinc", priority: "support" },
  { objective_id: "density", nutrient_id: "vitD", priority: "support" },
  { objective_id: "density", nutrient_id: "omega3", priority: "support" },
  // Curl Definition
  { objective_id: "curl-definition", nutrient_id: "protein", priority: "core" },
  { objective_id: "curl-definition", nutrient_id: "omega3", priority: "core" },
  { objective_id: "curl-definition", nutrient_id: "zinc", priority: "support" },
];

/** Get nutrients for an objective, sorted by priority */
export function getNutrientsForObjective(objectiveId: string): Array<Nutrient & { priority: "core" | "support" }> {
  const mappings = OBJECTIVE_NUTRIENTS.filter(on => on.objective_id === objectiveId);
  return mappings
    .map(m => {
      const nutrient = NUTRIENTS.find(n => n.id === m.nutrient_id);
      return nutrient ? { ...nutrient, priority: m.priority } : null;
    })
    .filter(Boolean)
    .sort((a, b) => (a!.priority === "core" ? -1 : 1) - (b!.priority === "core" ? -1 : 1)) as Array<Nutrient & { priority: "core" | "support" }>;
}

// ═══════════════════════════════════════════════
// 5) PRODUCT CATEGORIES (TOPICAL)
// ═══════════════════════════════════════════════

export type ProductWeight = "light" | "medium" | "heavy";
export type GenericCategory = "Shampoo" | "Conditioner" | "Mask" | "Leave-in" | "Serum" | "Heat Protectant" | "Styling" | "Oil" | "Treatment";

export interface ProductCategory {
  code: string;
  step: "Cleanse" | "Treat" | "Condition" | "Protect";
  hair_type_group: number;
  name: string;
  generic_category: GenericCategory;
  weight: ProductWeight;
  key_topical_actives: string[];
  objective_tags: string[];
  multi_objective?: boolean;
}

export const PRODUCT_CATEGORIES: ProductCategory[] = [
  // TYPE 1 — light weight products
  { code: "A", step: "Cleanse", hair_type_group: 1, name: "Hydrating Light Shampoo", generic_category: "Shampoo", weight: "light", key_topical_actives: ["Moringa Oil", "Quinoa Protein"], objective_tags: ["hydration"] },
  { code: "B", step: "Condition", hair_type_group: 1, name: "Lightweight Conditioner", generic_category: "Conditioner", weight: "light", key_topical_actives: ["Keratin", "Baobab Oil"], objective_tags: ["hydration"] },
  { code: "C", step: "Treat", hair_type_group: 1, name: "Light Bond Repair Treatment", generic_category: "Treatment", weight: "light", key_topical_actives: ["Bis-Aminopropyl Diglycol Dimaleate", "Light Proteins"], objective_tags: ["repair"] },
  { code: "D", step: "Cleanse", hair_type_group: 1, name: "Scalp Balance Light Shampoo", generic_category: "Shampoo", weight: "light", key_topical_actives: ["Zinc Pyrithione", "Tea Tree"], objective_tags: ["scalp"] },
  { code: "E", step: "Protect", hair_type_group: 1, name: "Heat & UV Light Protector", generic_category: "Heat Protectant", weight: "light", key_topical_actives: ["Dimethicone", "UV Filters", "Vitamin E"], objective_tags: ["protection"] },
  { code: "U", step: "Treat", hair_type_group: 1, name: "Root Volumizing Spray/Mousse", generic_category: "Styling", weight: "light", key_topical_actives: ["Biotin", "Polymers", "Rice Protein"], objective_tags: ["density"] },
  { code: "V1", step: "Treat", hair_type_group: 1, name: "Root Volumizing Spray", generic_category: "Styling", weight: "light", key_topical_actives: ["Biotin", "Polymers", "Rice Protein"], objective_tags: ["volume"] },
  { code: "GL1", step: "Treat", hair_type_group: 1, name: "Lightweight Scalp Serum", generic_category: "Serum", weight: "light", key_topical_actives: ["Caffeine", "Peptides", "Niacinamide"], objective_tags: ["growth"] },

  // TYPE 2 — light to medium weight
  { code: "F", step: "Cleanse", hair_type_group: 2, name: "Gentle Hydrating Shampoo", generic_category: "Shampoo", weight: "light", key_topical_actives: ["Coconut Oil", "Silk Protein", "Neem Oil"], objective_tags: ["hydration", "scalp"], multi_objective: true },
  { code: "G", step: "Condition", hair_type_group: 2, name: "Medium Hydrating Conditioner", generic_category: "Conditioner", weight: "medium", key_topical_actives: ["Argan Oil", "Vitamins A & E"], objective_tags: ["hydration"] },
  { code: "H", step: "Treat", hair_type_group: 2, name: "Hydra+Repair Moderate Mask", generic_category: "Mask", weight: "medium", key_topical_actives: ["K18Peptide™", "Keratin", "Argan Oil"], objective_tags: ["repair", "hydration"] },
  { code: "I", step: "Cleanse", hair_type_group: 2, name: "Soothing Scalp Gentle Shampoo", generic_category: "Shampoo", weight: "light", key_topical_actives: ["Glycolic Acid", "Aloe", "Salicylic Acid"], objective_tags: ["scalp", "scalp-soothing"] },
  { code: "J", step: "Protect", hair_type_group: 2, name: "Heat & UV Light-Medium Protector", generic_category: "Heat Protectant", weight: "medium", key_topical_actives: ["Argan Oil", "UV Filters", "Silk Amino Acids"], objective_tags: ["protection"] },
  { code: "V", step: "Protect", hair_type_group: 2, name: "Light Mousse / Wave Spray", generic_category: "Styling", weight: "light", key_topical_actives: ["Rice Curl Complex", "Hydrolyzed Protein"], objective_tags: ["curl-definition", "frizz-control"] },
  { code: "W", step: "Treat", hair_type_group: 2, name: "Root Densifying Spray", generic_category: "Styling", weight: "light", key_topical_actives: ["Wheat Protein", "Biotin", "Caffeine"], objective_tags: ["density", "volume"] },
  { code: "GL2", step: "Treat", hair_type_group: 2, name: "Light-Medium Scalp Serum", generic_category: "Serum", weight: "light", key_topical_actives: ["Caffeine", "Peptides", "Niacinamide", "Saw Palmetto"], objective_tags: ["growth"] },

  // TYPE 3 — medium to heavy weight
  { code: "K", step: "Cleanse", hair_type_group: 3, name: "Sulfate-Free Hydrating Shampoo", generic_category: "Shampoo", weight: "medium", key_topical_actives: ["Coconut Oil", "Shea Butter", "Aloe"], objective_tags: ["hydration", "scalp"], multi_objective: true },
  { code: "L", step: "Condition", hair_type_group: 3, name: "Rich Moisturizing Conditioner", generic_category: "Conditioner", weight: "heavy", key_topical_actives: ["Shea Butter", "Castor Oil", "Jojoba"], objective_tags: ["hydration"] },
  { code: "M", step: "Treat", hair_type_group: 3, name: "Deep Repair Mask", generic_category: "Mask", weight: "heavy", key_topical_actives: ["Rosehip Oil", "Algae", "B-Vitamins", "Keratin"], objective_tags: ["repair", "hydration"], multi_objective: true },
  { code: "N", step: "Cleanse", hair_type_group: 3, name: "Sensitive Scalp Shampoo", generic_category: "Shampoo", weight: "medium", key_topical_actives: ["Tea Tree Oil", "Aloe Vera", "Zinc"], objective_tags: ["scalp", "scalp-soothing"] },
  { code: "O", step: "Protect", hair_type_group: 3, name: "Leave-In + Heat Protector", generic_category: "Leave-in", weight: "medium", key_topical_actives: ["Argan Oil", "Silk Protein", "UV Filters"], objective_tags: ["protection", "frizz-control"] },
  { code: "X", step: "Protect", hair_type_group: 3, name: "Defining Cream + Medium Gel", generic_category: "Styling", weight: "medium", key_topical_actives: ["Aloe", "Flaxseed", "Coconut Oil"], objective_tags: ["curl-definition", "frizz-control"] },
  { code: "Y", step: "Treat", hair_type_group: 3, name: "Thickening Cream + Light Gel", generic_category: "Styling", weight: "medium", key_topical_actives: ["Jojoba", "Cactus Extract", "Biotin"], objective_tags: ["density"] },
  { code: "GL3", step: "Treat", hair_type_group: 3, name: "Hydrating Scalp Serum", generic_category: "Serum", weight: "medium", key_topical_actives: ["Caffeine", "Peptides", "Niacinamide", "Jojoba Oil"], objective_tags: ["growth"] },

  // TYPE 4 — heavy weight
  { code: "P", step: "Cleanse", hair_type_group: 4, name: "Ultra Gentle Cleanser / Co-Wash", generic_category: "Shampoo", weight: "heavy", key_topical_actives: ["Coconut Oil", "Honey", "Aloe Vera"], objective_tags: ["hydration", "scalp"], multi_objective: true },
  { code: "Q", step: "Condition", hair_type_group: 4, name: "Very Rich Deep Conditioner", generic_category: "Conditioner", weight: "heavy", key_topical_actives: ["Pomegranate Extract", "Honey", "Babassu Oil"], objective_tags: ["hydration"] },
  { code: "R", step: "Treat", hair_type_group: 4, name: "Deep Structuring Treatment", generic_category: "Mask", weight: "heavy", key_topical_actives: ["Hydrolyzed Collagen", "Keratin", "Raw Honey"], objective_tags: ["repair", "hydration"], multi_objective: true },
  { code: "S", step: "Cleanse", hair_type_group: 4, name: "Soothing Nourishing Scalp Cleanser", generic_category: "Shampoo", weight: "heavy", key_topical_actives: ["Zinc Pyrithione", "Tea Tree Oil", "Shea Butter"], objective_tags: ["scalp", "scalp-soothing"] },
  { code: "T", step: "Protect", hair_type_group: 4, name: "Leave-In Cream + Sealing Oil", generic_category: "Leave-in", weight: "heavy", key_topical_actives: ["Jamaican Black Castor Oil", "Shea Butter", "Vitamin E"], objective_tags: ["protection", "frizz-control"] },
  { code: "Z", step: "Protect", hair_type_group: 4, name: "Rich Leave-In + Strong Gel + Light Oil", generic_category: "Styling", weight: "heavy", key_topical_actives: ["Olive Oil", "Flaxseed", "Marshmallow Root"], objective_tags: ["curl-definition"] },
  { code: "AA", step: "Treat", hair_type_group: 4, name: "Structuring Cream + Sealing Oil", generic_category: "Oil", weight: "heavy", key_topical_actives: ["Castor Oil", "Shea Butter", "Biotin"], objective_tags: ["density"] },
  { code: "GL4", step: "Treat", hair_type_group: 4, name: "Nourishing Scalp Serum / Oil-Based Scalp Tonic", generic_category: "Serum", weight: "heavy", key_topical_actives: ["Caffeine", "Peptides", "Niacinamide", "Castor Oil", "Peppermint"], objective_tags: ["growth"] },
];

/** Get product categories for a hair type + objective */
export function getProductCategoriesForProfile(hairType: number, objectiveId: string): ProductCategory[] {
  return PRODUCT_CATEGORIES.filter(
    pc => pc.hair_type_group === hairType && pc.objective_tags.includes(objectiveId)
  );
}

/** Get all product categories for a hair type across all active objectives */
export function getAllCategoriesForProfile(profile: HairProfile): ProductCategory[] {
  const activeObjectives = ["hydration", "repair", "scalp", "protection"];
  if (profile.additionalObjective) activeObjectives.push(profile.additionalObjective);
  
  const seen = new Set<string>();
  const result: ProductCategory[] = [];
  for (const obj of activeObjectives) {
    for (const pc of PRODUCT_CATEGORIES) {
      if (pc.hair_type_group === profile.hairType && pc.objective_tags.includes(obj) && !seen.has(pc.code)) {
        seen.add(pc.code);
        result.push(pc);
      }
    }
  }
  return result;
}

// ═══════════════════════════════════════════════
// 6) AMAZON PRODUCT (SCAFFOLD)
// ═══════════════════════════════════════════════

export interface AmazonProduct {
  id: string;
  title: string;
  brand: string;
  image_url: string;
  price_tier: "budget" | "mid" | "premium";
  amazon_affiliate_url: string;
  amazon_url_clean: string;
  asin: string | null;
  product_category_code: string;
  key_actives: string[];
  notes_short: string;
  weight: ProductWeight;
  hair_types: number[];
  is_duplicate_url: boolean;
  status: "active" | "missing" | "needs_review" | "not_applicable";
  tags: string[];
}

// Placeholder products mapped to product category codes
export const AMAZON_PRODUCTS: AmazonProduct[] = [
  // ═══ TYPE 1 — Lightweight products for fine/straight hair ═══
  { id: "a1", title: "KÉRASTASE Gloss Absolu Bain Hydra-Glaze", brand: "Kérastase", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "premium", amazon_affiliate_url: "https://www.amazon.fr/K%C3%89RASTASE-Gloss-Absolu-Hydra-Illuminant-Hyaluronique/dp/B0G7J7JXKV", amazon_url_clean: "https://www.amazon.fr/dp/B0G7J7JXKV", asin: "B0G7J7JXKV", product_category_code: "A", key_actives: ["Hyaluronic Acid", "Gloss Complex"], notes_short: "Lightweight hydrating shampoo for fine hair", weight: "light", hair_types: [1, 2], is_duplicate_url: false, status: "active", tags: ["lightweight", "hydrating", "fine hair", "gloss"] },
  { id: "b1", title: "Les Secrets de Loly Pink Paradise", brand: "Les Secrets de Loly", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/SECRETS-LOLY-Pink-Paradise-Apr%C3%A8s-Shampoing/dp/B017KGU7LS", amazon_url_clean: "https://www.amazon.fr/dp/B017KGU7LS", asin: "B017KGU7LS", product_category_code: "B", key_actives: ["Detangling Agents", "Hydrating Complex"], notes_short: "Light detangling conditioner for fine hair", weight: "light", hair_types: [1, 2], is_duplicate_url: false, status: "active", tags: ["conditioner", "detangling", "hydration"] },
  { id: "c1", title: "Olaplex No.3 Hair Perfector", brand: "Olaplex", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "premium", amazon_affiliate_url: "https://www.amazon.fr/Olaplex-Perfector-capillaire-perfecteur-r%C3%A9parateur/dp/B08TWTQDCX", amazon_url_clean: "https://www.amazon.fr/dp/B08TWTQDCX", asin: "B08TWTQDCX", product_category_code: "C", key_actives: ["Bis-Aminopropyl Diglycol Dimaleate"], notes_short: "Bond repair treatment for all hair types", weight: "light", hair_types: [1, 2, 3, 4], is_duplicate_url: false, status: "active", tags: ["bond repair", "treatment", "strengthening"] },
  { id: "d1", title: "Uriage DS Hair Shampooing Doux Équilibrant", brand: "Uriage", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/Uriage-Hair-Shampooing-Doux-Equilibrant/dp/B0849VSLYK", amazon_url_clean: "https://www.amazon.fr/dp/B0849VSLYK", asin: "B0849VSLYK", product_category_code: "D", key_actives: ["Zinc Pyrithione", "Gentle Surfactants"], notes_short: "Gentle scalp-balancing shampoo", weight: "light", hair_types: [1, 2], is_duplicate_url: false, status: "active", tags: ["scalp balance", "gentle", "sensitive scalp"] },
  { id: "e1", title: "L'Oréal Paris Thermo-Protecteur 230°", brand: "L'Oréal Paris", image_url: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/LOr%C3%A9al-Paris-Protecteur-Ch%C3%A2leur-Anti-Frisottis/dp/B0CDH9D6J9", amazon_url_clean: "https://www.amazon.fr/dp/B0CDH9D6J9", asin: "B0CDH9D6J9", product_category_code: "E", key_actives: ["Heat Shield Complex", "UV Filters"], notes_short: "Heat protection spray for daily styling", weight: "light", hair_types: [1, 2], is_duplicate_url: false, status: "active", tags: ["heat protectant", "lightweight", "UV"] },
  { id: "gl1_1", title: "Briogeo Destined for Density MegaStrength+", brand: "Briogeo", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "premium", amazon_affiliate_url: "https://www.amazon.fr/Briogeo-MegaStrength-l%C3%A9paisseur-absorption-V%C3%A9g%C3%A9talien/dp/B0BS71XY2M", amazon_url_clean: "https://www.amazon.fr/dp/B0BS71XY2M", asin: "B0BS71XY2M", product_category_code: "GL1", key_actives: ["Peptides", "Biotin", "Caffeine"], notes_short: "Lightweight scalp serum for hair growth", weight: "light", hair_types: [1], is_duplicate_url: false, status: "active", tags: ["density", "scalp serum", "peptides", "growth"] },
  { id: "u1", title: "Redken Root Lifter Volumisant Racines", brand: "Redken", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/Redken-Volumisant-Racines-dEffet-Cheveux/dp/B0BGHPGL92", amazon_url_clean: "https://www.amazon.fr/dp/B0BGHPGL92", asin: "B0BGHPGL92", product_category_code: "U", key_actives: ["Biotin", "Volumizing Polymers"], notes_short: "Root volumizing spray for density", weight: "light", hair_types: [1, 2], is_duplicate_url: false, status: "active", tags: ["root volume", "density", "fine hair"] },
  { id: "v1_1", title: "Redken Root Lifter Volumisant Racines", brand: "Redken", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/Redken-Volumisant-Racines-dEffet-Cheveux/dp/B0BGHPGL92", amazon_url_clean: "https://www.amazon.fr/dp/B0BGHPGL92", asin: "B0BGHPGL92", product_category_code: "V1", key_actives: ["Biotin", "Volumizing Polymers"], notes_short: "Root volumizing spray for body and lift", weight: "light", hair_types: [1], is_duplicate_url: true, status: "active", tags: ["volume", "roots", "lightweight"] },

  // ═══ TYPE 2 — Light to medium for wavy hair ═══
  { id: "f1", title: "Dessange Hydra-Apaisant", brand: "Dessange", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/DESSANGE-Shampoing-Hydra-Apaisant-Niacinamide-D%C3%A9shydrat%C3%A9s/dp/B0FH73BNNY", amazon_url_clean: "https://www.amazon.fr/dp/B0FH73BNNY", asin: "B0FH73BNNY", product_category_code: "F", key_actives: ["Niacinamide", "Hydrating Complex"], notes_short: "Gentle hydrating shampoo for wavy hair", weight: "light", hair_types: [2], is_duplicate_url: false, status: "active", tags: ["hydrating", "medium-light", "wavy hair"] },
  { id: "g1", title: "Creme of Nature Argan Oil Intensive Conditioning Treatment", brand: "Creme of Nature", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/Creme-Nature-Shampooing-Hydratant-D%C3%A9m%C3%AAlant/dp/B004YRVCGQ", amazon_url_clean: "https://www.amazon.fr/dp/B004YRVCGQ", asin: "B004YRVCGQ", product_category_code: "G", key_actives: ["Argan Oil", "Vitamins A & E"], notes_short: "Medium hydrating conditioner for waves", weight: "medium", hair_types: [2, 3], is_duplicate_url: false, status: "active", tags: ["hydration", "conditioner", "medium"] },
  { id: "h1", title: "Dessange Masque Reconstructeur Kératine", brand: "Dessange", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/DESSANGE-Reconstructeur-K%C3%A9ratine-Hyaluronique-Capillaire/dp/B0F99L61JF", amazon_url_clean: "https://www.amazon.fr/dp/B0F99L61JF", asin: "B0F99L61JF", product_category_code: "H", key_actives: ["Keratin", "Hyaluronic Acid"], notes_short: "Keratin repair mask for damaged waves", weight: "medium", hair_types: [2, 3], is_duplicate_url: false, status: "active", tags: ["repair", "keratin", "mask"] },
  { id: "i1", title: "Dessange Hydra-Apaisant", brand: "Dessange", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/DESSANGE-Shampoing-Hydra-Apaisant-Niacinamide-D%C3%A9shydrat%C3%A9s/dp/B0FH73BNNY", amazon_url_clean: "https://www.amazon.fr/dp/B0FH73BNNY", asin: "B0FH73BNNY", product_category_code: "I", key_actives: ["Niacinamide", "Soothing Complex"], notes_short: "Soothing scalp cleanser for wavy hair", weight: "light", hair_types: [2], is_duplicate_url: true, status: "active", tags: ["soothing scalp", "gentle cleanse"] },
  { id: "j1", title: "Schwarzkopf Spray Protection 230°C", brand: "Schwarzkopf", image_url: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/SCHWARZKOPF-Protection-dAbricot-sensibilis%C3%A9s-fourchues/dp/B0DZJ1KJRR", amazon_url_clean: "https://www.amazon.fr/dp/B0DZJ1KJRR", asin: "B0DZJ1KJRR", product_category_code: "J", key_actives: ["Apricot Oil", "Heat Shield"], notes_short: "Heat protection spray for wavy hair", weight: "medium", hair_types: [2], is_duplicate_url: false, status: "active", tags: ["heat protectant", "medium-light"] },
  { id: "gl2_1", title: "Energie Fruit Sérum Cuir Chevelu Rééquilibrant", brand: "Energie Fruit", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/ENERGIE-FRUIT-r%C3%A9%C3%A9quilibrant-hydratante-instantan%C3%A9ment/dp/B0DT9S1L7B", amazon_url_clean: "https://www.amazon.fr/dp/B0DT9S1L7B", asin: "B0DT9S1L7B", product_category_code: "GL2", key_actives: ["Balancing Agents", "Hydrating Serum"], notes_short: "Scalp serum for growth and balance", weight: "light", hair_types: [2], is_duplicate_url: false, status: "active", tags: ["scalp serum", "growth", "balancing"] },
  { id: "w1", title: "Kerargan Spray Épaississant Collagène", brand: "Kerargan", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/Kerargan-Collag%C3%A8ne-Redonner-Maintenir-Brillance/dp/B0BS1QGTL1", amazon_url_clean: "https://www.amazon.fr/dp/B0BS1QGTL1", asin: "B0BS1QGTL1", product_category_code: "W", key_actives: ["Collagen", "Thickening Polymers"], notes_short: "Thickening spray for fine wavy hair", weight: "light", hair_types: [2], is_duplicate_url: false, status: "active", tags: ["thickening", "spray", "medium"] },
  { id: "v2_1", title: "Creme of Nature Moisture Whip Twisting Cream", brand: "Creme of Nature", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/Creme-Nature-Moisture-Twisting-Cream/dp/B07B541D8P", amazon_url_clean: "https://www.amazon.fr/dp/B07B541D8P", asin: "B07B541D8P", product_category_code: "V", key_actives: ["Argan Oil", "Twisting Butter"], notes_short: "Curl defining cream for wavy hair", weight: "medium", hair_types: [2], is_duplicate_url: false, status: "active", tags: ["curl definition", "cream", "medium"] },

  // ═══ TYPE 3 — Medium to rich for curly hair ═══
  { id: "k1", title: "Lavera Shampooing Fraîcheur & Équilibre", brand: "Lavera", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/lavera-Shampooing-Fra%C3%AEcheur-%C3%89quilibre-Capillaires/dp/B08X57GHDB", amazon_url_clean: "https://www.amazon.fr/dp/B08X57GHDB", asin: "B08X57GHDB", product_category_code: "K", key_actives: ["Natural Extracts", "Gentle Cleansers"], notes_short: "Sulfate-free hydrating shampoo for curls", weight: "medium", hair_types: [3], is_duplicate_url: false, status: "active", tags: ["sulfate-free", "clean", "hydration"] },
  { id: "l1", title: "Lavera Après-shampooing Réparateur & Soin Profond", brand: "Lavera", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/lavera-Apr%C3%A8s-shampooing-R%C3%A9parateur-Capillaires-Cosm%C3%A9tiques/dp/B0869F26V6", amazon_url_clean: "https://www.amazon.fr/dp/B0869F26V6", asin: "B0869F26V6", product_category_code: "L", key_actives: ["Repair Complex", "Deep Moisture"], notes_short: "Rich moisturizing conditioner for curls", weight: "heavy", hair_types: [3, 4], is_duplicate_url: false, status: "active", tags: ["rich conditioner", "moisture", "repair"] },
  { id: "m1", title: "L'Oréal Professionnel Pro Longer Mask", brand: "L'Oréal Professionnel", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/LOr%C3%A9al-Professionnel-R%C3%A9novateur-Longueurs-Cheveux/dp/B0968VX473", amazon_url_clean: "https://www.amazon.fr/dp/B0968VX473", asin: "B0968VX473", product_category_code: "M", key_actives: ["Filler-A100", "Amino Acids"], notes_short: "Deep repair mask for curly hair", weight: "heavy", hair_types: [3, 4], is_duplicate_url: false, status: "active", tags: ["repair", "mask", "strengthening"] },
  { id: "n1", title: "Kérastase Spécifique Bain Dermo-Calm", brand: "Kérastase", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "premium", amazon_affiliate_url: "https://www.amazon.fr/K%C3%A9rastase-Sp%C3%A9cifique-Shampoing-Hydra-Apaisant-Dermo-Calm/dp/B01HYOB0LC", amazon_url_clean: "https://www.amazon.fr/dp/B01HYOB0LC", asin: "B01HYOB0LC", product_category_code: "N", key_actives: ["Calming Complex", "Gentle Surfactants"], notes_short: "Sensitive scalp shampoo for curly hair", weight: "medium", hair_types: [3], is_duplicate_url: false, status: "active", tags: ["sensitive scalp", "soothing cleanse"] },
  { id: "o1", title: "Redken One United", brand: "Redken", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/Rin%C3%A7age-Multi-B%C3%A9n%C3%A9fices-Thermo-Protecteur-Cheveux-Paraben/dp/B00YO38G4Q", amazon_url_clean: "https://www.amazon.fr/dp/B00YO38G4Q", asin: "B00YO38G4Q", product_category_code: "O", key_actives: ["Multi-benefit Complex", "Heat Shield"], notes_short: "Leave-in heat protector for curls", weight: "medium", hair_types: [3], is_duplicate_url: false, status: "active", tags: ["leave-in", "heat protectant", "multifunction"] },
  { id: "gl3_1", title: "Generic Peptide Scalp Serum", brand: "Generic", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/capillaire-chevelu-peptide-brillance-hydratation/dp/B0GFDHCT9L", amazon_url_clean: "https://www.amazon.fr/dp/B0GFDHCT9L", asin: "B0GFDHCT9L", product_category_code: "GL3", key_actives: ["Peptides", "Hydrating Serum"], notes_short: "Hydrating scalp serum for hair growth", weight: "medium", hair_types: [3], is_duplicate_url: false, status: "active", tags: ["peptide serum", "scalp", "hydration"] },
  { id: "y1", title: "Weleda Lotion Capillaire Tonifiante", brand: "Weleda", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/WELEDA-capillaire-tonifiante-Ralentit-croissance/dp/B00ANYARFG", amazon_url_clean: "https://www.amazon.fr/dp/B00ANYARFG", asin: "B00ANYARFG", product_category_code: "Y", key_actives: ["Rosemary", "Tonic Complex"], notes_short: "Thickening scalp tonic for curls", weight: "medium", hair_types: [3], is_duplicate_url: false, status: "active", tags: ["tonic", "thickness", "scalp lotion"] },
  { id: "x1", title: "Creme of Nature Moisture Whip Twisting Cream", brand: "Creme of Nature", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/Creme-Nature-Moisture-Twisting-Cream/dp/B07B541D8P", amazon_url_clean: "https://www.amazon.fr/dp/B07B541D8P", asin: "B07B541D8P", product_category_code: "X", key_actives: ["Argan Oil", "Twisting Butter"], notes_short: "Defining cream for curly hair", weight: "medium", hair_types: [3], is_duplicate_url: true, status: "active", tags: ["curl definition", "cream", "richer"] },

  // ═══ TYPE 4 — Rich/heavy for coily/kinky hair ═══
  { id: "p1", title: "As I Am Coconut CoWash", brand: "As I Am", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/Coconut-CoWash-16oz-peter-namrongput/dp/B008DFR2UU", amazon_url_clean: "https://www.amazon.fr/dp/B008DFR2UU", asin: "B008DFR2UU", product_category_code: "P", key_actives: ["Coconut Oil", "Gentle Cleansers"], notes_short: "Ultra gentle co-wash for coily hair", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "active", tags: ["co-wash", "ultra gentle", "rich hydration"] },
  { id: "q1", title: "Kérastase Nutritive Masquintense", brand: "Kérastase", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "premium", amazon_affiliate_url: "https://www.amazon.fr/K%C3%A9rastase-Nutritive-Nourrissant-Cheveux-Masquintense/dp/B0BZZK3R5S", amazon_url_clean: "https://www.amazon.fr/dp/B0BZZK3R5S", asin: "B0BZZK3R5S", product_category_code: "Q", key_actives: ["Nourishing Complex", "Intense Moisture"], notes_short: "Very rich deep conditioner for coils", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "active", tags: ["very rich", "deep conditioning", "intense moisture"] },
  { id: "r1", title: "L'Oréal Professionnel Absolut Repair Molecular", brand: "L'Oréal Professionnel", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/LOr%C3%A9al-Professionnel-Concentr%C3%A9-R%C3%A9parateur-Souplesse/dp/B0D7NZ3N7P", amazon_url_clean: "https://www.amazon.fr/dp/B0D7NZ3N7P", asin: "B0D7NZ3N7P", product_category_code: "R", key_actives: ["Molecular Repair Complex", "Amino Acids"], notes_short: "Deep molecular repair for coily hair", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "active", tags: ["molecular repair", "deep repair"] },
  { id: "s1", title: "Placeholder — Soothing Nourishing Scalp Cleanser", brand: "—", image_url: "", price_tier: "mid", amazon_affiliate_url: "#", amazon_url_clean: "#", asin: null, product_category_code: "S", key_actives: [], notes_short: "Soothing nourishing scalp cleanser — product still missing", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "missing", tags: [] },
  { id: "t1", title: "L'Oréal Professionnel Curl Expression Crème-en-Gelée Leave-In", brand: "L'Oréal Professionnel", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/LOREAL-PROFESSIONNEL-Cr%C3%A8me-en-Gel%C3%A9e-Leave-Thermoprotecteur/dp/B09W6JLZPH", amazon_url_clean: "https://www.amazon.fr/dp/B09W6JLZPH", asin: "B09W6JLZPH", product_category_code: "T", key_actives: ["Curl Complex", "Heat Protection"], notes_short: "Rich leave-in cream with heat protection", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "active", tags: ["leave-in", "heat protection", "rich styling"] },
  { id: "gl4_1", title: "Sunny Isle Jamaican Black Castor Oil Extra Dark", brand: "Sunny Isle", image_url: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=200&h=200&fit=crop", price_tier: "budget", amazon_affiliate_url: "https://www.amazon.fr/Jamaican-Black-Castor-Extra-Dark/dp/B003KFFGVA", amazon_url_clean: "https://www.amazon.fr/dp/B003KFFGVA", asin: "B003KFFGVA", product_category_code: "GL4", key_actives: ["Jamaican Black Castor Oil"], notes_short: "Nourishing scalp oil for hair growth", weight: "heavy", hair_types: [4], is_duplicate_url: false, status: "active", tags: ["castor oil", "scalp tonic", "growth", "rich"] },
  { id: "aa1", title: "Weleda Lotion Capillaire Tonifiante", brand: "Weleda", image_url: "https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/WELEDA-capillaire-tonifiante-Ralentit-croissance/dp/B00ANYARFG", amazon_url_clean: "https://www.amazon.fr/dp/B00ANYARFG", asin: "B00ANYARFG", product_category_code: "AA", key_actives: ["Rosemary", "Tonic Complex"], notes_short: "Scalp tonic for coil density and thickness", weight: "heavy", hair_types: [4], is_duplicate_url: true, status: "active", tags: ["tonic", "thickness", "density"] },
  { id: "z1", title: "L'Oréal Professionnel Curl Expression Crème-en-Gelée Leave-In", brand: "L'Oréal Professionnel", image_url: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=200&h=200&fit=crop", price_tier: "mid", amazon_affiliate_url: "https://www.amazon.fr/LOREAL-PROFESSIONNEL-Cr%C3%A8me-en-Gel%C3%A9e-Leave-Thermoprotecteur/dp/B09W6JLZPH", amazon_url_clean: "https://www.amazon.fr/dp/B09W6JLZPH", asin: "B09W6JLZPH", product_category_code: "Z", key_actives: ["Curl Complex", "Sealing Agents"], notes_short: "Rich leave-in for curl definition and sealing", weight: "heavy", hair_types: [4], is_duplicate_url: true, status: "active", tags: ["curl definition", "leave-in", "sealing"] },
];

/** Get Amazon products for a product category code, sorted by price tier */
const tierOrder: Record<string, number> = { budget: 0, mid: 1, premium: 2 };
export function getAmazonProductsForCode(code: string): AmazonProduct[] {
  return AMAZON_PRODUCTS
    .filter(p => p.product_category_code === code)
    .sort((a, b) => tierOrder[a.price_tier] - tierOrder[b.price_tier]);
}

// ═══════════════════════════════════════════════
// 6b) SMART FILTERING LOGIC
// ═══════════════════════════════════════════════

/** Weight compatibility by hair type: which weights are allowed */
const WEIGHT_COMPAT: Record<number, ProductWeight[]> = {
  1: ["light"],
  2: ["light", "medium"],
  3: ["light", "medium", "heavy"],
  4: ["light", "medium", "heavy"],
};

/** Get allowed weights for a hair type */
export function getAllowedWeights(hairType: number): ProductWeight[] {
  return WEIGHT_COMPAT[hairType] || ["light", "medium", "heavy"];
}

/** Smart filter: products compatible with hair type by weight */
export function getFilteredProducts(hairType: number, objectiveId: string): AmazonProduct[] {
  const allowedWeights = getAllowedWeights(hairType);
  const categories = getProductCategoriesForProfile(hairType, objectiveId);
  const categoryCodes = new Set(categories.map(c => c.code));

  return AMAZON_PRODUCTS
    .filter(p =>
      p.status === "active" &&
      categoryCodes.has(p.product_category_code) &&
      p.hair_types.includes(hairType) &&
      allowedWeights.includes(p.weight)
    )
    .sort((a, b) => {
      // Sort by: hair type relevance (exact match first), then price tier
      const aRelevance = a.hair_types[0] === hairType ? 0 : 1;
      const bRelevance = b.hair_types[0] === hairType ? 0 : 1;
      if (aRelevance !== bRelevance) return aRelevance - bRelevance;
      return tierOrder[a.price_tier] - tierOrder[b.price_tier];
    });
}

/** Get filtered products grouped by generic category, deduplicated */
export function getSmartProductsForObjective(
  hairType: number,
  objectiveId: string
): { category: GenericCategory; products: AmazonProduct[]; catInfo: ProductCategory }[] {
  const categories = getProductCategoriesForProfile(hairType, objectiveId);
  const allowedWeights = getAllowedWeights(hairType);
  const seenProductIds = new Set<string>();
  const result: { category: GenericCategory; products: AmazonProduct[]; catInfo: ProductCategory }[] = [];

  for (const cat of categories) {
    const products = AMAZON_PRODUCTS
      .filter(p =>
        p.product_category_code === cat.code &&
        p.status === "active" &&
        p.hair_types.includes(hairType) &&
        allowedWeights.includes(p.weight) &&
        !seenProductIds.has(p.id)
      )
      .sort((a, b) => tierOrder[a.price_tier] - tierOrder[b.price_tier])
      .slice(0, 3); // Max 3 per category

    products.forEach(p => seenProductIds.add(p.id));
    result.push({ category: cat.generic_category, products, catInfo: cat });
  }

  return result;
}

// ═══════════════════════════════════════════════
// 7) HAIR TYPES
// ═══════════════════════════════════════════════

export const HAIR_TYPES = [
  { type: 1, label: "Straight", desc: "Straight hair, no visible wave.", subtypes: [
    { letter: "A", desc: "Fine & flat, hard to curl" },
    { letter: "B", desc: "Medium body, slight bend" },
    { letter: "C", desc: "Coarse, full body" },
  ]},
  { type: 2, label: "Wavy", desc: "Defined waves.", subtypes: [
    { letter: "A", desc: "Loose, barely-there waves" },
    { letter: "B", desc: "Defined S-shaped waves" },
    { letter: "C", desc: "Strong waves, close to curls" },
  ]},
  { type: 3, label: "Curly", desc: "Visible curls.", subtypes: [
    { letter: "A", desc: "Loose spiral curls" },
    { letter: "B", desc: "Springy defined curls" },
    { letter: "C", desc: "Tight corkscrew curls" },
  ]},
  { type: 4, label: "Coily / Kinky", desc: "Tight coils or zig-zag pattern.", subtypes: [
    { letter: "A", desc: "Soft, defined coil pattern" },
    { letter: "B", desc: "Z-shaped, less defined" },
    { letter: "C", desc: "Very tight, densely packed" },
  ]},
];

// ═══════════════════════════════════════════════
// 8) ROUTINE GENERATION (DATABASE-DRIVEN)
// ═══════════════════════════════════════════════

export interface RoutineStep {
  step: number;
  action: string;
  product: string;
  productCategoryCode: string;
  why: string;
  duration: string;
  objectives: string[];
}

export function getRoutineForProfile(profile: HairProfile): RoutineStep[] {
  const t = profile.hairType;
  const steps: RoutineStep[] = [];
  const cats = getAllCategoriesForProfile(profile);

  // Find category helper
  const findCat = (step: string, objPref?: string): ProductCategory | undefined => {
    if (objPref) {
      const match = cats.find(c => c.step === step && c.objective_tags.includes(objPref));
      if (match) return match;
    }
    return cats.find(c => c.step === step);
  };

  // Step 1: Cleanse (prefer hydration-tagged cleanse)
  const cleanCat = findCat("Cleanse", "hydration") || findCat("Cleanse");
  if (cleanCat) {
    const products = getAmazonProductsForCode(cleanCat.code);
    steps.push({
      step: 1, action: "Cleanse", product: products[0]?.title || cleanCat.name,
      productCategoryCode: cleanCat.code,
      why: `${cleanCat.name} adapted for Type ${t} hair`,
      duration: "3–5 min, focus on scalp",
      objectives: cleanCat.objective_tags.map(t => OBJECTIVES.find(o => o.id === t)?.name || t),
    });
  }

  // Step 2: Treat
  const treatCat = findCat("Treat", "repair") || findCat("Treat");
  if (treatCat) {
    const products = getAmazonProductsForCode(treatCat.code);
    steps.push({
      step: 2, action: "Treat", product: products[0]?.title || treatCat.name,
      productCategoryCode: treatCat.code,
      why: `${treatCat.name} for structural recovery`,
      duration: "10–15 min under cap",
      objectives: treatCat.objective_tags.map(t => OBJECTIVES.find(o => o.id === t)?.name || t),
    });
  }

  // Step 3: Condition
  const condCat = findCat("Condition");
  if (condCat) {
    const products = getAmazonProductsForCode(condCat.code);
    steps.push({
      step: 3, action: "Condition", product: products[0]?.title || condCat.name,
      productCategoryCode: condCat.code,
      why: `${condCat.name} for moisture and detangling`,
      duration: t <= 2 ? "3–5 min, mid-lengths to ends" : "Apply generously, do not rinse",
      objectives: condCat.objective_tags.map(t => OBJECTIVES.find(o => o.id === t)?.name || t),
    });
  }

  // Step 4: Protect
  const protCat = findCat("Protect", "protection") || findCat("Protect");
  if (protCat) {
    const products = getAmazonProductsForCode(protCat.code);
    steps.push({
      step: 4, action: "Protect", product: products[0]?.title || protCat.name,
      productCategoryCode: protCat.code,
      why: `${protCat.name} to seal and shield`,
      duration: "Apply 2–3 drops to ends",
      objectives: protCat.objective_tags.map(t => OBJECTIVES.find(o => o.id === t)?.name || t),
    });
  }

  // Additional objective add-on step
  if (profile.additionalObjective) {
    const addOnCodes: Record<string, Record<number, string>> = {
      "growth": { 1: "GL1", 2: "GL2", 3: "GL3", 4: "GL4" },
      "density": { 1: "U", 2: "W", 3: "Y", 4: "AA" },
      "curl-definition": { 1: "V", 2: "V", 3: "X", 4: "Z" },
      "volume": { 1: "V1", 2: "W" },
    };
    const addCode = addOnCodes[profile.additionalObjective]?.[t];
    if (addCode) {
      const addCat = PRODUCT_CATEGORIES.find(c => c.code === addCode);
      if (addCat) {
        const products = getAmazonProductsForCode(addCode);
        const addObjName = OBJECTIVES.find(o => o.id === profile.additionalObjective)?.name || "";
        steps.push({
          step: steps.length + 1,
          action: `${addObjName} Add-On`,
          product: products[0]?.title || addCat.name,
          productCategoryCode: addCat.code,
          why: `${addCat.name} — targeted ${addObjName.toLowerCase()} support`,
          duration: "Apply as directed",
          objectives: [addObjName],
        });
      }
    }
  }

  return steps;
}

// ═══════════════════════════════════════════════
// 9) WEEK PLAN
// ═══════════════════════════════════════════════

export interface DayPlan {
  type: "wash" | "rest" | "treatment" | "oil";
  label: string;
  objectives: string[];
  actions: string[];
}

export function getWeekPlan(profile: HairProfile): Record<string, DayPlan> {
  const addObj = profile.additionalObjective
    ? ADDITIONAL_OBJECTIVES.find(a => a.id === profile.additionalObjective)?.name || null
    : null;

  const washObjectives = ["Hydration", "Scalp Balance", "Repair", "Protection"];
  const washActions = ["Cleanse", "Condition", "Protect"];
  const treatmentObjectives = ["Repair", "Hydration"];
  const treatmentActions = ["Treat", "Condition"];
  const oilObjectives = ["Protection", "Hydration"];
  const oilActions = ["Oil Seal", "Protect"];
  const restObjectives = ["Protection"];
  const restActions: string[] = [];

  if (addObj) {
    washObjectives.push(addObj);
    treatmentObjectives.push(addObj);
  }

  if (profile.additionalObjective) {
    const addOnLabel = addObj || "";
    washActions.push(`${addOnLabel} Add-On`);
  }

  if (profile.hairType <= 2) {
    return {
      Mon: { type: "wash", label: "Wash Day", objectives: [...washObjectives], actions: [...washActions] },
      Tue: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
      Wed: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
      Thu: { type: "treatment", label: "Treatment Day", objectives: [...treatmentObjectives], actions: [...treatmentActions] },
      Fri: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
      Sat: { type: "wash", label: "Wash Day", objectives: [...washObjectives], actions: [...washActions] },
      Sun: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
    };
  }
  return {
    Mon: { type: "wash", label: "Wash Day", objectives: [...washObjectives], actions: [...washActions] },
    Tue: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
    Wed: { type: "treatment", label: "Deep Treatment", objectives: [...treatmentObjectives], actions: [...treatmentActions] },
    Thu: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
    Fri: { type: "oil", label: "Oil Seal Day", objectives: [...oilObjectives], actions: [...oilActions] },
    Sat: { type: "wash", label: "Wash Day", objectives: [...washObjectives], actions: [...washActions] },
    Sun: { type: "rest", label: "Rest Day", objectives: [...restObjectives], actions: [...restActions] },
  };
}

// ═══════════════════════════════════════════════
// 10) LOCALSTORAGE HELPERS
// ═══════════════════════════════════════════════

const PROFILE_KEY = "hhc-profile";

export function saveProfile(profile: HairProfile) {
  localStorage.setItem(PROFILE_KEY, JSON.stringify(profile));
  localStorage.setItem("hhc-onboarded", "true");
}

export function loadProfile(): HairProfile | null {
  const raw = localStorage.getItem(PROFILE_KEY);
  if (!raw) return null;
  try { return JSON.parse(raw); } catch { return null; }
}

// Legacy compat exports
export function getProductsForType(hairType: number, objective: string): Array<{ name: string; category: string; why: string; ingredients: string[]; bestFor: string; image: string }> {
  const cats = PRODUCT_CATEGORIES.filter(pc => pc.hair_type_group === hairType && pc.objective_tags.includes(objective));
  return cats.flatMap(cat => {
    const products = getAmazonProductsForCode(cat.code);
    if (products.length === 0) {
      return [{ name: cat.name, category: cat.step, why: `Adapted for Type ${hairType}`, ingredients: cat.key_topical_actives, bestFor: `Type ${hairType} hair`, image: "🧴" }];
    }
    return products.map(p => ({
      name: p.title, category: cat.step, why: p.notes_short,
      ingredients: p.key_actives, bestFor: `Type ${hairType} hair`, image: "🧴",
    }));
  });
}

export function getAllProductsForProfile(profile: HairProfile): Record<string, Array<{ name: string; category: string; why: string; ingredients: string[]; bestFor: string; image: string }>> {
  const objectives = ["hydration", "repair", "scalp", "protection"];
  if (profile.additionalObjective) objectives.push(profile.additionalObjective);
  const result: Record<string, typeof objectives extends (infer T)[] ? any : never> = {};
  for (const obj of objectives) {
    const products = getProductsForType(profile.hairType, obj);
    if (products.length > 0) result[obj] = products;
  }
  return result;
}
