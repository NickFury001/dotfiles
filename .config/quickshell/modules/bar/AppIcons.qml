import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.common


Row {
	anchors.verticalCenter: parent.verticalCenter
	spacing: Theme.spacingBetweenWidgetElements
	Repeater {
		model: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.toplevels : []
		delegate: Image {
			width: Theme.imageIconSize
			height: Theme.imageIconSize
			smooth: true
			opacity: modelData.activated ? 1.0 : Theme.unfocusedOpacity
			fillMode: Image.PreserveAspectFit
			source: {
				if (!modelData || !modelData.wayland) return "";
				let appId = modelData.wayland.appId;
				if (!appId) return "";
				let desktopEntry = DesktopEntries.heuristicLookup(appId);
				if (desktopEntry) {
					let iconPath = Quickshell.iconPath(desktopEntry.icon, true);
					return iconPath;
				}
				return Quickshell.iconPath(appId, true);
			}
		}
	}
}
