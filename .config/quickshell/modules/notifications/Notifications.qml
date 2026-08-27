import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
	id: root

	NotificationServer {
		id: server

		actionsSupported: true
		bodySupported: true
		bodyMarkupSupported: true
		imageSupported: true
		keepOnReload: true          // keep notifications across shell reloads

		onNotification: notif => {
			// Important: mark it tracked so Quickshell doesn’t discard it
			notif.tracked = true
		}
	}

	// Simple popups (one window per screen)
	Variants {
		model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen: modelData

			anchors { top: true; right: true }
			margins { top: 12; right: 12 }

			color: "transparent"
			implicitWidth: 360
			// height grows with the column
			implicitHeight: column.implicitHeight

			// only show when there are tracked notifications
			visible: server.trackedNotifications.values.length > 0

			ColumnLayout {
				id: column
				width: parent.width
				spacing: 8

				Repeater {
					model: server.trackedNotifications

					// Simple card
					Rectangle {
						required property var modelData   // this is a Notification
						Layout.fillWidth: true
						implicitHeight: content.implicitHeight + 24
						radius: 0
						color: "#000000"
						border.color: modelData.urgency === NotificationUrgency.Critical
						? "#f38ba8" : "#45475a"

						ColumnLayout {
							id: content
							anchors {
								fill: parent
								margins: 12
							}
							spacing: 4

							// App name + summary
							Text {
								text: (modelData.appName || "Notification") + "  •  " + modelData.summary
								color: "white"
								font.bold: true
								Layout.fillWidth: true
								elide: Text.ElideRight
							}

							// Body
							Text {
								text: modelData.body
								color: "#cdd6f4"
								wrapMode: Text.Wrap
								Layout.fillWidth: true
								visible: modelData.body.length > 0
							}
						}

						// Click to dismiss
						MouseArea {
							anchors.fill: parent
							onClicked: modelData.dismiss()
						}

						// Auto-expire after 5–8 s (you can improve this later)
						Timer {
							interval: modelData.urgency === NotificationUrgency.Critical ? 0 : 6000
							running: interval > 0
							onTriggered: modelData.expire()
						}
					}
				}
			}
		}
	}
}
