/// Barrel file re-exporting every shared widget, so feature modules can
/// `import 'package:aetherdesk/core/widgets/core_widgets.dart';` once
/// instead of importing each widget file individually.
library;

export 'buttons/primary_button.dart';
export 'dialogs/app_alert_dialog.dart';
export 'inputs/app_text_field.dart';
export 'layout/empty_state_widget.dart';
export 'layout/error_view.dart';
export 'layout/module_placeholder_page.dart';
export 'layout/responsive_content_wrapper.dart';
export 'loaders/app_loading_indicator.dart';
