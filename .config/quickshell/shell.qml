import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick

// Top bar
PanelWindow {
	id: root

	readonly property string fontFamily: "JetBrainsMono Nerd Font"
	
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
			font.family: root.fontFamily
		}

		Text {
			id: time
			anchors.right: parent.right
			text: clockRoot.time
			color: "white"
			font.family: root.fontFamily
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
	Row {
		id: batteryRoot

		readonly property UPowerDevice batteryDevice: UPower.displayDevice
		property int batteryState: batteryDevice ? batteryDevice.state : 0
		property real batteryPercentage: batteryDevice ? batteryDevice.percentage : 0

		visible: batteryDevice && batteryDevice.isPresent && batteryDevice.isLaptopBattery
		anchors.right: clockRoot.left
		anchors.rightMargin: 15
		anchors.verticalCenter: parent.verticalCenter
		spacing: 4
		
		Text {
			id: profileIcon

			color: "white"
			font.family: root.fontFamily
			font.pixelSize: 18

			anchors.verticalCenter: parent.verticalCenter

			text: {
				return ["󰾆", "󰾅", "󰓅"][PowerProfiles.profile]
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					let current = PowerProfiles.profile

					if (current === PowerProfile.PowerSaver) {
						PowerProfiles.profile = PowerProfile.Balanced
					} else if (current === PowerProfile.Balanced) {
						if (PowerProfiles.hasPerformanceProfile) {
							PowerProfiles.profile = PowerProfile.Performance
						} else {
							PowerProfiles.profile = PowerProfile.PowerSaver
						}
					} else {
						PowerProfiles.profile = PowerProfile.PowerSaver
					}
				}
			}
		}

		Text {
			id: batteryIcon

			color: "white"
			font.family: root.fontFamily
			font.pixelSize: 18

			anchors.verticalCenter: parent.verticalCenter

			text: {
				let percentage = Math.round(batteryRoot.batteryPercentage * 100)
				let isCharging = batteryRoot.batteryState === UPowerDeviceState.Charging
				const dischargeIcons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
				const chargeIcons = ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂄"]
				let index = Math.max(0, Math.min(10, Math.floor(percentage / 10)))
				return isCharging ? chargeIcons[index] : dischargeIcons[index]
			}
		}

		Text {
			id: batteryPercentageText
			text: Math.round(batteryRoot.batteryPercentage * 100) + "%"
			color: "white"
			font.family: root.fontFamily
			anchors.verticalCenter: parent.verticalCenter
		}
	}
}
