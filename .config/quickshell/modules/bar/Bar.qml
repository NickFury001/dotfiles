import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common

PanelWindow {
	id: root

	anchors {
		top: true
		left: true
		right: true
	}

	color: "black"
	implicitHeight: 30

	// === LEFT SIDE ===
	Row {
		anchors.verticalCenter: parent.verticalCenter
		spacing: Theme.spacingBetweenWidgets

		Workspaces {}
		AppIcons {}
		ActiveTitle {}
	}

	// === RIGHT SIDE ===
	Row {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		spacing: Theme.spacingBetweenWidgets

		Bluetooth {}
		Network {}
		Brightness {}
		Battery {}
		Clock {}
	}
}
