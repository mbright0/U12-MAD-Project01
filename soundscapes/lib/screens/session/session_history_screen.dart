import 'package:flutter/material.dart';

import 'session_setup_screen.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [

        SliverAppBar(
          floating: true,
          snap: true,
          title: Text(
            'Sessions',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: 'Filter sessions',
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Search sessions…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
        ),

        _SectionHeader(label: 'Today'),
        SliverList(
          delegate: SliverChildListDelegate([
            _SessionRow(
              name: 'Research Paper',
              meta: 'Reading · 😤 Focused · ⚡7',
              duration: '25:00',
              score: '★ 4.5',
              scoreColor: Colors.green.shade600,
            ),
            _SessionRow(
              name: 'Flutter Assignment',
              meta: 'Coding · 😌 Calm · ⚡5',
              duration: '12:34',
              score: 'In Progress',
              scoreColor: Colors.amber.shade700,
            ),
          ]),
        ),

        _SectionHeader(label: 'Yesterday'),
        SliverList(
          delegate: SliverChildListDelegate([
            _SessionRow(
              name: 'Essay Draft v2',
              meta: 'Writing · 😊 Motivated · ⚡8',
              duration: '50:00',
              score: '★ 5.0',
              scoreColor: Colors.green.shade600,
            ),
            _SessionRow(
              name: 'Math Practice',
              meta: 'Study · 😐 Neutral · ⚡4',
              duration: '20:00',
              score: '★ 3.0',
              scoreColor: Colors.amber.shade700,
            ),
          ]),
        ),

        // FAB spacing
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.name,
    required this.meta,
    required this.duration,
    required this.score,
    required this.scoreColor,
  });

  final String name;
  final String meta;
  final String duration;
  final String score;
  final Color scoreColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: cs.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(meta,
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(duration,
                    style: tt.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(score,
                    style: tt.labelSmall?.copyWith(
                        color: scoreColor, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
