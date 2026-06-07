import 'package:flutter/material.dart';
import '../data/hair_data.dart';
import '../theme/app_theme.dart';
import '../utils/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HairProfile? _profile;
  bool _updating = false;

  static const _healthScore = 78;
  static const _miniTrend = [62, 68, 74, 78];
  static const _miniLabels = ['W1', 'W2', 'W3', 'W4'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await Storage.loadProfile();
    if (mounted) setState(() => _profile = p);
  }

  HairType? get _typeData => _profile != null
      ? kHairTypes.firstWhere((t) => t.type == _profile!.hairType)
      : null;

  Objective? get _addObj {
    if (_profile?.additionalObjective == null) return null;
    try {
      return kAdditionalObjectives
          .firstWhere((a) => a.id == _profile!.additionalObjective);
    } catch (_) {
      return null;
    }
  }

  Future<void> _updateProfile(HairProfile updated) async {
    await Storage.saveProfile(updated);
    if (!mounted) return;
    setState(() {
      _profile = updated;
      _updating = true;
    });
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _updating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Text('Your hair health control center',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          _buildHealthScore(context),
          const SizedBox(height: 12),
          _buildProfileOverview(context),
          const SizedBox(height: 12),
          _buildProtocolParameters(context),
          const SizedBox(height: 12),
          _buildPlanControl(context),
          const SizedBox(height: 12),
          _buildHistory(context),
        ],
      ),
    );
  }

  Widget _buildHealthScore(BuildContext context) {
    final maxTrend = _miniTrend.reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CustomPaint(
                      size: Size(80, 80),
                      painter: _ScoreRingPainter(score: _healthScore)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFB385E0), Color(0xFF9966CC)],
                        ).createShader(bounds),
                        child: const Text('$_healthScore',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const Text('/ 100',
                          style: TextStyle(
                              fontSize: 8, color: AppColors.mutedForeground)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hair Health Score',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text('Based on adherence and symptom trends',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(height: 1.3)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(_miniTrend.length, (i) {
                        final val = _miniTrend[i];
                        final isLast = i == _miniTrend.length - 1;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: FractionallySizedBox(
                                    heightFactor: val / maxTrend,
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: isLast
                                            ? AppColors.primaryGradient
                                            : null,
                                        color: isLast
                                            ? null
                                            : AppColors.primary
                                                .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(_miniLabels[i],
                                    style: const TextStyle(
                                        fontSize: 7,
                                        color: AppColors.mutedForeground)),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hair Profile',
                    style: Theme.of(context).textTheme.titleSmall),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 13),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_profile != null)
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1)
                },
                children: [
                  [
                    'Hair Type',
                    '${_profile!.hairType}${_profile!.hairSubtype} — ${_typeData?.label ?? ""}'
                  ],
                  ['Category', _typeData?.label ?? ''],
                  ['Additional Objective', _addObj?.name ?? 'None'],
                  ['Plan Version', 'v1'],
                ]
                    .map((pair) => TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pair[0],
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                                Text(pair[1],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color:
                                                AppColors.secondaryForeground,
                                            fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(),
                        ]))
                    .toList(),
              )
            else
              Text('Complete onboarding to set up your profile.',
                  style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildTag('Hydration', primary: true),
                _buildTag('Repair'),
                _buildTag('Scalp Balance'),
                _buildTag('Protection'),
                if (_addObj?.name != null) _buildTag(_addObj!.name, soft: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolParameters(BuildContext context) {
    final hairTypeOptions = kHairTypes
        .expand((ht) => ht.subtypes.map((st) => (
              label: '${ht.type}${st.letter} — ${ht.label} (${st.desc})',
              type: ht.type,
              letter: st.letter,
            )))
        .toList();
    final addObjOptions = [
      (label: 'None', id: null as String?),
      ...kAdditionalObjectives.map((a) => (label: a.name, id: a.id as String?)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 2),
          child: Text('Protocol Parameters',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        if (_updating)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                gradient: AppColors.primarySoftGradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2))),
            child: const Row(children: [
              Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
              SizedBox(width: 8),
              Text('Updating your weekly routine...',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
        Container(
          decoration: cardDecoration(),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              children: [
                ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  childrenPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline,
                      size: 16, color: AppColors.accent),
                  title: Text('Hair Type',
                      style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text(
                    _profile != null
                        ? '${_profile!.hairType}${_profile!.hairSubtype} — ${_typeData?.label ?? ""}'
                        : 'Not defined',
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  iconColor: AppColors.mutedForeground,
                  collapsedIconColor: AppColors.mutedForeground,
                  children: [
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: hairTypeOptions.map((opt) {
                          final isSelected = _profile?.hairType == opt.type &&
                              _profile?.hairSubtype == opt.letter;
                          return _OptionTile(
                            label: opt.label,
                            isSelected: isSelected,
                            onTap: () => _profile != null
                                ? _updateProfile(_profile!.copyWith(
                                    hairType: opt.type,
                                    hairSubtype: opt.letter))
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 0, indent: 14),
                ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  childrenPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.track_changes_outlined,
                      size: 16, color: AppColors.accent),
                  title: Text('Additional Objective',
                      style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text(_addObj?.name ?? 'None',
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  iconColor: AppColors.mutedForeground,
                  collapsedIconColor: AppColors.mutedForeground,
                  children: [
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: addObjOptions.map((opt) {
                          final isSelected =
                              (_profile?.additionalObjective) == opt.id;
                          return _OptionTile(
                            label: opt.label,
                            isSelected: isSelected,
                            onTap: () {
                              if (_profile != null) {
                                if (opt.id == null) {
                                  _updateProfile(_profile!
                                      .copyWith(clearAdditional: true));
                                } else {
                                  _updateProfile(_profile!
                                      .copyWith(additionalObjective: opt.id));
                                }
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanControl(BuildContext context) {
    final actions = [
      (
        icon: Icons.refresh,
        label: 'Regenerate Weekly Plan',
        desc: 'Create a new routine based on your current profile'
      ),
      (
        icon: Icons.track_changes_outlined,
        label: 'Switch Primary Objective',
        desc: 'Change the focus of your hair care'
      ),
      (
        icon: Icons.tune,
        label: 'Adjust Frequency',
        desc: 'Change your wash and treatment days'
      ),
      (
        icon: Icons.restart_alt,
        label: 'Reset Routine',
        desc: 'Start over with a full assessment'
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 2),
          child: Text('Plan Control',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        Container(
          decoration: cardDecoration(),
          child: Column(
            children: List.generate(actions.length, (i) {
              final a = actions[i];
              return Column(
                children: [
                  if (i > 0) const Divider(height: 0, indent: 56),
                  ListTile(
                    onTap: () {},
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(a.icon, size: 18, color: AppColors.accent),
                    ),
                    title: Text(a.label,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 12)),
                    subtitle: Text(a.desc,
                        style: Theme.of(context).textTheme.labelSmall),
                    trailing: const Icon(Icons.chevron_right,
                        size: 16, color: AppColors.mutedForeground),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(BuildContext context) {
    final cards = [
      (
        icon: Icons.history,
        label: 'Protocol History',
        sub: '3 routines generated'
      ),
      (
        icon: Icons.bar_chart,
        label: 'Score Evolution',
        sub: '+16 pts in 7 weeks'
      ),
      (
        icon: Icons.favorite_border,
        label: 'Symptom Trends',
        sub: 'Shedding down, comfort up'
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 2),
          child: Text('History & Data',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        Row(
          children: cards
              .map((c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(c.icon, size: 20, color: AppColors.accent),
                              const SizedBox(height: 6),
                              Text(c.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.foreground,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(c.sub,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(height: 1.2),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTag(String label, {bool primary = false, bool soft = false}) {
    if (primary) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          gradient: soft ? AppColors.primarySoftGradient : null,
          color: soft ? null : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: soft
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
              : null),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10,
              color: AppColors.accent,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  const _OptionTile(
      {required this.label, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
                : null,
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.foreground
                      : AppColors.secondaryForeground)),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final int score;
  const _ScoreRingPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.width - 12) / 2;

    canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = const Color(0xFF1E1F2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6);

    final fgPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -3.14159 / 2,
        endAngle: 3.14159 * 1.5,
        colors: [Color(0xFF7C2BEE), Color(0xFFB447EB)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * (score / 100),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
