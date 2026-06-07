import { useState } from "react";
import { Droplets, Wrench, Sprout, Activity, Shield, Layers, Waves, Info, Sparkles, X } from "lucide-react";
import { loadProfile, OBJECTIVES, getNutrientsForObjective, getFoodDetail } from "@/lib/hair-data";

const objectiveIcons: Record<string, React.ElementType> = {
  hydration: Droplets, repair: Wrench, scalp: Activity, protection: Shield,
  growth: Sprout, density: Layers, "curl-definition": Waves,
};

interface SelectedFood {
  name: string;
  nutrientId: string;
  nutrientName: string;
}

const Nutrition = () => {
  const profile = loadProfile();

  const tabs = OBJECTIVES.filter(o => {
    if (o.type === "fundamental") return true;
    if (o.type === "additional" && profile?.additionalObjective === o.id) return true;
    return false;
  });

  const [active, setActive] = useState(tabs[0]?.id || "hydration");
  const [selectedFood, setSelectedFood] = useState<SelectedFood | null>(null);
  const nutrients = getNutrientsForObjective(active);

  const detail = selectedFood ? getFoodDetail(selectedFood.nutrientId, selectedFood.name) : null;

  return (
    <div className="px-5 pt-14 pb-6">
      <h1 className="mb-1 text-2xl font-bold text-foreground">Nutrition</h1>
      <p className="mb-5 text-sm text-muted-foreground">Internal support for your hair objectives</p>

      {/* Tabs */}
      <div className="-mx-5 px-5 mb-6 overflow-x-auto scrollbar-hide">
        <div className="flex gap-2 w-max">
          {tabs.map((obj) => {
            const Icon = objectiveIcons[obj.id] || Sparkles;
            return (
              <button
                key={obj.id}
                onClick={() => setActive(obj.id)}
                className={`flex items-center gap-1.5 rounded-full px-4 py-2.5 text-xs font-medium transition-all touch-target ${
                  active === obj.id
                    ? "gradient-primary text-primary-foreground shadow-lg shadow-primary/20"
                    : "bg-secondary/60 text-muted-foreground"
                }`}
              >
                <Icon className="h-3.5 w-3.5" />
                {obj.name}
              </button>
            );
          })}
        </div>
      </div>

      {/* Nutrient Cards */}
      <div className="space-y-4 animate-fade-in">
        {nutrients.length === 0 && (
          <div className="rounded-2xl bg-card border border-border/50 p-6 text-center">
            <p className="text-sm text-muted-foreground">No nutrient data for this objective yet.</p>
          </div>
        )}
        {nutrients.map((n, i) => (
          <div key={n.id + "-" + i} className="rounded-2xl bg-card border border-border/50 p-4">
            <div className="flex items-start justify-between mb-2">
              <div className="flex items-center gap-2">
                <h3 className="text-sm font-semibold text-foreground">{n.name}</h3>
                <span className={`rounded-full px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                  n.priority === "core"
                    ? "gradient-primary text-primary-foreground"
                    : "bg-secondary/60 text-muted-foreground"
                }`}>
                  {n.priority}
                </span>
              </div>
              <span className="shrink-0 rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-medium text-accent">
                {n.dailyIntake}
              </span>
            </div>
            <p className="text-xs text-muted-foreground leading-relaxed mb-3">{n.notes_short}</p>
            <div className="flex flex-wrap gap-1.5">
              {n.foods.map((f) => {
                const hasDetail = !!getFoodDetail(n.id, f);
                return (
                  <button
                    key={f}
                    onClick={() => hasDetail && setSelectedFood({ name: f, nutrientId: n.id, nutrientName: n.name })}
                    className={`rounded-md px-2 py-1 text-[11px] text-secondary-foreground transition-all ${
                      hasDetail
                        ? "bg-secondary/50 hover:bg-primary/15 hover:text-primary active:scale-95 cursor-pointer"
                        : "bg-secondary/50 cursor-default"
                    }`}
                  >
                    {f}
                    {hasDetail && <span className="ml-1 text-[9px] opacity-50">›</span>}
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      {/* Disclaimer */}
      <div className="mt-6 flex items-start gap-2 rounded-xl bg-secondary/30 p-3 border border-border/30">
        <Info className="h-4 w-4 shrink-0 text-muted-foreground mt-0.5" />
        <p className="text-[10px] text-muted-foreground leading-relaxed">
          This information is for educational purposes only and is not a substitute for professional medical advice. Consult a healthcare provider before making significant dietary changes or starting supplements.
        </p>
      </div>

      {/* Food Detail Bottom Sheet */}
      {selectedFood && detail && (
        <div
          className="fixed inset-0 z-50 flex items-end"
          onClick={() => setSelectedFood(null)}
        >
          <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" />
          <div
            className="relative w-full rounded-t-3xl bg-card border-t border-border/50 p-6 pb-8 animate-fade-in"
            onClick={e => e.stopPropagation()}
          >
            {/* Handle bar */}
            <div className="mx-auto mb-5 h-1 w-10 rounded-full bg-border" />

            {/* Header */}
            <div className="flex items-start justify-between mb-1">
              <h2 className="text-base font-bold text-foreground">{selectedFood.name}</h2>
              <button
                onClick={() => setSelectedFood(null)}
                className="rounded-full p-1.5 bg-secondary/60 text-muted-foreground hover:bg-secondary active:scale-95 transition-all"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <p className="text-[11px] text-muted-foreground mb-5">
              Teneur en <span className="font-medium text-accent">{selectedFood.nutrientName}</span>
            </p>

            {/* Data rows */}
            <div className="space-y-3">
              <div className="flex items-center justify-between rounded-xl bg-secondary/40 px-4 py-3">
                <span className="text-xs text-muted-foreground">Pour 100 g</span>
                <span className="text-sm font-semibold text-foreground">{detail.per100g}</span>
              </div>
              {detail.perUnit && (
                <div className="flex items-center justify-between rounded-xl bg-primary/8 border border-primary/20 px-4 py-3">
                  <span className="text-xs text-muted-foreground">{detail.perUnit.label}</span>
                  <span className="text-sm font-semibold text-primary">{detail.perUnit.amount}</span>
                </div>
              )}
            </div>

            {/* Note */}
            {detail.note && (
              <div className="mt-4 flex items-start gap-2 rounded-xl bg-secondary/30 px-3 py-2.5">
                <Info className="h-3.5 w-3.5 shrink-0 text-muted-foreground mt-0.5" />
                <p className="text-[11px] text-muted-foreground leading-relaxed">{detail.note}</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default Nutrition;
