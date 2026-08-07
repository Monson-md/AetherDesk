// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AetherDesk';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAiAssistant => 'AI Assistant';

  @override
  String get navCodeEditor => 'Code Editor';

  @override
  String get navProjectManagement => 'Project Management';

  @override
  String get navSecureVault => 'Secure Vault';

  @override
  String get navCyberWorkspace => 'Cyber Workspace';

  @override
  String get navCreation2d => '2D Creation';

  @override
  String get navCreation3d => '3D Creation';

  @override
  String get navSettings => 'Settings';

  @override
  String get navUserProfile => 'Profile';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'This module is under construction.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRename => 'Rename';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage => 'Please try again later.';

  @override
  String get chatEmptyTitle => 'How can I help you?';

  @override
  String get chatEmptyMessage =>
      'Ask a question or pick a suggestion to get started.';

  @override
  String get chatSuggestionGenerateCode => 'Generate code';

  @override
  String get chatSuggestionDebug => 'Debug a program';

  @override
  String get chatSuggestionExplain => 'Explain a concept';

  @override
  String get chatSuggestionPlan => 'Plan a project';

  @override
  String get chatInputHint => 'Write a message…';

  @override
  String get chatSendTooltip => 'Send';

  @override
  String get chatThinking => 'The AI is thinking…';

  @override
  String get codeEditorNewFile => 'New file';

  @override
  String get codeEditorOpen => 'Open';

  @override
  String get codeEditorSave => 'Save';

  @override
  String get codeEditorCopy => 'Copy';

  @override
  String get codeEditorClear => 'Clear';

  @override
  String get codeEditorEmptyHint => 'Start writing your code here…';

  @override
  String get codeEditorSearch => 'Search';

  @override
  String get codeEditorSearchHint => 'Search in code…';

  @override
  String get codeEditorSearchNoMatches => 'No matches';

  @override
  String codeEditorFileOpenedMessage(String fileName) {
    return 'File opened: $fileName';
  }

  @override
  String codeEditorFileSavedMessage(String fileName) {
    return 'File saved: $fileName';
  }

  @override
  String get codeEditorCopiedMessage => 'Code copied to clipboard.';

  @override
  String codeEditorLinesCount(int count) {
    return '$count lines';
  }

  @override
  String codeEditorCharsCount(int count) {
    return '$count characters';
  }

  @override
  String codeEditorWordsCount(int count) {
    return '$count words';
  }

  @override
  String get projectManagementEmptyTitle => 'No projects yet';

  @override
  String get projectManagementEmptyMessage =>
      'Create your first project to get started.';

  @override
  String get projectManagementNoResultsTitle => 'No results';

  @override
  String get projectManagementNoResultsMessage =>
      'No projects match these filters.';

  @override
  String get projectManagementNewProject => 'New project';

  @override
  String get projectManagementSearchHint => 'Search projects…';

  @override
  String get projectManagementSortLabel => 'Sort by';

  @override
  String get projectManagementSortName => 'Name';

  @override
  String get projectManagementSortDueDate => 'Due date';

  @override
  String get projectManagementSortPriority => 'Priority';

  @override
  String get projectManagementSortCreatedAt => 'Date created';

  @override
  String get projectManagementFavoritesOnly => 'Favorites only';

  @override
  String get projectManagementAllCategories => 'All categories';

  @override
  String get projectManagementNoCategory => 'No category';

  @override
  String get projectManagementNewCategory => 'New category';

  @override
  String get projectManagementCategoryNameHint => 'Category name';

  @override
  String get projectManagementCategoryLabel => 'Category';

  @override
  String get projectManagementPriorityLabel => 'Priority';

  @override
  String get projectManagementPriorityLow => 'Low';

  @override
  String get projectManagementPriorityMedium => 'Medium';

  @override
  String get projectManagementPriorityHigh => 'High';

  @override
  String get projectManagementPriorityUrgent => 'Urgent';

  @override
  String get projectManagementAllPriorities => 'All priorities';

  @override
  String get projectManagementNameLabel => 'Name';

  @override
  String get projectManagementDescriptionLabel => 'Description';

  @override
  String get projectManagementDueDateLabel => 'Due date';

  @override
  String get projectManagementNoDueDate => 'No due date';

  @override
  String get projectManagementPickDate => 'Pick a date';

  @override
  String get projectManagementClearDate => 'Clear date';

  @override
  String get projectManagementCreateProjectTitle => 'Create project';

  @override
  String get projectManagementEditProjectTitle => 'Edit project';

  @override
  String get projectManagementDeleteProjectTitle => 'Delete project';

  @override
  String get projectManagementDeleteProjectMessage =>
      'This will permanently delete the project and all of its tasks.';

  @override
  String get projectManagementTasksTitle => 'Tasks';

  @override
  String get projectManagementNewTask => 'New task';

  @override
  String get projectManagementEditTaskTitle => 'Edit task';

  @override
  String get projectManagementDeleteTaskTitle => 'Delete task';

  @override
  String get projectManagementDeleteTaskMessage =>
      'This will permanently delete this task.';

  @override
  String get projectManagementTaskTitleLabel => 'Title';

  @override
  String get projectManagementChecklistTitle => 'Checklist';

  @override
  String get projectManagementAddChecklistItemHint => 'Add an item…';

  @override
  String get projectManagementNoTasksYet => 'No tasks in this project yet.';

  @override
  String projectManagementTasksCompletedCount(int done, int total) {
    return '$done of $total tasks completed';
  }

  @override
  String get projectManagementDeleteCategoryTitle => 'Delete category';

  @override
  String get projectManagementDeleteCategoryMessage =>
      'Projects in this category will become uncategorized.';

  @override
  String get projectManagementFavoriteTooltip => 'Add to favorites';

  @override
  String get projectManagementUnfavoriteTooltip => 'Remove from favorites';

  @override
  String projectManagementProjectsCount(int count) {
    return '$count projects';
  }

  @override
  String get projectManagementStatusTodo => 'To do';

  @override
  String get projectManagementStatusInProgress => 'In progress';

  @override
  String get projectManagementStatusDone => 'Done';

  @override
  String get projectManagementTagsLabel => 'Tags';

  @override
  String get projectManagementTagsHint => 'Add a tag and press Enter';

  @override
  String get projectManagementAllTags => 'All tags';

  @override
  String get projectManagementFolderLabel => 'Folder';

  @override
  String get projectManagementNoFolder => 'No folder';

  @override
  String get projectManagementFoldersTitle => 'Folders';

  @override
  String get projectManagementAllProjects => 'All projects';

  @override
  String get projectManagementNewFolderTitle => 'New folder';

  @override
  String get projectManagementRenameFolderTitle => 'Rename folder';

  @override
  String get projectManagementFolderNameLabel => 'Folder name';

  @override
  String get projectManagementNewSubfolder => 'New subfolder';

  @override
  String get projectManagementDeleteFolderTitle => 'Delete folder';

  @override
  String get projectManagementDeleteFolderMessage =>
      'Its subfolders and projects will be moved to the root.';

  @override
  String get projectManagementViewList => 'List';

  @override
  String get projectManagementViewKanban => 'Kanban';

  @override
  String get projectManagementViewCalendar => 'Calendar';

  @override
  String get projectManagementNoEventsOnDay => 'No events on this day.';

  @override
  String get secureVaultEmptyTitle => 'The vault is empty';

  @override
  String get secureVaultEmptyMessage => 'Add your first item to get started.';

  @override
  String get secureVaultNoResultsTitle => 'No results';

  @override
  String get secureVaultNoResultsMessage => 'No items match these filters.';

  @override
  String get secureVaultSearchHint => 'Search the vault…';

  @override
  String get secureVaultSortLabel => 'Sort by';

  @override
  String get secureVaultSortTitle => 'Title';

  @override
  String get secureVaultSortCreatedAt => 'Date created';

  @override
  String get secureVaultSortType => 'Type';

  @override
  String get secureVaultFavoritesOnly => 'Favorites only';

  @override
  String get secureVaultAllFolders => 'All folders';

  @override
  String get secureVaultNoFolder => 'No folder';

  @override
  String get secureVaultNewFolder => 'New folder';

  @override
  String get secureVaultFolderNameHint => 'Folder name';

  @override
  String get secureVaultFolderLabel => 'Folder';

  @override
  String get secureVaultAllTypes => 'All types';

  @override
  String get secureVaultTypeSecureNote => 'Secure note';

  @override
  String get secureVaultTypePassword => 'Password';

  @override
  String get secureVaultTypeApiKey => 'API key';

  @override
  String get secureVaultTypeCard => 'Card';

  @override
  String get secureVaultTypeDocument => 'Document';

  @override
  String get secureVaultNewItem => 'New item';

  @override
  String get secureVaultTitleLabel => 'Title';

  @override
  String get secureVaultContentLabel => 'Content';

  @override
  String get secureVaultUsernameLabel => 'Username';

  @override
  String get secureVaultPasswordLabel => 'Password';

  @override
  String get secureVaultUrlLabel => 'Website';

  @override
  String get secureVaultServiceLabel => 'Service';

  @override
  String get secureVaultApiKeyLabel => 'API key';

  @override
  String get secureVaultCardholderLabel => 'Cardholder name';

  @override
  String get secureVaultCardNumberLabel => 'Card number';

  @override
  String get secureVaultExpiryLabel => 'Expiry (MM/YY)';

  @override
  String get secureVaultCvvLabel => 'CVV';

  @override
  String get secureVaultFileNameLabel => 'File name';

  @override
  String get secureVaultNotesLabel => 'Notes';

  @override
  String get secureVaultNewSecureNoteTitle => 'New secure note';

  @override
  String get secureVaultEditSecureNoteTitle => 'Edit note';

  @override
  String get secureVaultNewPasswordTitle => 'New password';

  @override
  String get secureVaultEditPasswordTitle => 'Edit password';

  @override
  String get secureVaultNewApiKeyTitle => 'New API key';

  @override
  String get secureVaultEditApiKeyTitle => 'Edit API key';

  @override
  String get secureVaultNewCardTitle => 'New card';

  @override
  String get secureVaultEditCardTitle => 'Edit card';

  @override
  String get secureVaultNewDocumentTitle => 'New document';

  @override
  String get secureVaultEditDocumentTitle => 'Edit document';

  @override
  String get secureVaultDeleteItemTitle => 'Delete item';

  @override
  String get secureVaultDeleteItemMessage =>
      'This will permanently delete this item.';

  @override
  String get secureVaultDeleteFolderTitle => 'Delete folder';

  @override
  String get secureVaultDeleteFolderMessage =>
      'Items in this folder will become unfiled.';

  @override
  String get secureVaultFavoriteTooltip => 'Add to favorites';

  @override
  String get secureVaultUnfavoriteTooltip => 'Remove from favorites';

  @override
  String get secureVaultRevealTooltip => 'Show';

  @override
  String get secureVaultHideTooltip => 'Hide';

  @override
  String get secureVaultCopyTooltip => 'Copy';

  @override
  String get secureVaultCopiedMessage => 'Copied to clipboard.';

  @override
  String get secureVaultEncryptedAtRestTooltip => 'Encrypted at rest (AES-256)';

  @override
  String get secureVaultBiometricPromptReason =>
      'Authenticate to open the vault';

  @override
  String get secureVaultLockedTitle => 'Vault locked';

  @override
  String get secureVaultUnlockButton => 'Unlock';

  @override
  String secureVaultItemsCount(int count) {
    return '$count items';
  }

  @override
  String get cyberWorkspaceToolIpAnalysis => 'Host analysis';

  @override
  String get cyberWorkspaceToolUrlAnalysis => 'URL analysis';

  @override
  String get cyberWorkspaceToolPortScan => 'Port scanner';

  @override
  String get cyberWorkspaceToolTerminal => 'Terminal';

  @override
  String get cyberWorkspaceIpAddressLabel => 'Host or IP address';

  @override
  String get cyberWorkspaceAnalyzeAction => 'Analyze';

  @override
  String get cyberWorkspaceResolvedAddressesLabel => 'Resolved addresses';

  @override
  String get cyberWorkspaceNoAddressesResolved => 'No address resolved';

  @override
  String get cyberWorkspaceReachableLabel => 'Reachable';

  @override
  String get cyberWorkspaceUnreachableLabel => 'Unreachable';

  @override
  String cyberWorkspaceResponseTimeLabel(int ms) {
    return '$ms ms';
  }

  @override
  String get cyberWorkspaceUrlLabel => 'URL';

  @override
  String get cyberWorkspaceUrlInvalidMessage => 'Invalid URL';

  @override
  String get cyberWorkspaceSchemeLabel => 'Scheme';

  @override
  String get cyberWorkspaceHostLabel => 'Host';

  @override
  String get cyberWorkspaceScanAction => 'Scan';

  @override
  String cyberWorkspacePortsOpenCount(int open, int total) {
    return '$open of $total ports open';
  }

  @override
  String get cyberWorkspaceTerminalHint =>
      'Type \"help\" to see the available commands.';

  @override
  String get cyberWorkspaceTerminalInputHint => 'Enter a command…';

  @override
  String get cyberWorkspaceFavoritesOnly => 'Favorites only';

  @override
  String get cyberWorkspaceAllTools => 'All tools';

  @override
  String get cyberWorkspaceTabDashboard => 'Dashboard';

  @override
  String get cyberWorkspaceTabTools => 'Network tools';

  @override
  String get cyberWorkspaceTabTerminal => 'Terminal';

  @override
  String get cyberWorkspaceTabHistory => 'History';

  @override
  String get cyberWorkspaceTabDevice => 'Device';

  @override
  String get cyberWorkspaceDashboardTitle => 'Overview';

  @override
  String get cyberWorkspaceStatTotalRuns => 'Scans run';

  @override
  String get cyberWorkspaceStatFavorites => 'Favorites';

  @override
  String get cyberWorkspaceQuickActionsTitle => 'Quick actions';

  @override
  String get cyberWorkspaceClearHistory => 'Clear history';

  @override
  String get cyberWorkspaceEmptyHistoryTitle => 'No history yet';

  @override
  String get cyberWorkspaceEmptyHistoryMessage =>
      'Scans you run will show up here.';

  @override
  String get cyberWorkspaceSensorsTitle => 'Sensors';

  @override
  String get cyberWorkspaceAccelerometerLabel => 'Accelerometer';

  @override
  String get cyberWorkspaceGyroscopeLabel => 'Gyroscope';

  @override
  String get cyberWorkspaceMagnetometerLabel => 'Magnetometer';

  @override
  String get cyberWorkspaceFlashlightTitle => 'Flashlight';

  @override
  String get cyberWorkspaceFlashlightUnavailableMessage =>
      'Flashlight is unavailable on this device.';

  @override
  String get cyberWorkspaceFlashlightOnButton => 'Turn on';

  @override
  String get cyberWorkspaceFlashlightOffButton => 'Turn off';

  @override
  String get cyberWorkspaceFlashlightStrobeButton => 'Strobe';

  @override
  String get cyberWorkspaceFlashlightStopStrobeButton => 'Stop strobe';

  @override
  String get cyberWorkspaceQrToolTitle => 'QR code tool';

  @override
  String get cyberWorkspaceQrScanLabel => 'Scan a code';

  @override
  String get cyberWorkspaceQrStartScanButton => 'Start scan';

  @override
  String cyberWorkspaceQrScannedValueLabel(String value) {
    return 'Scanned value: $value';
  }

  @override
  String get cyberWorkspaceQrGenerateLabel => 'Generate a code';

  @override
  String get cyberWorkspaceQrTextToEncodeLabel => 'Text to encode';

  @override
  String get cyberWorkspaceBleScannerTitle => 'Bluetooth (BLE) scanner';

  @override
  String get cyberWorkspaceBleUnsupportedMessage =>
      'Bluetooth Low Energy is not supported on this device.';

  @override
  String get cyberWorkspaceBleStartScanButton => 'Start scan';

  @override
  String get cyberWorkspaceBleStopScanButton => 'Stop scan';

  @override
  String get cyberWorkspaceBleNoDevicesMessage => 'No devices found yet.';

  @override
  String get cyberWorkspaceBleUnknownDeviceLabel => 'Unknown device';

  @override
  String get cyberWorkspaceGpsTitle => 'GPS';

  @override
  String get cyberWorkspaceGpsStartButton => 'Start tracking';

  @override
  String get cyberWorkspaceGpsStopButton => 'Stop tracking';

  @override
  String get cyberWorkspaceGpsNoFixMessage => 'No position yet.';

  @override
  String get cyberWorkspaceGpsServiceDisabledMessage =>
      'Location services are disabled on this device.';

  @override
  String get cyberWorkspaceGpsPermissionDeniedMessage =>
      'Location permission denied.';

  @override
  String get cyberWorkspaceGpsLatitudeLabel => 'Latitude';

  @override
  String get cyberWorkspaceGpsLongitudeLabel => 'Longitude';

  @override
  String get cyberWorkspaceGpsAccuracyLabel => 'Accuracy';

  @override
  String get cyberWorkspaceGpsAltitudeLabel => 'Altitude';

  @override
  String get cyberWorkspaceGpsSpeedLabel => 'Speed';

  @override
  String get cyberWorkspaceNfcTitle => 'NFC / badge reader';

  @override
  String get cyberWorkspaceNfcSubtitle =>
      'Read-only: identifies the UID of a badge or NFC tag, without cloning or bypassing any access control.';

  @override
  String get cyberWorkspaceNfcScanButton => 'Scan a tag';

  @override
  String get cyberWorkspaceNfcStopButton => 'Stop';

  @override
  String get cyberWorkspaceNfcUnavailableMessage =>
      'NFC is unavailable or disabled on this device.';

  @override
  String get cyberWorkspaceNfcNoTagMessage => 'No tag scanned yet.';

  @override
  String cyberWorkspaceNfcUidLabel(String uid) {
    return 'UID: $uid';
  }

  @override
  String cyberWorkspaceNfcTechListLabel(String techs) {
    return 'Technologies: $techs';
  }

  @override
  String get cyberWorkspaceSerialTitle => 'USB serial console';

  @override
  String get cyberWorkspaceSerialSubtitle =>
      'A real serial connection to an Arduino/ESP32 over a USB-OTG cable: send commands or read data from an external sensor.';

  @override
  String get cyberWorkspaceSerialRefreshButton => 'Search for devices';

  @override
  String get cyberWorkspaceSerialNoDevicesMessage =>
      'No USB device found. Plug in a USB-OTG cable.';

  @override
  String get cyberWorkspaceSerialConnectButton => 'Connect';

  @override
  String get cyberWorkspaceSerialConnectFailedMessage =>
      'Failed to connect to the device.';

  @override
  String get cyberWorkspaceSerialConnectedMessage => 'Connected (9600 baud)';

  @override
  String get cyberWorkspaceSerialDisconnectButton => 'Disconnect';

  @override
  String get cyberWorkspaceSerialCommandHint => 'Command to send (e.g. LED_ON)';

  @override
  String get creation2dToolSelect => 'Select';

  @override
  String get creation2dToolBrush => 'Brush';

  @override
  String get creation2dToolEraser => 'Eraser';

  @override
  String get creation2dToolLine => 'Line';

  @override
  String get creation2dToolRectangle => 'Rectangle';

  @override
  String get creation2dToolEllipse => 'Ellipse';

  @override
  String get creation2dToolText => 'Text';

  @override
  String get creation2dUndo => 'Undo';

  @override
  String get creation2dClearLayer => 'Clear layer';

  @override
  String get creation2dExport => 'Export';

  @override
  String creation2dExportedMessage(String fileName) {
    return 'Image exported: $fileName';
  }

  @override
  String get creation2dLayersTitle => 'Layers';

  @override
  String get creation2dAddLayer => 'Add layer';

  @override
  String get creation2dDuplicateLayer => 'Duplicate layer';

  @override
  String get creation2dBlendModeNormal => 'Normal';

  @override
  String get creation2dBlendModeMultiply => 'Multiply';

  @override
  String get creation2dBlendModeScreen => 'Screen';

  @override
  String get creation2dBlendModeOverlay => 'Overlay';

  @override
  String get creation2dBlendModeDarken => 'Darken';

  @override
  String get creation2dBlendModeLighten => 'Lighten';

  @override
  String get creation2dRenameLayerTitle => 'Rename layer';

  @override
  String get creation2dAddTextTitle => 'Add text';

  @override
  String creation2dNewLayerName(int number) {
    return 'Layer $number';
  }

  @override
  String get creation3dTypeCube => 'Cube';

  @override
  String get creation3dTypeSphere => 'Sphere';

  @override
  String get creation3dTypeCylinder => 'Cylinder';

  @override
  String get creation3dTypeCone => 'Cone';

  @override
  String get creation3dTypePlane => 'Plane';

  @override
  String get creation3dTypeLight => 'Light';

  @override
  String get creation3dTypeCamera => 'Camera';

  @override
  String get creation3dMaterialMatte => 'Matte';

  @override
  String get creation3dMaterialMetallic => 'Metallic';

  @override
  String get creation3dMaterialGlass => 'Glass';

  @override
  String get creation3dMaterialEmissive => 'Emissive';

  @override
  String get creation3dAssetsTitle => 'Available objects';

  @override
  String get creation3dDuplicateObject => 'Duplicate';

  @override
  String get creation3dObjectNameLabel => 'Name';

  @override
  String get creation3dPositionLabel => 'Position';

  @override
  String get creation3dRotationLabel => 'Rotation';

  @override
  String get creation3dScaleLabel => 'Scale';

  @override
  String get creation3dMaterialLabel => 'Material';

  @override
  String get creation3dLightIntensityLabel => 'Light intensity';

  @override
  String get creation3dCameraFovLabel => 'Camera field of view';

  @override
  String get creation3dViewportHintLabel =>
      'Drag: orbit • Pinch: zoom • Tap: select';

  @override
  String get creation3dExportScene => 'Export scene';

  @override
  String creation3dSceneExportedMessage(String fileName) {
    return 'Scene exported: $fileName';
  }

  @override
  String get creation3dNoSelectionTitle => 'No object selected';

  @override
  String get creation3dNoSelectionMessage =>
      'Select an object in the scene to edit its properties.';

  @override
  String get userProfileEditTooltip => 'Edit profile';

  @override
  String get userProfileEditTitle => 'Edit profile';

  @override
  String get userProfileAvatarLabel => 'Avatar';

  @override
  String get userProfileAvatarColorLabel => 'Avatar color';

  @override
  String get userProfileFirstNameLabel => 'First name';

  @override
  String get userProfileLastNameLabel => 'Last name';

  @override
  String get userProfileUsernameLabel => 'Username';

  @override
  String get userProfileBioLabel => 'Bio';

  @override
  String get userProfileBioHint => 'Tell us a bit about yourself…';

  @override
  String get userProfileNoBio => 'No bio yet.';

  @override
  String get userProfileNoName => 'User';

  @override
  String get userProfileCountryLabel => 'Country';

  @override
  String get userProfileCountryNone => 'Not set';

  @override
  String get userProfileCountryFrance => 'France';

  @override
  String get userProfileCountryBelgium => 'Belgium';

  @override
  String get userProfileCountrySwitzerland => 'Switzerland';

  @override
  String get userProfileCountryCanada => 'Canada';

  @override
  String get userProfileCountryUnitedStates => 'United States';

  @override
  String get userProfileCountryUnitedKingdom => 'United Kingdom';

  @override
  String get userProfileCountryGermany => 'Germany';

  @override
  String get userProfileCountrySpain => 'Spain';

  @override
  String get userProfileCountryItaly => 'Italy';

  @override
  String get userProfileCountryMorocco => 'Morocco';

  @override
  String get userProfileCountryAlgeria => 'Algeria';

  @override
  String get userProfileCountryTunisia => 'Tunisia';

  @override
  String get userProfileCountrySenegal => 'Senegal';

  @override
  String get userProfileCountryIvoryCoast => 'Ivory Coast';

  @override
  String get userProfileCountryOther => 'Other';

  @override
  String userProfileMemberSinceLabel(String date) {
    return 'Member since $date';
  }

  @override
  String get userProfilePrivacyTitle => 'Privacy';

  @override
  String get userProfileLocalOnlyNote =>
      'This profile is entirely local: no data leaves this device. The architecture is ready to connect to Firebase later without changing this screen.';

  @override
  String get settingsProfileTitle => 'Profile';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsBackupTitle => 'Backups';

  @override
  String get settingsSecurityTitle => 'Security';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsStorageTitle => 'Storage';

  @override
  String get settingsAiTitle => 'AI';

  @override
  String get settingsAppInfoTitle => 'App info';

  @override
  String get settingsDisplayNameLabel => 'Display name';

  @override
  String get settingsDisplayNameHint => 'Your name';

  @override
  String get settingsEditDisplayNameTooltip => 'Edit name';

  @override
  String get settingsNoDisplayName => 'User';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageFrench => 'French';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsTextScaleSmall => 'Small';

  @override
  String get settingsTextScaleMedium => 'Medium';

  @override
  String get settingsTextScaleLarge => 'Large';

  @override
  String get settingsNotificationsEnabledLabel => 'Enable notifications';

  @override
  String get settingsNotificationsSoundLabel => 'Notification sound';

  @override
  String get settingsBackupNeverLabel => 'No backup yet';

  @override
  String settingsBackupLastLabel(String date) {
    return 'Last backup: $date';
  }

  @override
  String get settingsBackupButton => 'Back up now';

  @override
  String get settingsBackupSimulatedMessage =>
      'Simulated backup completed (no real server).';

  @override
  String get settingsBiometricLockLabel => 'Biometric lock';

  @override
  String get settingsBiometricUnavailableMessage =>
      'Not available on this device yet.';

  @override
  String get settingsPinCodeLabel => 'PIN code';

  @override
  String get settingsAnalyticsLabel => 'Share usage data';

  @override
  String get settingsPrivacyNote =>
      'No data leaves this device — there\'s no server or real analytics yet.';

  @override
  String get settingsStorageUsageLabel => 'Simulated usage';

  @override
  String get settingsClearCacheButton => 'Clear cache';

  @override
  String get settingsClearCacheConfirmTitle => 'Clear cache';

  @override
  String get settingsClearCacheConfirmMessage =>
      'This action is simulated — no real data is stored on disk yet.';

  @override
  String get settingsClearCacheDoneMessage => 'Cache cleared (simulated).';

  @override
  String get settingsAiProviderLabel => 'AI provider';

  @override
  String get settingsAiProviderValue => 'Simulated (local)';

  @override
  String get settingsAiApiKeyLabel => 'Personal API key';

  @override
  String get settingsAiApiKeyHint => 'Paste your API key';

  @override
  String get settingsAiApiKeySavedMessage => 'API key saved (in memory only).';

  @override
  String get settingsAiApiKeyNote =>
      'Not securely stored yet — coming with real secure storage.';

  @override
  String get settingsAppVersionLabel => 'Version';

  @override
  String get settingsAppBuildLabel => 'Build';

  @override
  String get settingsAppBuiltWith => 'Built with Flutter';

  @override
  String get settingsCheckForUpdateButton => 'Check for updates';

  @override
  String get settingsUpdateCheckFailedMessage =>
      'Couldn\'t check right now (no published release, or no network).';

  @override
  String get settingsUpToDateMessage => 'The app is up to date.';

  @override
  String settingsUpdateAvailableMessage(String version) {
    return 'New version available: $version';
  }

  @override
  String get settingsOpenReleaseButton => 'View release on GitHub';
}
