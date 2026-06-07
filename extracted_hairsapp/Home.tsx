import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Sheet,
  SheetContent,
  SheetTitle,
} from "@/components/ui/sheet";
import {
  Droplets, Wrench, Activity, Sprout, Shield,
  Layers, Waves, Sparkles, Wind, Heart,
  Info, ShoppingBag, Utensils, ClipboardList,
} from "lucide-react";
import {
  loadProfile, FUNDAMENTAL_OBJECTIVES, ADDITIONAL_OBJECTIVES,
  getRoutineForProfile, getWeekPlan, OBJECTIVES, getNutrientsForObjective,
  getSmartProductsForObjective, type DayPlan,
} from "@/lib/hair-data";

const objectiveIcons: Record<string, React.ElementType> = {
  hydration: Droplets, repair: Wrench, scalp: Activity, protection: Shield,
  growth: Sprout, density: Layers, "curl-definition": Waves,
  volume: Layers, "frizz-control": Wind, "scalp-soothing": Heart,
};

const objectiveLabels: Record<string, string> = {
  hydration: "Hydration", repair: "Repair", scalp: "Scalp Balance",
  protection: "Protection", growth: "Croissance",
  density: "Densité", "curl-definition": "Curl Definition",
  volume: "Volume", "frizz-control": "Anti-frisottis", "scalp-soothing": "Apaisement",
};

const objectiveDetails: Record<string, string> = {
  hydration:
    "L'hydratation aide la fibre à rester souple, brillante et plus facile à démêler. L'objectif est d'éviter la sécheresse sans alourdir les racines.",
  repair:
    "Reconstruire les liaisons internes du cheveu endommagées par la chaleur, la coloration chimique ou les agressions mécaniques répétées. Résultat : une fibre plus solide, moins de fourches.",
  scalp:
    "Maintenir un environnement équilibré sur le cuir chevelu pour favoriser une pousse optimale et prévenir pellicules, démangeaisons et inflammations.",
  protection:
    "Créer une barrière efficace contre la chaleur des outils coiffants, les UV du soleil et les polluants environnementaux.",
  growth:
    "Stimuler les follicules pileux endormis et réduire la chute excessive pour densifier progressivement la chevelure.",
  density:
    "Volumiser et renforcer le diamètre de chaque cheveu pour une apparence plus épaisse et plus fournie.",
  "curl-definition":
    "Améliorer l'uniformité et la définition des boucles pour un résultat net, sans frisottis et avec une tenue durable.",
  volume:
    "Donner du corps et de la légèreté aux cheveux plats en soulevant les racines sans alourdir les longueurs.",
  "frizz-control":
    "Lisser et sceller la cuticule capillaire pour bloquer l'humidité ambiante et éliminer les frisottis durablement.",
  "scalp-soothing":
    "Calmer les irritations, rougeurs et sensibilités du cuir chevelu pour retrouver un confort quotidien.",
};

const dayKeys = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

