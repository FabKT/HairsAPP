import { useState } from "react";
import { Droplets, Wrench, Activity, Sprout, Shield, Layers, Waves, ExternalLink, Sparkles, Wind, Heart, AlertCircle, Info } from "lucide-react";
import { Button } from "@/components/ui/button";
import { loadProfile, OBJECTIVES, getSmartProductsForObjective, type AmazonProduct, type ProductCategory } from "@/lib/hair-data";

const objectiveIcons: Record<string, React.ElementType> = {
  hydration: Droplets, repair: Wrench, scalp: Activity, protection: Shield,
  growth: Sprout, density: Layers, "curl-definition": Waves,
  volume: Layers, "frizz-control": Wind, "scalp-soothing": Heart,
};

const tierColors: Record<string, string> = {
  budget: "bg-emerald-500/20 text-emerald-400",
  mid: "bg-primary/15 text-accent",
  premium: "bg-amber-500/20 text-amber-400",
};

const weightColors: Record<string, string> = {
  light: "bg-sky-500/15 text-sky-400",
  medium: "bg-violet-500/15 text-violet-400",
  heavy: "bg-orange-500/15 text-orange-400",
};

const Products = () => {
  const profile = loadProfile();
  const hairType = profile?.hairType || 3;

  // Build tabs: fundamentals + user's additional objective
  const tabs = OBJECTIVES.filter(o => {
    if (o.type === "fundamental") return true;
    if (o.type === "additional" && profile?.additionalObjective === o.id) return true;
    return false;
  });

  const [activeTab, setActiveTab] = useState(tabs[0]?.id || "hydration");

  // Smart filtered products grouped by generic category
  const groupedProducts = getSmartProductsForObjective(hairType, activeTab);

  // Group by step
  const stepOrder = ["Cleanse", "Treat", "Condition", "Protect"];
  const groupedByStep = stepOrder
    .map(step => ({
      step,
      groups: groupedProducts.filter(g => g.catInfo.step === step),
    }))
    .filter(g => g.groups.length > 0);

  return (
    <div className="px-5 pt-14 pb-6">
      <h1 className="mb-1 text-2xl font-bold text-foreground">Products</h1>
      <div className="flex items-center justify-between mb-5">
        <p className="text-sm text-muted-foreground">
          {profile ? `Curated for Type ${profile.hairType}${profile.hairSubtype} hair` : "Curated by objective"}
        </p>
        <button className="flex h-7 w-7 items-center justify-center rounded-full bg-secondary/60 text-muted-foreground transition-colors hover:text-accent hover:bg-secondary">
          <Info className="h-3.5 w-3.5" />
        </button>
      </div>

      {/* Tabs */}
      <div className="-mx-5 px-5 mb-6 overflow-x-auto scrollbar-hide">
        <div className="flex gap-2 w-max">
          {tabs.map((tab) => {
            const Icon = objectiveIcons[tab.id] || Sparkles;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-1.5 rounded-full px-4 py-2.5 text-xs font-medium transition-all touch-target ${
                  activeTab === tab.id
                    ? "gradient-primary text-primary-foreground shadow-lg shadow-primary/20"
                    : "bg-secondary/60 text-muted-foreground"
                }`}
              >
                <Icon className="h-3.5 w-3.5" />
                {tab.name}
              </button>
            );
          })}
        </div>
      </div>

      {/* Product Categories by Step */}
      <div className="space-y-6 animate-fade-in">
        {groupedByStep.length === 0 && (
          <div className="rounded-2xl bg-card border border-border/50 p-6 text-center">
            <AlertCircle className="h-8 w-8 text-muted-foreground mx-auto mb-2" />
            <p className="text-sm font-medium text-foreground mb-1">No suitable product found</p>
            <p className="text-xs text-muted-foreground">No products match this objective for your hair type.</p>
          </div>
        )}
        {groupedByStep.map(({ step, groups }) => (
          <div key={step}>
            <div className="flex items-center gap-2 mb-3">
              <div className="h-1.5 w-1.5 rounded-full gradient-primary" />
              <h3 className="text-xs font-bold text-accent uppercase tracking-wider">{step}</h3>
            </div>
            <div className="space-y-3">
              {groups.map(({ category, products, catInfo }) => (
                <div key={catInfo.code}>
                  {/* Category header */}
                  <div className="mb-2 px-1">
                    <div className="flex items-center gap-2">
                      <p className="text-sm font-semibold text-foreground">{catInfo.name}</p>
                      <span className="rounded-md bg-secondary/40 px-1.5 py-0.5 text-[9px] text-muted-foreground font-medium">{category}</span>
                    </div>
                    <div className="flex flex-wrap gap-1 mt-1">
                      {catInfo.key_topical_actives.map(a => (
                        <span key={a} className="rounded-md bg-secondary/50 px-2 py-0.5 text-[10px] text-secondary-foreground">{a}</span>
                      ))}
                    </div>
                  </div>
                  {/* Product cards */}
                  {products.length > 0 ? products.map((product) => (
                    <ProductCard key={product.id} product={product} cat={catInfo} profile={profile} />
                  )) : (
                    <div className="rounded-xl bg-card border border-border/50 p-4 text-center">
                      <p className="text-xs text-muted-foreground">No suitable product found</p>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

const ProductCard = ({ product, cat, profile }: { product: AmazonProduct; cat: ProductCategory; profile: ReturnType<typeof loadProfile> }) => (
  <div className="rounded-2xl bg-card border border-border/50 p-4 glow-card mb-2">
    <div className="flex gap-3 mb-3">
      <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-xl bg-secondary/60 overflow-hidden">
        <img
          src={product.image_url}
          alt={product.title}
          className="h-full w-full object-cover rounded-xl"
          onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
        />
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm font-semibold text-foreground leading-tight mb-1">{product.title}</p>
        <div className="flex items-center gap-1.5 mb-1.5 flex-wrap">
          <span className={`rounded-full px-2 py-0.5 text-[10px] font-bold uppercase ${tierColors[product.price_tier]}`}>
            {product.price_tier}
          </span>
          <span className={`rounded-full px-2 py-0.5 text-[10px] font-medium ${weightColors[product.weight]}`}>
            {product.weight}
          </span>
          <span className="rounded-full gradient-primary-soft border border-primary/20 px-2 py-0.5 text-[10px] font-medium text-accent">
            {cat.generic_category}
          </span>
        </div>
        <p className="text-[11px] text-muted-foreground">{product.notes_short}</p>
      </div>
    </div>
    <div className="mb-3">
      <p className="text-[10px] text-muted-foreground mb-1 uppercase tracking-wider">Key Actives</p>
      <div className="flex flex-wrap gap-1">
        {product.key_actives.map((a) => (
          <span key={a} className="rounded-md bg-secondary/50 px-2 py-0.5 text-[11px] text-secondary-foreground">{a}</span>
        ))}
      </div>
    </div>
    <div className="flex items-center justify-between">
      <div className="flex flex-col gap-0.5">
        <span className="text-[11px] text-accent/80">Best for: Type {product.hair_types.join(", ")}</span>
        {profile && (
          <span className="text-[10px] text-accent/50">Selected for Type {profile.hairType}{profile.hairSubtype}</span>
        )}
      </div>
      <Button variant="glow" size="sm" className="h-8 rounded-lg text-[11px] gap-1 px-3" asChild>
        <a href={product.amazon_affiliate_url} target="_blank" rel="noopener noreferrer">
          View <ExternalLink className="h-3 w-3" />
        </a>
      </Button>
    </div>
  </div>
);

export default Products;
