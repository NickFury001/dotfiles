import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common

RowLayout {
	id: desktopsRoot
	anchors.verticalCenter: parent.verticalCenter

	Repeater {
		model: {
			const highestActiveId = Hyprland.workspaces.values.reduce((max, w) => Math.max(max, w.id), 0);
			const focusedId = Hyprland.focusedWorkspace?.id || 0;
			return Math.max(highestActiveId, focusedId);
		}

		Text {
			property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
			property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

			font.family: Theme.fontFamily
			font.underline: isActive
			font.bold: isActive

			color: "white"
			opacity: isActive ? 1 : Theme.unfocusedOpacity
			text: index + 1

			MouseArea {
				anchors.fill: parent
				onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1}})`)
			}
		}
	}
}
