import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.common

PanelWindow {
	id: launcherRoot
	
	visible: false

	implicitWidth: Hyprland.focusedMonitor.width / 4
	implicitHeight: 60+60*3

	Rectangle {
		anchors.fill: parent

		border.color: "white"
		color: "black"
	}

	Column {

		anchors.fill: parent

		TextField {
			id: inputRoot

			anchors.left: parent.left
			anchors.right: parent.right

			height: 60

			color: "white"
			background: Rectangle {
				anchors.fill: parent
				border.color: "white"
				color: "black"
			}

			placeholderText: "Search..."
			placeholderTextColor: "grey"
			font.family: Theme.fontFamily
			font.pixelSize: 30
			Keys.onPressed: (event) => {
				if (event.key === Qt.Key_Escape) {
					launcherRoot.visible = false
				} else if (event.key === Qt.Key_Down) {
					resultsColumn.selectedItemIndex += 1
				} else if (event.key === Qt.Key_Up) {
					resultsColumn.selectedItemIndex -= 1
				} else if (event.key === Qt.Key_Return) {
					const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
					let idx = (resultsColumn.selectedItemIndex === -1) ? 0 : resultsColumn.selectedItemIndex
					DesktopEntries.applications.values.filter(item => regex.test(item.name))[idx].execute()
					launcherRoot.visible = false
				}
				resultsColumn.selectedItemIndex = Math.max(-1, Math.min(resultsColumn.selectedItemIndex, 2))
			}
		}

		Column {
			id: resultsColumn

			property int selectedItemIndex: -1 // -1 means nothing selected

			width: parent.width
			height: Math.min(childrenRect.height, Hyprland.focusedMonitor.height * 0.7)
			Repeater {
				model: 3
				Item {

					visible: {
						const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
						const apps = DesktopEntries.applications.values.filter(item => regex.test(item.name)).filter(function(item, pos, self) {
							return self.indexOf(item) == pos;
						})
						return apps.length >= index+1
					}

					width: resultsColumn.width
					height: 60
					Rectangle {
						id: hoverBg
						anchors.fill: parent
						color: resultsColumn.selectedItemIndex == index ? "#333333" : "transparent"

						states: [
							State {
								name: "hovered"
								when: mouseArea.containsMouse
								PropertyChanges {
									target: hoverBg
									color: "#333333"
								}
							}
						]
					}
					Row {
						anchors.fill: parent
						padding: 10
						spacing: 20
						Image {
							width: 48
							height: 48
							smooth: true
							fillMode: Image.PreserveAspectFit
							source: {
								const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
								const app = DesktopEntries.applications.values.filter(item => regex.test(item.name))[index];
								return Quickshell.iconPath(app.icon)
								// Inside your Quickshell code
								function fuzzyFilter(query, listModel) {
									const regex = new RegExp(query.split('').join('.*'), 'i');
									return listModel.filter(item => regex.test(item.name));
								}
							}
						}
						Text {
							anchors.verticalCenter: parent.verticalCenter
							color: "white"
							font.family: Theme.fontFamily
							font.pixelSize: 20
							text: {
								const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
								const app = DesktopEntries.applications.values.filter(item => regex.test(item.name))[index];
								return app.name
							}
						}
					}
					MouseArea {
						id: mouseArea
						anchors.fill: parent
						hoverEnabled: true

						onDoubleClicked: {
							const regex = new RegExp(inputRoot.text.split('').join('.*'), 'i');
							DesktopEntries.applications.values.filter(item => regex.test(item.name))[index].execute()
							launcherRoot.visible = false
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
