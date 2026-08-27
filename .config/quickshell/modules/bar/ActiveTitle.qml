import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.common

Text {
	id: activeWindowNameText

	anchors.verticalCenter: parent.verticalCenter

	font.family: Theme.fontFamily

	color: "white"
	text: Hyprland.activeToplevel?.title
	visible: Hyprland.activeToplevel?.workspace.id === Hyprland.focusedWorkspace.id
}
