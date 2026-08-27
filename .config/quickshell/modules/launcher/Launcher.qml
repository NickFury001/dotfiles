import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.common

PanelWindow {
	id: launcherRoot
	
	visible: true

	Rectangle {
		id: background

		anchors.fill: parent

		border.color: "white"
		color: "black"
	}

	TextArea {
		id: inputRoot

		anchors.left: parent.left
		anchors.right: parent.right

		color: "white"
		background: Rectangle {
			anchors.fill: parent
			border.color: "white"
			color: "black"
		}
	
		placeholderText: "Search..."
		font.family: Theme.fontFamily
	}

	onVisibleChanged: {
		if (launcherRoot.visible) {
			inputRoot.forceActiveFocus()
			inputRoot.clear()
		}
	}

	IpcHandler {
		target: "launcherRoot"
		
		function toggleVisibility(): void {
			launcherRoot.visible = !launcherRoot.visible
			grab.active = !grab.active
		}
	}

	HyprlandFocusGrab {
		id: focusGrabber

		active: launcherRoot.visible
		windows: [ launcherRoot, inputRoot ]
	}
}