const Home = () => {
  const navigate = useNavigate();
  const profile = loadProfile();
  const [openSheet, setOpenSheet] = useState<string | null>(null);

  const objectives = [
    ...FUNDAMENTAL_OBJECTIVES.map((o) => ({ ...o })),
    ...(profile?.additionalObjective
      ? (() => {
          const found = ADDITIONAL_OBJECTIVES.find(a => a.id === profile.additionalObjective);
          return found ? [{ ...found }] : [];
        })()
      : []),
  ];

  const routine = profile ? getRoutineForProfile(profile) : [];
  const weekPlanData = profile ? getWeekPlan(profile) : {};
  const todayKey = dayKeys[new Date().getDay()];
  const todayPlan = (weekPlanData as Record<string, DayPlan>)[todayKey];
  const todayTaskCount = todayPlan?.type !== "rest" ? (todayPlan?.actions.length || 0) : 0;

  const getStepsForObjective = (objectiveId: string) =>
    routine.filter((s) =>
      s.objectives.some((o) =>
        o.toLowerCase().includes(objectiveId === "scalp" ? "scalp" : objectiveId)
      )
    );

  const activeObjectiveData = openSheet ? OBJECTIVES.find(o => o.id === openSheet) : null;
  const activeSteps = openSheet ? getStepsForObjective(openSheet) : [];
  const ActiveIcon = openSheet ? (objectiveIcons[openSheet] || Sparkles) : Sparkles;

  const activeFeaturedGroups = openSheet && profile
    ? getSmartProductsForObjective(profile.hairType, openSheet)
    : [];
  const activeFeaturedProduct = activeFeaturedGroups.length > 0 ? activeFeaturedGroups[0].products[0] : null;
  const activeFeaturedCategory = activeFeaturedGroups.length > 0 ? activeFeaturedGroups[0].catInfo : null;

  const activeNutrients = openSheet ? getNutrientsForObjective(openSheet).slice(0, 3) : [];

  return (
    <div className="px-5 pt-14 pb-6">

      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">Votre protocole</h1>
        <p className="text-sm text-muted-foreground mt-0.5">
          {profile
            ? `Type ${profile.hairType}${profile.hairSubtype} protocol`
            : "Personnalisé selon votre profil capillaire"}
        </p>
      </div>

      {/* Aujourd'hui card */}
      <div className="mb-6 rounded-2xl bg-card border border-border/50 p-4">
        <div className="flex items-center justify-between mb-3">
          <div>
            <p className="text-sm font-semibold text-foreground">Aujourd'hui</p>
            <p className="text-xs text-muted-foreground">{todayTaskCount} tâches restantes</p>
          </div>
          <span className="text-2xl font-bold text-accent">0%</span>
        </div>
        <div className="h-2 w-full rounded-full bg-secondary overflow-hidden mb-2">
          <div className="h-full rounded-full gradient-primary transition-all duration-700" style={{ width: "0%" }} />
        </div>
        <p className="text-xs text-muted-foreground">0 / {todayTaskCount} tâches faites</p>
      </div>

      {/* Objectifs du jour */}
      <div className="mb-6">
        <h2 className="text-base font-semibold text-foreground mb-1">Objectifs du jour</h2>
        <p className="text-xs text-muted-foreground mb-4">
          Sélectionnez un objectif pour voir les tâches, produits et apports utiles.
        </p>
        <div className="grid grid-cols-2 gap-3">
          {objectives.map((obj, idx) => {
            const Icon = objectiveIcons[obj.id] || Sparkles;
            const taskCount = getStepsForObjective(obj.id).length;
            const isFirstActive = idx === 0;
            const isRest = taskCount === 0;

            return (
              <button
                key={obj.id}
                onClick={() => setOpenSheet(obj.id)}
                className={`text-left rounded-2xl border p-4 transition-all active:scale-95 ${
                  isFirstActive
                    ? "border-primary/40 gradient-primary-soft glow-card"
                    : "border-border/50 bg-card"
                }`}
              >
                <div className="flex items-start justify-between mb-3">
                  <div className={`flex h-8 w-8 items-center justify-center rounded-xl ${
                    isFirstActive ? "gradient-primary" : "bg-secondary"
                  }`}>
                    <Icon className={`h-4 w-4 ${isFirstActive ? "text-primary-foreground" : "text-muted-foreground"}`} />
                  </div>
                  {isRest ? (
                    <span className="text-[10px] font-semibold text-accent">Repos</span>
                  ) : (
                    <span className="text-xs font-semibold text-muted-foreground">0/{taskCount}</span>
                  )}
                </div>
                <p className="text-sm font-bold text-foreground mb-1">
                  {objectiveLabels[obj.id] || obj.name}
                </p>
                <p className="text-[10px] text-muted-foreground leading-relaxed mb-3 line-clamp-2">
                  {obj.description_short}
                </p>
                <div className="h-1 w-full rounded-full bg-secondary overflow-hidden mb-1.5">
                  <div className="h-full rounded-full gradient-primary" style={{ width: "0%" }} />
                </div>
                {isRest ? (
                  <p className="text-[10px] text-muted-foreground/60">Aucune tâche active</p>
                ) : (
                  <p className="text-[10px] text-muted-foreground">0% complété</p>
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Sheet objectif */}
      <Sheet
        open={openSheet !== null}
        onOpenChange={(open) => { if (!open) setOpenSheet(null); }}
      >
        <SheetContent
          side="bottom"
          className="rounded-t-3xl max-h-[88vh] overflow-y-auto p-0 border-primary/20 bg-background"
        >
          {activeObjectiveData && (
            <>
              <SheetTitle className="sr-only">
                {objectiveLabels[activeObjectiveData.id] || activeObjectiveData.name}
              </SheetTitle>

              {/* Drag handle */}
              <div className="flex justify-center pt-3 pb-1">
                <div className="h-1 w-10 rounded-full bg-muted" />
              </div>

              {/* En-tête sheet */}
              <div className="gradient-primary-soft border-b border-primary/20 px-5 pt-3 pb-5">
                <div className="flex items-center gap-4">
                  <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl gradient-primary shadow-lg shadow-primary/30">
                    <ActiveIcon className="h-7 w-7 text-primary-foreground" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h3 className="text-xl font-bold text-foreground">
                      {objectiveLabels[activeObjectiveData.id] || activeObjectiveData.name}
                    </h3>
                    <p className="text-xs text-accent mt-0.5">{activeObjectiveData.description_short}</p>
                  </div>
                </div>
              </div>

              {/* Corps sheet */}
              <div className="px-5 pt-6 pb-10 space-y-7">

                {/* Tâches à accomplir */}
                {activeSteps.length > 0 && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <ClipboardList className="h-4 w-4 text-accent" />
                      <h4 className="text-sm font-bold text-foreground">Tâches à accomplir</h4>
                    </div>
                    <div className="space-y-3">
                      {activeSteps.map((s) => (
                        <div
                          key={s.step}
                          className="flex items-start gap-3 rounded-2xl bg-card p-4 border border-primary/15"
                        >
                          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl gradient-primary text-sm font-bold text-primary-foreground">
                            {s.step}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-semibold text-foreground">{s.action}</p>
                            <p className="text-xs text-accent mt-0.5">{s.product}</p>
                            <p className="text-[11px] text-muted-foreground mt-1">{s.duration}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Utilité */}
                <div>
                  <div className="flex items-center gap-2 mb-3">
                    <Info className="h-4 w-4 text-accent" />
                    <h4 className="text-sm font-bold text-foreground">Utilité</h4>
                  </div>
                  <div className="rounded-2xl gradient-primary-soft border border-primary/20 p-4">
                    <p className="text-sm text-secondary-foreground leading-relaxed">
                      {objectiveDetails[activeObjectiveData.id] || activeObjectiveData.description_short}
                    </p>
                  </div>
                </div>

                {/* Produit phare */}
                {activeFeaturedProduct && activeFeaturedCategory && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <ShoppingBag className="h-4 w-4 text-accent" />
                      <h4 className="text-sm font-bold text-foreground">Produit phare</h4>
                    </div>
                    <div className="rounded-2xl bg-card border border-border/50 p-4">
                      <p className="text-sm font-semibold text-foreground mb-1">{activeFeaturedProduct.title}</p>
                      <p className="text-xs text-muted-foreground mb-3">{activeFeaturedProduct.notes_short}</p>
                      <div className="flex flex-wrap gap-1.5">
                        {activeFeaturedCategory.key_topical_actives.map((a) => (
                          <span key={a} className="rounded-md bg-secondary/50 px-2 py-0.5 text-[11px] text-secondary-foreground">
                            {a}
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                )}

                {/* Nutriments + aliments */}
                {activeNutrients.length > 0 && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <Utensils className="h-4 w-4 text-accent" />
                      <h4 className="text-sm font-bold text-foreground">Nutriments + aliments</h4>
                    </div>
                    <div className="space-y-3">
                      {activeNutrients.map((n) => (
                        <div key={n.id} className="rounded-2xl bg-card border border-border/50 p-4">
                          <div className="flex items-start justify-between mb-1.5">
                            <div className="flex items-center gap-2">
                              <div className="h-2 w-2 rounded-full gradient-primary shrink-0 mt-0.5" />
                              <p className="text-sm font-semibold text-foreground">{n.name}</p>
                            </div>
                            <span className="text-[10px] text-accent font-medium text-right shrink-0 ml-2">
                              {n.dailyIntake}
                            </span>
                          </div>
                          <p className="text-xs text-muted-foreground leading-relaxed ml-4">{n.notes_short}</p>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

              </div>
            </>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
};

export default Home;
