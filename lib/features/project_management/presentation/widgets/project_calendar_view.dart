import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _CalendarEvent {
  const _CalendarEvent({
    required this.project,
    required this.title,
    required this.isProjectDueDate,
  });

  final Project project;
  final String title;
  final bool isProjectDueDate;
}

/// Custom month-grid calendar (no third-party dependency) showing project
/// and task due dates as dots on their day; selecting a day lists the
/// matching projects/tasks below the grid.
class ProjectCalendarView extends StatefulWidget {
  const ProjectCalendarView({
    required this.projects,
    required this.onOpenProject,
    super.key,
  });

  final List<Project> projects;
  final ValueChanged<Project> onOpenProject;

  @override
  State<ProjectCalendarView> createState() => _ProjectCalendarViewState();
}

class _ProjectCalendarViewState extends State<ProjectCalendarView> {
  late DateTime _visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime? _selectedDay = DateTime.now();

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  Map<DateTime, List<_CalendarEvent>> get _eventsByDay {
    final map = <DateTime, List<_CalendarEvent>>{};
    for (final project in widget.projects) {
      if (project.dueDate != null) {
        map
            .putIfAbsent(_dateOnly(project.dueDate!), () => [])
            .add(
              _CalendarEvent(
                project: project,
                title: project.name,
                isProjectDueDate: true,
              ),
            );
      }
      for (final task in project.tasks) {
        if (task.dueDate != null) {
          map
              .putIfAbsent(_dateOnly(task.dueDate!), () => [])
              .add(
                _CalendarEvent(
                  project: project,
                  title: task.title,
                  isProjectDueDate: false,
                ),
              );
        }
      }
    }
    return map;
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final events = _eventsByDay;
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month);
    final daysInMonth = DateUtils.getDaysInMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );
    final leadingBlanks = (firstOfMonth.weekday - DateTime.monday) % 7;
    final selectedEvents = _selectedDay == null
        ? const <_CalendarEvent>[]
        : events[_dateOnly(_selectedDay!)] ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              DateFormat.yMMMM().format(_visibleMonth),
              style: theme.textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: List.generate(7, (index) {
            final weekday = DateFormat.E().format(DateTime(2024, 1, 1 + index));
            return Expanded(
              child: Center(
                child: Text(
                  weekday,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final day = DateTime(
              _visibleMonth.year,
              _visibleMonth.month,
              index - leadingBlanks + 1,
            );
            final dayEvents = events[_dateOnly(day)] ?? const [];
            final isSelected =
                _selectedDay != null && _dateOnly(_selectedDay!) == day;
            final isToday = _dateOnly(DateTime.now()) == day;
            return InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              onTap: () => setState(() => _selectedDay = day),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: isToday
                      ? Border.all(color: theme.colorScheme.primary)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${day.day}', style: theme.textTheme.bodyMedium),
                    if (dayEvents.isNotEmpty)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const Divider(),
        Expanded(
          child: selectedEvents.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.event_available_outlined,
                  title: l10n.projectManagementNoEventsOnDay,
                  message: l10n.projectManagementNoEventsOnDay,
                )
              : ListView(
                  children: selectedEvents
                      .map(
                        (event) => ListTile(
                          leading: Icon(
                            event.isProjectDueDate
                                ? Icons.folder_outlined
                                : Icons.check_circle_outline,
                          ),
                          title: Text(event.title),
                          subtitle: event.isProjectDueDate
                              ? null
                              : Text(event.project.name),
                          onTap: () => widget.onOpenProject(event.project),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
