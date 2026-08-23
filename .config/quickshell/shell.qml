import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

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


	RowLayout {
		id: desktopsRoot

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left

		Repeater {
			model: Hyprland.workspaces.values.length

			Text {
				property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
				property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
				
				font.family: root.fontFamily
				font.underline: isActive
				font.bold: isActive

				color: isActive ? "white" : "grey"
				text: index + 1

				// Click to go to workspace
				MouseArea {
					anchors.fill: parent
					onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1}})`)
				}
			}
		}
	}

	Row {
		id: applicationsRoot

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: desktopsRoot.right
		anchors.leftMargin: 15

		Text {
			id: activeWindowNameText

			font.family: root.fontFamily

			color: "white"
			text: Hyprland.focusedWorkspace.id + Hyprland.activeTopLevel?
			text: Hyprland.activeToplevel?.title
			visible: Hyprland.activeToplevel?.workspace.id === Hyprland.focusedWorkspace.id
		}
	}


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

			color: "white"
			font.family: root.fontFamily

			anchors.verticalCenter: parent.verticalCenter

			text: Math.round(batteryRoot.batteryPercentage * 100) + "%"
		}
	}
	Row {
		id: brightnessRoot

		property string brightnessPercentage: "100"

		anchors.right: batteryRoot.left
		anchors.rightMargin: 15
		anchors.verticalCenter: parent.verticalCenter

		spacing: 4

		Text {
			id: brightnessIcon

			color: "white"
			font.family: root.fontFamily
			font.pixelSize: 18

			anchors.verticalCenter: parent.verticalCenter

			text: {
				let brightnessIcons = ["󰃚", "󰃛", "󰃜", "󰃝", "󰃞", "󰃟", "󰃠"];
				let index = Math.max(0, Math.min(6, Math.ceil(brightnessRoot.brightnessPercentage / (100 / 7)) - 1));
				return brightnessIcons[index];
			}
		}

		Process {
			id: getBrightness
			command: ["brightnessctl", "-m"]
			running: true
			stdout: StdioCollector {
				onStreamFinished: {
					let output = this.text.trim();
					if (output) {
						let rawString = output.split(",")[3].replace("%", "");
						brightnessRoot.brightnessPercentage = parseInt(rawString) || 100;
					}
				}
			}
		}
		Process {
			id: brightnessWatcher
			command: ["sh", "-c", "inotifywait -m -e modify /sys/class/backlight/*/brightness"]
			running: true
			stdout: SplitParser {
				onRead: data => {
					getBrightness.running = true;
				}
			}
		}
	}
}
