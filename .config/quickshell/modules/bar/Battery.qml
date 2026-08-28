import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls
import qs.common

Item {
	id: batteryRoot

	readonly property UPowerDevice batteryDevice: UPower.displayDevice
	property int batteryState: batteryDevice ? batteryDevice.state : 0
	property real batteryPercentage: batteryDevice ? batteryDevice.percentage : 0

	anchors.verticalCenter: parent.verticalCenter

	height: parent.height
	width: childrenRect.width

	visible: batteryDevice && batteryDevice.isPresent && batteryDevice.isLaptopBattery


	HoverHandler {
		id: batteryHover
	}

	ToolTip {
		visible: batteryHover.hovered

		contentItem: Text {
			font.family: Theme.fontFamily
			text: {
				let text = ""
				text += Math.round(UPower.displayDevice.changeRate*100)/100
				text += "W, "
				text += Math.round(UPower.displayDevice.energy*100)/100
				text += "Wh"
				text += (UPower.displayDevice.timeToFull !== 0) ? 
				", " + Math.round(UPower.displayDevice.timeToFull/60) + "mins" :
				""
				return text
			}
			color: "white"
		}

		background: Rectangle {
			border.color: "white"
			color: "black"
		}

		delay: 400
		timeout: 4000
		popupType: Popup.Native
	}


	Row {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		spacing: 4

		Text {
			id: batteryIcon

			color: "white"
			font.family: Theme.fontFamily
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

			color: "white"
			font.family: Theme.fontFamily

			anchors.verticalCenter: parent.verticalCenter

			text: Math.round(batteryRoot.batteryPercentage * 100) + "%"
		}

		Text {
			id: profileIcon

			color: "white"
			font.family: Theme.fontFamily
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
						Quickshell.execDetached(["fish", "-c", "setpower normal"])
					} else if (current === PowerProfile.Balanced) {
						if (PowerProfiles.hasPerformanceProfile) {
							PowerProfiles.profile = PowerProfile.Performance
							Quickshell.execDetached(["fish", "-c", "setpower perf"])
						} else {
							PowerProfiles.profile = PowerProfile.PowerSaver
							Quickshell.execDetached(["fish", "-c", "setpower saver"]);
						}
					} else {
						PowerProfiles.profile = PowerProfile.PowerSaver
					}
				}
			}
		}
	}
}
