import Quickshell
import QtQuick
import qs.common

Column {
	id: clockRoot

	property string date: Qt.formatDateTime(new Date(), "MM/dd/yyyy")
	property string time: Qt.formatDateTime(new Date(), "h:mm:ss AP")

	anchors.verticalCenter: parent.verticalCenter

	Text {
		id: date
		anchors.right: parent.right
		text: clockRoot.date
		color: "white"
		font.family: Theme.fontFamily
	}

	Text {
		id: time
		anchors.right: parent.right
		text: clockRoot.time
		color: "white"
		font.family: Theme.fontFamily
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
