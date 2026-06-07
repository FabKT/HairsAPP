import { useState } from "react";
import { Droplets, Wrench, Shield, Moon } from "lucide-react";
import { loadProfile, getRoutineForProfile, getWeekPlan, HAIR_TYPES, type DayPlan } from "@/lib/hair-data";

const weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const dayKeys = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

const fullDayNames: Record<string, string> = {
  Mon: "Monday", Tue: "Tuesday", Wed: "Wednesday", Thu: "Thursday",
  Fri: "Friday", Sat: "Saturday", Sun: "Sunday",
};

const dayTypeIcons: Record<string, React.ElementType> = {
  wash: Droplets,
  treatment: Wrench,
  oil: Droplets,
  rest: Moon,
};

const hairTypeWhyReasons: Record<number, string[]> = {
  1: [
    "Wash when oily or product-heavy; fine straight hair may need frequent cleansing.",
    "Condition mostly mid-lengths and ends so roots stay light.",
    "Use low/medium heat and a heat protectant; avoid repeatedly overheating the same section.",
  ],
  2: [
    "Wash 2–3 times per week to remove build-up without over-drying your waves.",
    "Apply conditioner focusing on mid-lengths and ends; scrunch to enhance wave pattern.",
    "Air-dry or use a diffuser on low heat to maintain wave definition.",
  ],
  3: [
    "Wash once or twice a week with sulfate-free products to preserve natural oils.",
    "Deep condition regularly; apply generously from roots to ends for full moisture.",
    "Use a diffuser or air-dry to avoid frizz; apply styling products to wet hair.",
  ],
  4: [
    "Co-wash or use a gentle cleanser weekly to preserve scalp oils and moisture.",
    "Deep condition every wash day; seal moisture with an oil or butter after conditioning.",
    "Avoid manipulation when dry; style on damp hair and protect at night with a satin bonnet.",
  ],
};

