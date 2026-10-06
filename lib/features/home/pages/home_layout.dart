import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/home/widgets/announcement_banner.dart';
import 'package:neighbour_alert/features/home/widgets/dashboard_header.dart';
import 'package:neighbour_alert/features/home/widgets/dashboard_panic_button.dart';
import 'package:neighbour_alert/features/home/widgets/dashboard_quick_actions.dart';
import 'package:neighbour_alert/features/home/widgets/visitor_card.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(child: DashboardHeader()),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(child: AnnouncementBanner()),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(child: VisitorCard()),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 28),
          sliver: SliverToBoxAdapter(
            child: Center(child: DashboardPanicButton()),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverToBoxAdapter(child: DashboardQuickActions()),
        ),
      ],
    );
  }
}
