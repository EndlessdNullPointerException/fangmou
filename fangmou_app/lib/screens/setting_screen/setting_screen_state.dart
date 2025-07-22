class SettingScreenState {
  final bool enableExplorerContextMenuIntegration;
  final bool enableAdminPermission;

  SettingScreenState({required this.enableExplorerContextMenuIntegration, required this.enableAdminPermission});

  SettingScreenState copyWith({bool? enableExplorerContextMenuIntegration, bool? enableAdminPermission}) {
    return SettingScreenState(
      enableExplorerContextMenuIntegration:
          enableExplorerContextMenuIntegration ?? this.enableExplorerContextMenuIntegration,
      enableAdminPermission: enableAdminPermission ?? this.enableAdminPermission,
    );
  }
}
