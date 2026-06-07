import { useState } from "react";
import { ChevronDown, ChevronRight, Check, Minus, AlertTriangle, ExternalLink, Copy, XCircle } from "lucide-react";
import {
  OBJECTIVES,
  PRODUCT_CATEGORIES,
  NUTRIENTS,
  OBJECTIVE_NUTRIENTS,
  AMAZON_PRODUCTS,
  getProductCategoriesForProfile,
  getNutrientsForObjective,
  type ProductCategory,
  type AmazonProduct,
} from "@/lib/hair-data";

const HAIR_TYPES = [1, 2, 3, 4] as const;

const GLOBAL_NUTRIENT_IDS = [
  "electrolytes", "omega3", "vitA", "vitC", "vitD", "vitE",
  "zinc", "selenium", "biotin", "bComplex", "iron", "copper",
  "protein", "cysteine", "carotenoids",
];

const allMappedNutrientIds = new Set(OBJECTIVE_NUTRIENTS.map(on => on.nutrient_id));

// Detect duplicate URLs
const urlCounts = new Map<string, string[]>();
AMAZON_PRODUCTS.forEach(p => {
  if (p.amazon_affiliate_url !== "#" && p.status !== "missing") {
    const key = p.amazon_url_clean;
    if (!urlCounts.has(key)) urlCounts.set(key, []);
    urlCounts.get(key)!.push(p.product_category_code);
  }
});
const duplicateUrls = new Map<string, string[]>();
urlCounts.forEach((codes, url) => {
  if (codes.length > 1) duplicateUrls.set(url, codes);
});

const statusBadge = (status: AmazonProduct["status"]) => {
  const styles: Record<string, string> = {
    active: "bg-emerald-500/20 text-emerald-400",
    missing: "bg-destructive/20 text-destructive-foreground",
    needs_review: "bg-amber-500/20 text-amber-400",
    not_applicable: "bg-secondary/40 text-muted-foreground",
  };
  return (
    <span className={`rounded-full px-2 py-0.5 text-[9px] font-bold uppercase ${styles[status] || styles.active}`}>
      {status.replace("_", " ")}
    </span>
  );
};

const HairTypeSection = ({ hairType }: { hairType: number }) => {
  const [open, setOpen] = useState(false);
  return (
    <div className="rounded-xl border border-border/50 bg-card overflow-hidden">
      <button onClick={() => setOpen(!open)} className="w-full flex items-center justify-between p-4 text-left">
        <h2 className="text-base font-bold text-foreground">
          Type {hairType} <span className="text-muted-foreground font-normal text-sm">({hairType}A–{hairType}C)</span>
        </h2>
        {open ? <ChevronDown className="h-4 w-4 text-accent" /> : <ChevronRight className="h-4 w-4 text-muted-foreground" />}
      </button>
      {open && (
        <div className="px-4 pb-4 space-y-3">
          {OBJECTIVES.map(obj => (
            <ObjectiveCard key={obj.id} objective={obj} hairType={hairType} />
          ))}
        </div>
      )}
    </div>
  );
};

