/// A user-defined folder used to organize [Project]s into a tree. A `null`
/// [parentId] means the folder sits at the root of the tree; otherwise it is
/// nested under the folder with that id, so folders can be arbitrarily deep.
class ProjectFolder {
  const ProjectFolder({required this.id, required this.name, this.parentId});

  final String id;
  final String name;
  final String? parentId;

  ProjectFolder withName(String name) {
    return ProjectFolder(id: id, name: name, parentId: parentId);
  }
}
