/// A user-defined label used to group [Project]s, with a color the user
/// picks so categories stay visually distinguishable.
class ProjectCategory {
  const ProjectCategory({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  final String id;
  final String name;
  final int colorValue;
}