const ObjectiveCard = ({ objective, hairType }: { objective: typeof OBJECTIVES[0]; hairType: number }) => {
  const [open, setOpen] = useState(false);
  const isCurlType1 = objective.id === "curl-definition" && hairType === 1;
  const isVolumeType4 = objective.id === "volume" && hairType === 4;
  const isNA = isCurlType1 || isVolumeType4;
  const products = getProductCategoriesForProfile(hairType, objective.id);
  const nutrients = getNutrientsForObjective(objective.id);

  return (
    <div className="rounded-lg border border-border/30 bg-secondary/20 overflow-hidden">
      <button onClick={() => setOpen(!open)} className="w-full flex items-center justify-between p-3 text-left">
        <div className="flex items-center gap-2 min-w-0">
          <span className={`rounded-full px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
            objective.type === "fundamental" ? "gradient-primary text-primary-foreground" : "bg-accent/20 text-accent"
          }`}>
            {objective.type === "fundamental" ? "Fund" : "Add"}
          </span>
          <span className="text-sm font-semibold text-foreground truncate">{objective.name}</span>
          {isNA && (
            <span className="rounded-md bg-destructive/20 px-2 py-0.5 text-[9px] text-destructive-foreground font-medium">
              N/A for Type {hairType}
            </span>
          )}
        </div>
        {open ? <ChevronDown className="h-3.5 w-3.5 text-accent shrink-0" /> : <ChevronRight className="h-3.5 w-3.5 text-muted-foreground shrink-0" />}
      </button>
      {open && (
        <div className="px-3 pb-3 space-y-3">
          {/* Product Categories */}
          <div>
            <p className="text-[10px] uppercase tracking-wider text-accent mb-2 font-bold">Product Categories</p>
            {isNA ? (
              <p className="text-xs text-muted-foreground italic">Not applicable to Type {hairType}.</p>
            ) : products.length === 0 ? (
              <p className="text-xs text-muted-foreground italic">No product categories mapped.</p>
            ) : (
              <div className="space-y-2">
                {products.map(pc => (
                  <ProductCategoryRow key={pc.code} pc={pc} />
                ))}
              </div>
            )}
          </div>

          {/* Amazon Products */}
          {!isNA && products.length > 0 && (
            <div className="border-t border-border/20 pt-2">
              <p className="text-[10px] uppercase tracking-wider text-accent mb-2 font-bold">Validated Products</p>
              <div className="space-y-2">
                {products.map(pc => {
                  const amazonProducts = AMAZON_PRODUCTS.filter(p => p.product_category_code === pc.code);
                  return amazonProducts.map(ap => (
                    <AuditProductCard key={ap.id} product={ap} />
                  ));
                })}
              </div>
            </div>
          )}

          {/* Nutrients */}
          <div className="border-t border-border/20 pt-2">
            <p className="text-[10px] uppercase tracking-wider text-accent mb-2 font-bold">Related Nutrients</p>
            {nutrients.length === 0 ? (
              <p className="text-xs text-muted-foreground italic">No nutrients mapped.</p>
            ) : (
              <div className="flex flex-wrap gap-1">
                {nutrients.map(n => (
                  <span key={n.id} className={`rounded-full px-2 py-0.5 text-[10px] font-medium ${
                    n.priority === "core" ? "bg-primary/20 text-accent border border-primary/30" : "bg-secondary/50 text-secondary-foreground"
                  }`}>
                    {n.name} {n.priority === "core" ? "●" : "○"}
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

const ProductCategoryRow = ({ pc }: { pc: ProductCategory }) => (
  <div className="rounded-md bg-background/50 border border-border/20 p-2">
    <div className="flex items-center gap-2 flex-wrap">
      <span className="text-[10px] text-accent font-bold uppercase">{pc.step}</span>
      <span className="font-mono text-[11px] text-primary font-bold bg-primary/10 rounded px-1.5 py-0.5">{pc.code}</span>
      <span className="text-xs text-foreground font-medium">{pc.name}</span>
      <span className="rounded-md bg-secondary/40 px-1.5 py-0.5 text-[9px] text-muted-foreground">{pc.generic_category}</span>
      <span className={`rounded-md px-1.5 py-0.5 text-[9px] font-medium ${
        pc.weight === "light" ? "bg-sky-500/15 text-sky-400" :
        pc.weight === "medium" ? "bg-violet-500/15 text-violet-400" :
        "bg-orange-500/15 text-orange-400"
      }`}>{pc.weight}</span>
      {pc.multi_objective && (
        <span className="rounded-md bg-amber-500/20 px-1.5 py-0.5 text-[9px] text-amber-300 font-medium">Multi-Obj</span>
      )}
    </div>
  </div>
);

const AuditProductCard = ({ product }: { product: AmazonProduct }) => {
  const isDuplicate = product.is_duplicate_url || (product.amazon_url_clean !== "#" && duplicateUrls.has(product.amazon_url_clean));
  const sharedCodes = isDuplicate && product.amazon_url_clean !== "#" ? duplicateUrls.get(product.amazon_url_clean) : null;

  return (
    <div className={`rounded-lg border p-3 ${
      product.status === "missing" ? "border-destructive/40 bg-destructive/5" :
      isDuplicate ? "border-amber-500/30 bg-amber-500/5" :
      "border-border/20 bg-background/50"
    }`}>
      <div className="flex items-start justify-between gap-2 mb-2">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap mb-1">
            <span className="font-mono text-[11px] text-primary font-bold bg-primary/10 rounded px-1.5 py-0.5">{product.product_category_code}</span>
            {statusBadge(product.status)}
            {isDuplicate && (
              <span className="flex items-center gap-0.5 rounded-full bg-amber-500/20 px-2 py-0.5 text-[9px] text-amber-400 font-medium">
                <Copy className="h-2.5 w-2.5" /> Duplicate URL
              </span>
            )}
          </div>
          <p className="text-xs font-semibold text-foreground">{product.title}</p>
          <p className="text-[10px] text-muted-foreground">{product.brand}</p>
        </div>
      </div>

      {product.status !== "missing" && (
        <>
          <div className="grid grid-cols-2 gap-x-3 gap-y-1 text-[10px] mb-2">
            <div><span className="text-muted-foreground">ASIN:</span> <span className="font-mono text-accent">{product.asin || "—"}</span></div>
            <div><span className="text-muted-foreground">Domain:</span> <span className="text-foreground">amazon.fr</span></div>
            <div><span className="text-muted-foreground">Weight:</span> <span className={`font-medium ${
              product.weight === "light" ? "text-sky-400" : product.weight === "medium" ? "text-violet-400" : "text-orange-400"
            }`}>{product.weight}</span></div>
            <div><span className="text-muted-foreground">Tier:</span> <span className="text-foreground">{product.price_tier}</span></div>
            <div className="col-span-2"><span className="text-muted-foreground">Types:</span> <span className="text-foreground">{product.hair_types.join(", ")}</span></div>
          </div>

          <div className="mb-2">
            <p className="text-[9px] text-muted-foreground mb-1">CLEAN URL</p>
            <a href={product.amazon_url_clean} target="_blank" rel="noopener noreferrer" className="text-[10px] text-primary underline break-all flex items-center gap-1">
              {product.amazon_url_clean} <ExternalLink className="h-2.5 w-2.5 shrink-0" />
            </a>
          </div>

          {product.tags.length > 0 && (
            <div className="flex flex-wrap gap-1">
              {product.tags.map(t => (
                <span key={t} className="rounded-md bg-secondary/50 px-1.5 py-0.5 text-[10px] text-secondary-foreground">{t}</span>
              ))}
            </div>
          )}

          {isDuplicate && sharedCodes && (
            <div className="mt-2 flex items-center gap-1 text-[10px] text-amber-400">
              <AlertTriangle className="h-3 w-3 shrink-0" />
              Shared URL with codes: {sharedCodes.join(", ")}
            </div>
          )}
        </>
      )}

      {product.status === "missing" && (
        <div className="flex items-center gap-1.5 mt-1 text-[10px] text-destructive-foreground">
          <XCircle className="h-3 w-3 shrink-0" />
          Product URL not yet provided. Keep as placeholder.
        </div>
      )}
    </div>
  );
};

const DbAudit = () => {
  const missingProducts = AMAZON_PRODUCTS.filter(p => p.status === "missing");
  const duplicateProducts = AMAZON_PRODUCTS.filter(p => p.is_duplicate_url);

  return (
    <div className="mx-auto min-h-screen max-w-[430px] bg-background px-4 py-8">
      {/* Header */}
      <div className="mb-6">
        <span className="rounded-full bg-destructive/20 px-2.5 py-0.5 text-[9px] font-bold uppercase text-destructive-foreground tracking-wider">
          Hidden Route
        </span>
        <h1 className="mt-2 text-xl font-bold text-foreground">Internal Database Audit</h1>
        <p className="text-xs text-muted-foreground">For verification only — not user-facing</p>
      </div>

      {/* Warnings Banner */}
      {(missingProducts.length > 0 || duplicateProducts.length > 0) && (
        <div className="mb-6 space-y-2">
          {missingProducts.length > 0 && (
            <div className="rounded-xl border border-destructive/30 bg-destructive/10 p-3">
              <div className="flex items-center gap-2 mb-1">
                <XCircle className="h-4 w-4 text-destructive-foreground" />
                <p className="text-xs font-bold text-destructive-foreground">Missing Products ({missingProducts.length})</p>
              </div>
              {missingProducts.map(p => (
                <p key={p.id} className="text-[10px] text-muted-foreground ml-6">Code {p.product_category_code}: {p.notes_short}</p>
              ))}
            </div>
          )}
          {duplicateProducts.length > 0 && (
            <div className="rounded-xl border border-amber-500/30 bg-amber-500/10 p-3">
              <div className="flex items-center gap-2 mb-1">
                <Copy className="h-4 w-4 text-amber-400" />
                <p className="text-xs font-bold text-amber-400">Duplicate URLs ({duplicateProducts.length})</p>
              </div>
              {duplicateProducts.map(p => (
                <p key={p.id} className="text-[10px] text-muted-foreground ml-6">Code {p.product_category_code}: {p.title} → {p.amazon_url_clean}</p>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Hair Type Sections */}
      <div className="space-y-3 mb-8">
        {HAIR_TYPES.map(ht => (
          <HairTypeSection key={ht} hairType={ht} />
        ))}
      </div>

      {/* Global Nutrient Coverage */}
      <div className="rounded-xl border border-border/50 bg-card p-4">
        <h2 className="text-base font-bold text-foreground mb-1">Global Nutrient Coverage</h2>
        <p className="text-[10px] text-muted-foreground mb-4">Coverage based on objective-to-nutrient mappings (internal support, not topical actives)</p>
        <div className="grid grid-cols-1 gap-1.5">
          {GLOBAL_NUTRIENT_IDS.map(nid => {
            const nutrient = NUTRIENTS.find(n => n.id === nid);
            const covered = allMappedNutrientIds.has(nid);
            return (
              <div key={nid} className="flex items-center gap-2 rounded-md bg-secondary/20 px-3 py-2">
                {covered ? <Check className="h-3.5 w-3.5 text-emerald-400 shrink-0" /> : <Minus className="h-3.5 w-3.5 text-muted-foreground shrink-0" />}
                <span className={`text-xs ${covered ? "text-foreground" : "text-muted-foreground"}`}>{nutrient?.name || nid}</span>
              </div>
            );
          })}
        </div>
      </div>

      <div className="mt-6 text-center">
        <p className="text-[9px] text-muted-foreground">
          {PRODUCT_CATEGORIES.length} product categories · {AMAZON_PRODUCTS.length} products · {NUTRIENTS.length} nutrients · {OBJECTIVE_NUTRIENTS.length} mappings
        </p>
        <p className="text-[9px] text-muted-foreground mt-1">
          {AMAZON_PRODUCTS.filter(p => p.status === "active").length} active · {missingProducts.length} missing · {duplicateProducts.length} duplicate URLs
        </p>
      </div>
    </div>
  );
};

export default DbAudit;
