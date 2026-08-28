import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.common

PanelWindow {
	id: launcherRoot
	
	visible: true

	implicitWidth: Hyprland.focusedMonitor.width / 4
	implicitHeight: childrenRect.height

	Rectangle {
		id: background

		anchors.fill: parent

		border.color: "white"
		color: "black"
	}

	Column {

		anchors.fill: parent

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
			font.pixelSize: 20
		}

		Column {
			Repeater {
				model: 3
				Row {
					padding: 10
					Image {
						width: 48
						height: 48
						smooth: true
						fillMode: Image.PreserveAspectFit
						source: {
							const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
							const app = DesktopEntries.applications.values.filter(item => regex.test(item.name))[index];
							return Quickshell.iconPath(app.icon)
						}
					}
					Text {
						color: "white"
						text: {
							const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
							const app = DesktopEntries.applications.values.filter(item => regex.test(item.name))[index];
							return app.name
						}
					}
				}
			}
		}
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
