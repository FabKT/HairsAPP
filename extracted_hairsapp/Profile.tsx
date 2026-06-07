import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import {
  TrendingUp, ChevronDown, RefreshCw, Target, SlidersHorizontal, RotateCcw,
  History, BarChart3, Activity, Edit3, Sparkles, User,
} from "lucide-react";
import { loadProfile, saveProfile, HAIR_TYPES, ADDITIONAL_OBJECTIVES, type HairProfile } from "@/lib/hair-data";

const miniTrend = [62, 68, 74, 78];
const miniLabels = ["W1", "W2", "W3", "W4"];

const planActions = [
  { icon: RefreshCw, label: "Regenerate Weekly Plan", desc: "Create a new protocol based on current profile" },
  { icon: Target, label: "Switch Primary Objective", desc: "Change your main treatment focus" },
  { icon: SlidersHorizontal, label: "Adjust Treatment Frequency", desc: "Modify wash & treatment days" },
  { icon: RotateCcw, label: "Reset Protocol", desc: "Start fresh with a full reassessment" },
];

const historyCards = [
  { icon: History, label: "Protocol History", sub: "3 plans generated" },
  { icon: BarChart3, label: "Score Evolution", sub: "↑ 16 pts over 7 weeks" },
  { icon: Activity, label: "Symptom Trends", sub: "Shedding ↓  Scalp comfort ↑" },
];

