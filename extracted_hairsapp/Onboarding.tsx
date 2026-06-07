import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { ChevronRight, ChevronLeft, Sparkles, Droplets, Wrench, Shield, Activity, Sprout, Layers, Waves, Loader2 } from "lucide-react";
import { HAIR_TYPES, FUNDAMENTAL_OBJECTIVES, ADDITIONAL_OBJECTIVES, saveProfile } from "@/lib/hair-data";

type Phase = "type" | "subtype" | "fundamentals" | "additional" | "loading";

const additionalIcons: Record<string, React.ReactNode> = {
  sprout: <Sprout className="h-5 w-5" />,
  layers: <Layers className="h-5 w-5" />,
  waves: <Waves className="h-5 w-5" />,
  shield: <Shield className="h-5 w-5" />,
  activity: <Activity className="h-5 w-5" />,
};

const fundamentalIcons = [Droplets, Wrench, Activity, Shield];
const typeIllustrations = ["〰️", "〜", "🌀", "🔗"];

const Onboarding = () => {
  const navigate = useNavigate();
  const [phase, setPhase] = useState<Phase>("type");
  const [selectedType, setSelectedType] = useState<number | null>(null);
  const [selectedSubtype, setSelectedSubtype] = useState<string | null>(null);
  const [additionalObj, setAdditionalObj] = useState<string | null>(null);

  useEffect(() => {
    if (phase === "loading") {
      const timer = setTimeout(() => {
        saveProfile({
          hairType: selectedType!,
          hairSubtype: selectedSubtype!,
          additionalObjective: additionalObj,
        });
        navigate("/home");
      }, 2500);
      return () => clearTimeout(timer);
    }
  }, [phase, selectedType, selectedSubtype, additionalObj, navigate]);

  const stepIndex = phase === "type" ? 0 : phase === "subtype" ? 1 : phase === "fundamentals" ? 2 : phase === "additional" ? 3 : 4;
  const totalSteps = 4;
  const progress = (Math.min(stepIndex + 1, totalSteps) / totalSteps) * 100;

  const goBack = () => {
    if (phase === "subtype") { setPhase("type"); setSelectedSubtype(null); }
    else if (phase === "fundamentals") setPhase("subtype");
    else if (phase === "additional") setPhase("fundamentals");
  };

  if (phase === "loading") {
    return (
      <div className="flex min-h-screen max-w-[430px] mx-auto flex-col items-center justify-center bg-background px-6 text-center">
        <div className="relative mb-8">
          <div className="h-20 w-20 rounded-full gradient-primary animate-pulse flex items-center justify-center">
            <Loader2 className="h-8 w-8 text-primary-foreground animate-spin" />
          </div>
          <div className="absolute -inset-4 rounded-full border border-primary/20 animate-ping opacity-30" />
        </div>
        <h1 className="mb-3 text-xl font-bold text-foreground">Building Your Personalized<br />Weekly Protocol…</h1>
        <p className="text-sm text-muted-foreground leading-relaxed max-w-[280px]">
          Adapting products and routine to your hair type and goals.
        </p>
      </div>
    );
  }

  const selectedTypeData = selectedType !== null ? HAIR_TYPES.find(t => t.type === selectedType) : null;

  return (
    <div className="flex min-h-screen max-w-[430px] mx-auto flex-col bg-background px-5 pt-14 pb-8">
      {/* Progress */}
      <div className="mb-8">
        <div className="mb-4 flex items-center justify-between">
          <button onClick={goBack} className={`touch-target flex items-center justify-center rounded-xl ${phase === "type" ? "invisible" : ""}`}>
            <ChevronLeft className="h-5 w-5 text-muted-foreground" />
          </button>
          <span className="text-xs text-muted-foreground">{Math.min(stepIndex + 1, totalSteps)} / {totalSteps}</span>
          <div className="w-10" />
        </div>
        <div className="h-1 w-full rounded-full bg-secondary">
          <div className="h-full rounded-full gradient-primary transition-all duration-500" style={{ width: `${progress}%` }} />
        </div>
      </div>

      {/* STEP 1: Hair Type */}
      {phase === "type" && (
        <div className="flex-1 flex flex-col animate-fade-in">
          <h2 className="text-xl font-bold text-foreground mb-1">Select Your Hair Type</h2>
          <p className="text-sm text-muted-foreground mb-6">Choose the pattern closest to yours</p>
          <div className="flex-1 space-y-3">
            {HAIR_TYPES.map((ht) => (
              <button
                key={ht.type}
                onClick={() => { setSelectedType(ht.type); setPhase("subtype"); }}
                className={`w-full flex items-center gap-4 rounded-2xl border p-4 text-left transition-all touch-target ${
                  selectedType === ht.type ? "gradient-primary-soft border-primary/40 glow-card" : "bg-card border-border/50 hover:border-primary/20"
                }`}
              >
                <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-xl bg-secondary/60 text-2xl">
                  {typeIllustrations[ht.type - 1]}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-base font-semibold text-foreground">Type {ht.type} – {ht.label}</p>
                  <p className="text-xs text-muted-foreground mt-0.5">{ht.desc}</p>
                </div>
                <ChevronRight className="h-4 w-4 text-muted-foreground shrink-0" />
              </button>
            ))}
          </div>
        </div>
      )}

      {/* STEP 1B: Subtype */}
      {phase === "subtype" && selectedTypeData && (
        <div className="flex-1 flex flex-col animate-fade-in">
          <h2 className="text-xl font-bold text-foreground mb-1">Type {selectedTypeData.type} – {selectedTypeData.label}</h2>
          <p className="text-sm text-muted-foreground mb-6">Select your subtype</p>
          <div className="flex-1 space-y-3">
            {selectedTypeData.subtypes.map((st) => (
              <button
                key={st.letter}
                onClick={() => setSelectedSubtype(st.letter)}
                className={`w-full rounded-2xl border p-5 text-left transition-all touch-target ${
                  selectedSubtype === st.letter ? "gradient-primary-soft border-primary/40 glow-card" : "bg-card border-border/50 hover:border-primary/20"
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-xl text-sm font-bold ${
                    selectedSubtype === st.letter ? "gradient-primary text-primary-foreground" : "bg-secondary/60 text-muted-foreground"
                  }`}>
                    {st.letter}
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">{selectedTypeData.type}{st.letter}</p>
                    <p className="text-xs text-muted-foreground">{st.desc}</p>
                  </div>
                </div>
              </button>
            ))}
          </div>
          <div className="mt-6">
            <Button variant="glow" className="w-full rounded-2xl h-14 text-base" disabled={!selectedSubtype} onClick={() => setPhase("fundamentals")}>
              Continue <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        </div>
      )}

      {/* STEP 2: Fundamental Objectives */}
      {phase === "fundamentals" && (
        <div className="flex-1 flex flex-col animate-fade-in">
          <h2 className="text-xl font-bold text-foreground mb-1">Your Fundamental Objectives</h2>
          <p className="text-sm text-muted-foreground mb-6">These are automatically active in your plan</p>
          <div className="flex-1 space-y-3">
            {FUNDAMENTAL_OBJECTIVES.map((obj, i) => {
              const Icon = fundamentalIcons[i];
              return (
                <div key={obj.id} className="flex items-center gap-3 rounded-2xl gradient-primary-soft border border-primary/20 p-4">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl gradient-primary">
                    <Icon className="h-4 w-4 text-primary-foreground" />
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-semibold text-foreground">{obj.name}</p>
                    <p className="text-xs text-muted-foreground">{obj.description_short}</p>
                  </div>
                  <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary/20">
                    <Sparkles className="h-3 w-3 text-accent" />
                  </div>
                </div>
              );
            })}
          </div>
          <div className="mt-6">
            <Button variant="glow" className="w-full rounded-2xl h-14 text-base" onClick={() => setPhase("additional")}>
              Continue <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        </div>
      )}

      {/* STEP 3: Additional Objective */}
      {phase === "additional" && (
        <div className="flex-1 flex flex-col animate-fade-in">
          <h2 className="text-xl font-bold text-foreground mb-1">Enhance Your Hair Plan</h2>
          <p className="text-sm text-muted-foreground mb-6">Select up to one additional focus (optional)</p>
          <div className="flex-1 space-y-3">
            {ADDITIONAL_OBJECTIVES.map((obj) => (
              <button
                key={obj.id}
                onClick={() => setAdditionalObj(additionalObj === obj.id ? null : obj.id)}
                className={`w-full flex items-center gap-3 rounded-2xl border p-4 text-left transition-all touch-target ${
                  additionalObj === obj.id ? "gradient-primary-soft border-primary/40 glow-card-active" : "bg-card border-border/50 hover:border-primary/20"
                }`}
              >
                <div className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-xl ${
                  additionalObj === obj.id ? "gradient-primary text-primary-foreground" : "bg-secondary/60 text-accent"
                }`}>
                  {additionalIcons[obj.icon || "sprout"]}
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-foreground">{obj.name}</p>
                  <p className="text-xs text-muted-foreground">{obj.description_short}</p>
                </div>
              </button>
            ))}
          </div>
          <div className="mt-6">
            <Button variant="glow" className="w-full rounded-2xl h-14 text-base" onClick={() => setPhase("loading")}>
              Generate My Plan <Sparkles className="h-4 w-4 ml-1" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Onboarding;