const Routine = () => {
  const profile = loadProfile();
  const routine = profile ? getRoutineForProfile(profile) : [];
  const weekPlanData = profile ? getWeekPlan(profile) : {};
  const typeData = profile ? HAIR_TYPES.find(t => t.type === profile.hairType) : null;
  const [checkedTasks, setCheckedTasks] = useState<Set<string>>(new Set());

  const todayKey = dayKeys[new Date().getDay()];
  const todayPlan = (weekPlanData as Record<string, DayPlan>)[todayKey];

  const totalWeekSteps = weekDays.reduce((sum, day) => {
    const plan = (weekPlanData as Record<string, DayPlan>)[day];
    return sum + (plan?.type !== "rest" ? plan?.actions.length || 0 : 0);
  }, 0);
  const todayStepCount = todayPlan?.type !== "rest" ? (todayPlan?.actions.length || 0) : 0;

  const todayRoutineSteps = todayPlan?.type !== "rest"
    ? routine.filter(s => todayPlan?.actions.some(a => s.action.toLowerCase().includes(a.toLowerCase())))
    : [];

  const toggleTask = (taskId: string) => {
    setCheckedTasks(prev => {
      const next = new Set(prev);
      if (next.has(taskId)) next.delete(taskId);
      else next.add(taskId);
      return next;
    });
  };

  const whyReasons = profile
    ? (hairTypeWhyReasons[profile.hairType] || hairTypeWhyReasons[1])
    : hairTypeWhyReasons[1];

  const getDayStepCount = (day: string): number => {
    const plan = (weekPlanData as Record<string, DayPlan>)[day];
    return plan?.type !== "rest" ? plan?.actions.length || 0 : 0;
  };

  return (
    <div className="px-5 pt-14 pb-6">
      <h1 className="mb-1 text-2xl font-bold text-foreground">Weekly Routine</h1>
      <p className="mb-5 text-sm text-muted-foreground">
        {profile ? `Type ${profile.hairType}${profile.hairSubtype} · ${typeData?.label || ""}` : "Your personalized routine"}
      </p>

      {/* This week summary */}
      <div className="mb-5 rounded-2xl bg-card border border-border/50 p-4">
        <div className="flex items-center justify-between mb-2">
          <p className="text-sm font-semibold text-foreground">This week</p>
          <span className="text-lg font-bold text-accent">0%</span>
        </div>
        <div className="h-2 w-full rounded-full bg-secondary overflow-hidden mb-3">
          <div className="h-full rounded-full gradient-primary transition-all" style={{ width: "0%" }} />
        </div>
        <p className="text-xs text-muted-foreground">0 of {totalWeekSteps} weekly steps completed</p>
        <p className="text-xs text-muted-foreground mt-0.5">Today: 0 of {todayStepCount} steps done.</p>
      </div>

      {/* Day strip */}
      <div className="-mx-5 px-5 mb-5 overflow-x-auto scrollbar-hide">
        <div className="flex gap-2.5 w-max pb-1">
          {weekDays.map((day) => {
            const plan = (weekPlanData as Record<string, DayPlan>)[day];
            if (!plan) return null;
            const isToday = day === todayKey;
            const isRest = plan.type === "rest";
            const stepCount = getDayStepCount(day);

            return (
              <div
                key={day}
                className={`w-[88px] shrink-0 rounded-2xl border p-3 transition-all ${
                  isToday
                    ? "border-primary/50 gradient-primary-soft"
                    : "border-border/30 bg-card/50"
                }`}
              >
                <p className={`text-xs font-bold mb-2 ${isToday ? "text-accent" : "text-foreground"}`}>{day}</p>
                <div className={`h-5 w-5 rounded-full border-2 mb-2 flex items-center justify-center ${
                  isToday ? "border-primary/60" : "border-border/50"
                }`}>
                  {isToday && <div className="h-2 w-2 rounded-full gradient-primary" />}
                </div>
                <p className="text-[9px] text-muted-foreground leading-tight mb-1 truncate">{plan.label}</p>
                {isRest ? (
                  <span className="text-[10px] font-semibold text-accent">Rest</span>
                ) : (
                  <span className="text-[10px] text-muted-foreground">0/{stepCount}</span>
                )}
              </div>
            );
          })}
        </div>
      </div>

      {/* Today's task card */}
      {todayPlan && (
        <div className="mb-5 rounded-2xl bg-card border border-primary/30 p-4">
          <div className="flex items-center justify-between mb-4">
            <p className="text-sm font-bold text-foreground">
              {fullDayNames[todayKey]} · {todayPlan.label}
            </p>
            <span className="text-[10px] font-semibold text-accent bg-primary/15 px-2.5 py-0.5 rounded-full">Today</span>
          </div>

          {todayPlan.type === "rest" ? (
            <p className="text-xs text-muted-foreground/70 italic">
              Jour de repos — laissez vos cheveux récupérer.
            </p>
          ) : todayRoutineSteps.length > 0 ? (
            <div className="space-y-4">
              {todayRoutineSteps.map((step) => {
                const taskId = `today-${step.step}`;
                const checked = checkedTasks.has(taskId);
                return (
                  <button
                    key={step.step}
                    onClick={() => toggleTask(taskId)}
                    className="flex items-start gap-3 w-full text-left"
                  >
                    <div className={`mt-0.5 h-5 w-5 shrink-0 rounded border-2 flex items-center justify-center transition-all ${
                      checked ? "border-primary gradient-primary" : "border-border/60"
                    }`}>
                      {checked && (
                        <svg className="h-3 w-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className={`text-sm font-semibold transition-colors ${checked ? "text-muted-foreground line-through" : "text-foreground"}`}>
                        {step.action}
                      </p>
                      <p className="text-xs text-accent mt-0.5">{step.product}</p>
                      <p className="text-[11px] text-muted-foreground mt-1 leading-relaxed">{step.why}</p>
                    </div>
                  </button>
                );
              })}
            </div>
          ) : (
            <div className="space-y-4">
              {todayPlan.actions.map((action, idx) => {
                const taskId = `today-action-${idx}`;
                const checked = checkedTasks.has(taskId);
                return (
                  <button
                    key={idx}
                    onClick={() => toggleTask(taskId)}
                    className="flex items-center gap-3 w-full text-left"
                  >
                    <div className={`h-5 w-5 shrink-0 rounded border-2 flex items-center justify-center transition-all ${
                      checked ? "border-primary gradient-primary" : "border-border/60"
                    }`}>
                      {checked && (
                        <svg className="h-3 w-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                    </div>
                    <p className={`text-sm font-semibold transition-colors ${checked ? "text-muted-foreground line-through" : "text-foreground"}`}>
                      {action}
                    </p>
                  </button>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* Why this routine works */}
      <div className="mb-5 rounded-2xl bg-card border border-border/50 p-4">
        <div className="flex items-center gap-2 mb-3">
          <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-lg gradient-primary-soft border border-primary/20">
            <span className="text-xs text-accent">💡</span>
          </div>
          <p className="text-sm font-semibold text-foreground">Why this routine works</p>
        </div>
        <div className="space-y-2.5">
          {whyReasons.map((reason, idx) => (
            <div key={idx} className="flex items-start gap-2.5">
              <div className="h-1.5 w-1.5 rounded-full gradient-primary shrink-0 mt-1.5" />
              <p className="text-xs text-muted-foreground leading-relaxed">{reason}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Full week list */}
      <div>
        <p className="text-sm font-semibold text-foreground mb-3">Full week</p>
        <div className="space-y-2">
          {weekDays.map((day) => {
            const plan = (weekPlanData as Record<string, DayPlan>)[day];
            if (!plan) return null;
            const isToday = day === todayKey;
            const isRest = plan.type === "rest";
            const DayIcon = dayTypeIcons[plan.type] || Moon;
            const stepCount = getDayStepCount(day);

            return (
              <div
                key={day}
                className={`flex items-center gap-3 rounded-xl border px-4 py-3 transition-all ${
                  isToday ? "border-primary/30 bg-card" : "border-border/30 bg-card/50"
                }`}
              >
                <p className={`text-xs font-bold w-8 shrink-0 ${isToday ? "text-accent" : "text-muted-foreground"}`}>
                  {day}
                </p>
                <div className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-lg ${
                  isRest ? "bg-secondary" : "gradient-primary-soft border border-primary/20"
                }`}>
                  <DayIcon className={`h-3.5 w-3.5 ${isRest ? "text-muted-foreground" : "text-accent"}`} />
                </div>
                <p className="text-xs text-foreground flex-1 truncate">{plan.label}</p>
                {isRest ? (
                  <span className="text-xs font-semibold text-accent shrink-0">Rest</span>
                ) : (
                  <span className="text-xs text-muted-foreground shrink-0">0/{stepCount}</span>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default Routine;
