import 'package:flutter/material.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_palette.dart';
import '../../classroom/data/classroom_store.dart';
import '../../home/data/home_content.dart';
import '../../home/ui/home_actions.dart';
import '../../home/ui/widgets/home_banner.dart';
import '../../home/ui/widgets/home_header.dart';
import '../../schedule/ui/widgets/schedule_add_button.dart';
import '../../schedule/ui/widgets/schedule_month_nav.dart';
import '../data/models/payment_filter.dart';
import '../data/models/payment_status.dart';
import '../data/models/payments_summary.dart';
import '../data/models/payments_tab.dart';
import '../data/payments_content.dart';
import '../data/payments_store.dart';
import 'payment_actions_sheet.dart';
import 'payment_filter_sheet.dart';
import 'payments_actions.dart';
import 'student_payment_sheet.dart';
import 'widgets/payments_groups_section.dart';
import 'widgets/payments_search_field.dart';
import 'widgets/payments_students_section.dart';
import 'widgets/payments_summary_row.dart';
import 'widgets/payments_tab_switch.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentsTab _tab = PaymentsTab.students;
  DateTime _month = DateFormatter.monthStart(DateTime.now());
  String _query = '';
  PaymentFilter _filter = const PaymentFilter();

  void _shift(int step) {
    setState(() => _month = DateFormatter.addMonths(_month, step));
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _month = DateFormatter.monthStart(picked));
  }

  Future<void> _openFilter(PaymentFilter current) async {
    final result = await PaymentFilterSheet.show(context, current);
    if (result == null || !mounted) return;
    setState(() => _filter = result);
  }

  void _selectStatus(PaymentStatus? status, PaymentFilter current) {
    setState(() {
      _filter = PaymentFilter(
        status: status == current.status ? null : status,
        groupId: current.groupId,
      );
    });
  }

  void _openGroup(String groupId) {
    setState(() {
      _filter = PaymentFilter(groupId: groupId);
      _tab = PaymentsTab.students;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);
    final classroom = ClassroomStore.instance;
    final payments = PaymentsStore.instance;
    final session = AppSession.instance;

    return ColoredBox(
      color: palette.background,
      child: AdaptiveContentWrapper(
        child: ListenableBuilder(
          listenable: Listenable.merge([classroom, payments, session]),
          builder: (context, _) {
            final name = session.firstName.isEmpty
                ? HomeContent.userName
                : session.firstName;
            final staleGroup =
                _filter.groupId != null &&
                classroom.groupById(_filter.groupId!) == null;
            final filter = staleGroup
                ? PaymentFilter(status: _filter.status)
                : _filter;
            final all = payments.entries(_month);
            final summary = PaymentsSummary.of(all);
            final entries = payments.entries(
              _month,
              query: _query,
              filter: filter,
            );
            final monthNav = ScheduleMonthNav(
              label: DateFormatter.monthYear(_month),
              onPrevious: () => _shift(-1),
              onNext: () => _shift(1),
              onPickDate: _pickMonth,
            );

            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    padding.top + 12.h,
                    16.w,
                    padding.bottom + 170.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeHeader(
                        name: name,
                        onNotifications: () => HomeActions.comingSoon(context),
                      ),
                      verticalSpace(height: 18),
                      const HomeBanner(
                        title: PaymentsContent.bannerTitle,
                        description: PaymentsContent.bannerDescription,
                        image: AppAssets.paymentsBanner,
                      ),
                      verticalSpace(height: 16),
                      PaymentsTabSwitch(
                        tab: _tab,
                        onChanged: (tab) => setState(() => _tab = tab),
                      ),
                      verticalSpace(height: 14),
                      if (_tab == PaymentsTab.students) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: PaymentsSearchField(
                                onChanged: (value) =>
                                    setState(() => _query = value),
                              ),
                            ),
                            horizontalSpace(width: 10),
                            Expanded(flex: 4, child: monthNav),
                          ],
                        ),
                        verticalSpace(height: 14),
                        PaymentsSummaryRow(
                          summary: summary,
                          selected: filter.status,
                          onSelect: (status) => _selectStatus(status, filter),
                        ),
                        verticalSpace(height: 14),
                        PaymentsStudentsSection(
                          entries: entries,
                          hasStudents: all.isNotEmpty,
                          filterActive: filter.isActive,
                          onFilter: () => _openFilter(filter),
                          onTap: (id) =>
                              StudentPaymentSheet.show(context, id, _month),
                          onMenu: (id) =>
                              PaymentActionsSheet.show(context, id, _month),
                        ),
                      ] else ...[
                        monthNav,
                        verticalSpace(height: 14),
                        PaymentsGroupsSection(
                          groups: payments.groupSummaries(_month),
                          onTap: _openGroup,
                        ),
                      ],
                    ],
                  ),
                ),
                PositionedDirectional(
                  end: 16.w,
                  bottom: padding.bottom + 96.h,
                  child: ScheduleAddButton(
                    label: PaymentsContent.addPayment,
                    onTap: () => PaymentsActions.addPayment(context, _month),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
