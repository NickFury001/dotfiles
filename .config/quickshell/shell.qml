import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick

// Top bar
PanelWindow {
	id: root
	
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
		property string time: Qt.formatDateTime(new Date(), "h:mm:ss AP")

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right

		Text {
			id: date
			anchors.right: parent.right
			text: clockRoot.date
			color: "white"
		}

		Text {
			id: time
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
				clockRoot.time = Qt.formatDateTime(new Date(), "h:mm:ss AP")
			}
		}
	}
	Text {
		id: battery
		readonly property var batteryDevice: UPower.devices.values[0]
		visible: batteryDevice.isPresent
		anchors.right: clockRoot.left
		anchors.verticalCenter: parent.verticalCenter
		property string batPer: batteryDevice.percentage*100 + "%"
		text: batPer
		color: "white"

		Timer {
			interval: 5000
			running: true
			onTriggered: battery.batPer = battery.batteryDevice.percentage*100 + "%"
		}
	}
}