const Profile = () => {
  const healthScore = 78;
  const maxTrend = Math.max(...miniTrend);
  const profile = loadProfile();

  const [editingSection, setEditingSection] = useState<string | null>(null);
  const [updating, setUpdating] = useState(false);

  const typeData = profile ? HAIR_TYPES.find(t => t.type === profile.hairType) : null;
  const addObj = profile?.additionalObjective ? ADDITIONAL_OBJECTIVES.find(a => a.id === profile.additionalObjective) : null;

  const handleProfileUpdate = (partial: Partial<HairProfile>) => {
    if (!profile) return;
    const updated = { ...profile, ...partial };
    saveProfile(updated);
    setUpdating(true);
    setTimeout(() => setUpdating(false), 1800);
  };

  const editableSections = [
    {
      id: "hairType",
      title: "Hair Type",
      icon: User,
      current: profile ? `${profile.hairType}${profile.hairSubtype} – ${typeData?.label || ""}` : "Not set",
      options: HAIR_TYPES.flatMap(t => t.subtypes.map(s => ({ label: `${t.type}${s.letter} – ${t.label} (${s.desc})`, type: t.type, letter: s.letter }))),
    },
    {
      id: "additional",
      title: "Additional Objective",
      icon: Target,
      current: addObj?.name || "None",
      options: [{ label: "None", id: null }, ...ADDITIONAL_OBJECTIVES.map(a => ({ label: a.name, id: a.id }))],
    },
  ];

  return (
    <div className="px-5 pt-14 pb-6">
      <h1 className="mb-1 text-2xl font-bold text-foreground">Profile</h1>
      <p className="mb-6 text-sm text-muted-foreground">Your hair health control center</p>

      {/* Health Score */}
      <div className="mb-5 rounded-2xl bg-card p-5 border border-border/50 glow-card-active">
        <div className="flex items-start gap-4">
          <div className="relative shrink-0">
            <svg className="h-20 w-20" viewBox="0 0 80 80">
              <circle cx="40" cy="40" r="34" fill="none" stroke="hsl(240 10% 18%)" strokeWidth="6" />
              <circle cx="40" cy="40" r="34" fill="none" stroke="url(#pScoreG)" strokeWidth="6" strokeLinecap="round"
                strokeDasharray={`${(healthScore / 100) * 213.6} 213.6`} transform="rotate(-90 40 40)" />
              <defs>
                <linearGradient id="pScoreG" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="hsl(265 85% 55%)" />
                  <stop offset="100%" stopColor="hsl(270 60% 70%)" />
                </linearGradient>
              </defs>
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="text-lg font-bold text-gradient">{healthScore}</span>
              <span className="text-[8px] text-muted-foreground">/ 100</span>
            </div>
          </div>
          <div className="flex-1 min-w-0">
            <h3 className="text-sm font-semibold text-foreground mb-0.5">Hair Health Score</h3>
            <p className="text-[11px] text-muted-foreground leading-snug mb-3">Based on adherence and symptom trends</p>
            <div className="flex items-end gap-1.5 h-10">
              {miniTrend.map((v, i) => (
                <div key={i} className="flex-1 flex flex-col items-center gap-0.5">
                  <div className={`w-full rounded-sm transition-all ${i === miniTrend.length - 1 ? "gradient-primary" : "bg-primary/20"}`}
                    style={{ height: `${(v / maxTrend) * 100}%` }} />
                  <span className="text-[7px] text-muted-foreground">{miniLabels[i]}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Hair Profile Overview */}
      <div className="mb-5 rounded-2xl bg-card p-4 border border-border/50">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-sm font-semibold text-foreground">Hair Profile</h3>
          <button className="flex items-center gap-1 text-[11px] text-accent font-medium">
            <Edit3 className="h-3 w-3" /> Edit Profile
          </button>
        </div>
        {profile ? (
          <div className="grid grid-cols-2 gap-x-4 gap-y-2.5">
            {[
              ["Hair Type", `${profile.hairType}${profile.hairSubtype} – ${typeData?.label || ""}`],
              ["Category", typeData?.label || ""],
              ["Additional", addObj?.name || "None"],
              ["Plan Version", "v1"],
            ].map(([label, value]) => (
              <div key={label}>
                <p className="text-[10px] text-muted-foreground">{label}</p>
                <p className="text-xs font-medium text-secondary-foreground truncate">{value}</p>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-xs text-muted-foreground">Complete onboarding to set up your profile.</p>
        )}
        <div className="mt-3 flex flex-wrap gap-1.5">
          <span className="rounded-full gradient-primary px-2.5 py-0.5 text-[10px] font-medium text-primary-foreground">Hydration</span>
          <span className="rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-medium text-accent">Repair</span>
          <span className="rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-medium text-accent">Scalp Balance</span>
          <span className="rounded-full bg-primary/10 px-2.5 py-0.5 text-[10px] font-medium text-accent">Protection</span>
          {addObj && (
            <span className="rounded-full gradient-primary-soft border border-primary/20 px-2.5 py-0.5 text-[10px] font-medium text-accent">{addObj.name}</span>
          )}
        </div>
      </div>

      {/* Editable Parameters */}
      <div className="mb-5">
        <h3 className="text-sm font-semibold text-foreground mb-3">Protocol Parameters</h3>
        {updating && (
          <div className="mb-3 flex items-center gap-2 rounded-xl gradient-primary-soft border border-primary/20 px-3.5 py-2.5 animate-pulse">
            <Sparkles className="h-3.5 w-3.5 text-accent" />
            <span className="text-xs text-accent font-medium">Updating Your Weekly Protocol…</span>
          </div>
        )}
        <div className="space-y-2">
          <Collapsible open={editingSection === "hairType"} onOpenChange={(open) => setEditingSection(open ? "hairType" : null)}>
            <CollapsibleTrigger className="flex w-full items-center gap-3 rounded-xl bg-card border border-border/50 px-4 py-3 text-left touch-target transition-all hover:border-primary/20">
              <User className="h-4 w-4 text-accent shrink-0" />
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium text-foreground">Hair Type</p>
                <p className="text-[10px] text-muted-foreground truncate">{editableSections[0].current}</p>
              </div>
              <ChevronDown className={`h-4 w-4 text-muted-foreground transition-transform ${editingSection === "hairType" ? "rotate-180" : ""}`} />
            </CollapsibleTrigger>
            <CollapsibleContent className="mt-1.5 space-y-1.5 pl-2 pr-1">
              {editableSections[0].options.map((opt: any) => {
                const isSelected = profile?.hairType === opt.type && profile?.hairSubtype === opt.letter;
                return (
                  <button key={opt.label} onClick={() => handleProfileUpdate({ hairType: opt.type, hairSubtype: opt.letter })}
                    className={`w-full rounded-lg px-3.5 py-2.5 text-left text-xs font-medium transition-all ${
                      isSelected ? "gradient-primary-soft border border-primary/40 text-foreground" : "bg-secondary/40 border border-transparent text-secondary-foreground"
                    }`}>{opt.label}</button>
                );
              })}
            </CollapsibleContent>
          </Collapsible>

          <Collapsible open={editingSection === "additional"} onOpenChange={(open) => setEditingSection(open ? "additional" : null)}>
            <CollapsibleTrigger className="flex w-full items-center gap-3 rounded-xl bg-card border border-border/50 px-4 py-3 text-left touch-target transition-all hover:border-primary/20">
              <Target className="h-4 w-4 text-accent shrink-0" />
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium text-foreground">Additional Objective</p>
                <p className="text-[10px] text-muted-foreground truncate">{editableSections[1].current}</p>
              </div>
              <ChevronDown className={`h-4 w-4 text-muted-foreground transition-transform ${editingSection === "additional" ? "rotate-180" : ""}`} />
            </CollapsibleTrigger>
            <CollapsibleContent className="mt-1.5 space-y-1.5 pl-2 pr-1">
              {editableSections[1].options.map((opt: any) => {
                const isSelected = (profile?.additionalObjective || null) === opt.id;
                return (
                  <button key={opt.label} onClick={() => handleProfileUpdate({ additionalObjective: opt.id })}
                    className={`w-full rounded-lg px-3.5 py-2.5 text-left text-xs font-medium transition-all ${
                      isSelected ? "gradient-primary-soft border border-primary/40 text-foreground" : "bg-secondary/40 border border-transparent text-secondary-foreground"
                    }`}>{opt.label}</button>
                );
              })}
            </CollapsibleContent>
          </Collapsible>
        </div>
      </div>

      {/* Plan Control */}
      <div className="mb-5">
        <h3 className="text-sm font-semibold text-foreground mb-3">Plan Control</h3>
        <div className="space-y-2">
          {planActions.map((action) => (
            <button key={action.label} className="flex w-full items-center gap-3 rounded-xl bg-card border border-border/50 px-4 py-3.5 text-left touch-target transition-all hover:border-primary/20 active:scale-[0.98]">
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-primary/10">
                <action.icon className="h-4 w-4 text-accent" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium text-foreground">{action.label}</p>
                <p className="text-[10px] text-muted-foreground">{action.desc}</p>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* History */}
      <div className="mb-2">
        <h3 className="text-sm font-semibold text-foreground mb-3">History & Data</h3>
        <div className="grid grid-cols-3 gap-2">
          {historyCards.map((card) => (
            <div key={card.label} className="flex flex-col items-center gap-1.5 rounded-xl bg-card border border-border/50 p-3 text-center">
              <card.icon className="h-5 w-5 text-accent" />
              <p className="text-[10px] font-medium text-foreground leading-tight">{card.label}</p>
              <p className="text-[9px] text-muted-foreground leading-tight">{card.sub}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Profile;
