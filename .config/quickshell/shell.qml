import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
	id: root
	
	// Top bar
	anchors {
		top: true
		left: true
		right: true
	}

	color: "black"

	implicitHeight: 30

	Column {
		id: clockRoot

		property string date: Qt.formatDateTime(new Date(), "MM/dd/yyyy")
		property string time: Qt.formatDateTime(new Date(), "HH:mm:ss")

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right

		Text {
			id: "date"
			anchors.right: parent.right
			text: clockRoot.date
			color: "white"
		}
		Text {
			id: "time"
			anchors.right: parent.right
			text: clockRoot.time
			color: "white"
		}


		Timer {
			interval: 1000
			running: true
			repeat: true
			onTriggered: {
				clockRoot.date = Qt.formatDateTime(new Date(), "MM/dd/yyyy")
				clockRoot.time = Qt.formatDateTime(new Date(), "HH:mm:ss")
			}
		}
	}
}
