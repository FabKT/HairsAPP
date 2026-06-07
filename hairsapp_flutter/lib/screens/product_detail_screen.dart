import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final AmazonProduct product;
  final ProductCategory? category;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.category,
  });

  static const _stepLabels = {
    'Cleanse': 'Lavage',
    'Treat': 'Soin',
    'Condition': 'Apres-shampoing',
    'Protect': 'Protection',
  };

  static const _tierLabels = {
    'budget': 'Budget',
    'mid': 'Milieu de gamme',
    'premium': 'Premium',
  };

  static const _tierPrice = {
    'budget': '~5 - 20 EUR',
    'mid': '~20 - 45 EUR',
    'premium': '~45 - 100 EUR',
  };

  Color _tierColor(BuildContext context) {
    switch (product.priceTier) {
      case 'budget':
        return AppColors.emerald;
      case 'premium':
        return AppColors.amber;
      default:
        return AppColors.accent;
    }
  }

  String _hairTypeLabel(int t) {
    switch (t) {
      case 1:
        return 'Type 1 — Lisse';
      case 2:
        return 'Type 2 — Ondule';
      case 3:
        return 'Type 3 — Boucle';
      case 4:
        return 'Type 4 — Coily';
      default:
        return 'Type $t';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = product.amazonAffiliateUrl != '#' &&
        product.amazonAffiliateUrl.isNotEmpty;
    final cat = category ??
        kProductCategories
            .where((c) => c.code == product.productCategoryCode)
            .firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero image + back button ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: AppColors.card.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back,
                        size: 20, color: AppColors.foreground),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _BigImagePlaceholder(),
                    )
                  : const _BigImagePlaceholder(),
            ),
          ),

          // ── Content ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                // ── Brand + tier badge ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _tierColor(context).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _tierColor(context).withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        _tierLabels[product.priceTier] ?? product.priceTier,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _tierColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Title ──
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),

                // ── Price range ──
                Text(
                  _tierPrice[product.priceTier] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Notes ──
                _Section(
                  title: 'Description',
                  icon: Icons.info_outline,
                  child: Text(
                    product.notesShort,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Key actives ──
                _Section(
                  title: 'Actifs cles',
                  icon: Icons.science_outlined,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.keyActives.map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          a,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Category & step ──
                if (cat != null) ...[
                  _Section(
                    title: 'Categorie',
                    icon: Icons.category_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          label: 'Etape',
                          value:
                              _stepLabels[cat.step] ?? cat.step,
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Famille',
                          value: cat.genericCategory,
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Formule',
                          value: cat.name,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // ── Hair types ──
                _Section(
                  title: 'Types capillaires recommandes',
                  icon: Icons.people_outline,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.hairTypes.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _hairTypeLabel(t),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.foreground,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Weight ──
                _Section(
                  title: 'Texture',
                  icon: Icons.water_drop_outlined,
                  child: _WeightRow(weight: product.weight),
                ),
                const SizedBox(height: 28),

                // ── Amazon CTA ──
                if (hasUrl) ...[
                  _AmazonCta(url: product.amazonAffiliateUrl),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Lien partenaire Amazon.fr',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.mutedForeground),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section card ───────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(radius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      )),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Info row ───────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Weight visual row ──────────────────────────────────────────────────────────

class _WeightRow extends StatelessWidget {
  final String weight;

  const _WeightRow({required this.weight});

  @override
  Widget build(BuildContext context) {
    const levels = ['light', 'medium', 'heavy'];
    const labels = {'light': 'Legere', 'medium': 'Moyenne', 'heavy': 'Riche'};
    final active = levels.indexOf(weight);

    return Row(
      children: List.generate(3, (i) {
        final on = i <= active;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: on
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : AppColors.secondary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: on
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                labels[levels[i]] ?? levels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: on ? AppColors.accent : AppColors.mutedForeground,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Big Amazon CTA ─────────────────────────────────────────────────────────────

class _AmazonCta extends StatelessWidget {
  final String url;
  const _AmazonCta({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Voir sur Amazon.fr',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.open_in_new, size: 14, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

// ── Big image placeholder ──────────────────────────────────────────────────────

class _BigImagePlaceholder extends StatelessWidget {
  const _BigImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary.withValues(alpha: 0.4),
      child: const Center(
        child: Icon(Icons.science_outlined,
            size: 56, color: AppColors.mutedForeground),
      ),
    );
  }
}
