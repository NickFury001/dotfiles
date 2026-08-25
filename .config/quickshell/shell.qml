import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland
import Quickshell.Networking
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Top bar
PanelWindow {
	id: root

	readonly property string fontFamily: "JetBrainsMono Nerd Font"
	readonly property int spacingBetweenWidgets: 15
	readonly property int spacingBetweenWidgetElements: 4
	readonly property int imageIconSize: 20
	readonly property int textIconSize: 18
	readonly property real unfocusedOpacity: 0.50
	
	anchors {
		top: true
		left: true
		right: true
	}

	color: "black"
	implicitHeight: 30


	// === LEFT SIDE ===
	Row {
		anchors.verticalCenter: parent.verticalCenter
		spacing: root.spacingBetweenWidgets

		// Desktop Numbers
		RowLayout {
			id: desktopsRoot

			anchors.verticalCenter: parent.verticalCenter
	
			Repeater {
				model: {
					const highestActiveId = Hyprland.workspaces.values.reduce((max, w) => Math.max(max, w.id), 0);
					const focusedId = Hyprland.focusedWorkspace?.id || 0;
					return Math.max(highestActiveId, focusedId);
				}
	
				Text {
					property var currentWorkspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
					property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

					font.family: root.fontFamily
					font.underline: isActive
					font.bold: isActive
	
					color: "white"
					opacity: isActive ? 1 : root.unfocusedOpacity
					text: index + 1
	
					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1}})`)
					}
				}
			}
		}
		// App Icons
		Row {
			anchors.verticalCenter: parent.verticalCenter
			spacing: root.spacingBetweenWidgetElements
			Repeater {
				model: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.toplevels : []
				delegate: Image {
					width: root.imageIconSize
					height: root.imageIconSize
					smooth: true
					opacity: modelData.activated ? 1.0 : root.unfocusedOpacity
					fillMode: Image.PreserveAspectFit
					source: {
						if (!modelData || !modelData.wayland) return "";
						let appId = modelData.wayland.appId;
						if (!appId) return "";
						let desktopEntry = DesktopEntries.heuristicLookup(appId);
						if (desktopEntry) {
							let iconPath = Quickshell.iconPath(desktopEntry.icon, true);
							return iconPath;
						}
						return Quickshell.iconPath(appId, true);
					}
				}
			}
		}
		// Current Application Title
		Text {
			id: activeWindowNameText

			anchors.verticalCenter: parent.verticalCenter

			font.family: root.fontFamily

			color: "white"
			text: Hyprland.activeToplevel?.title
			visible: Hyprland.activeToplevel?.workspace.id === Hyprland.focusedWorkspace.id
		}
	}

	// === RIGHT SIDE ===
	Row {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		spacing: root.spacingBetweenWidgets

		Row {
			id: networkRoot
			
			anchors.verticalCenter: parent.verticalCenter
			spacing: root.spacingBetweenWidgetElements

			property string networkName: "text"

			Text {
				id: networkNameText

				color: "white"
				font.family: root.fontFamily
				font.pixelSize: root.textIconSize

				visible: false

				text: networkRoot.networkName
			}

			Text {
				id: networkIcon

				color: "white"
				font.family: root.fontFamily
				font.pixelSize: root.textIconSize

				text: {
					// Hardware block means something is wrong
					if (!Networking.wifiHardwareEnabled) {
						networkNameText.text = ""
						return "HW Blocked Conn"
					}
					// Quickshell.Networking requires NetworkManager
					if (Networking.backend !== NetworkBackendType.NetworkManager) {
						networkNameText.text = ""
						return "MISSING: NM"
					}
					// Needs to be able to check connectivity
					if (!Networking.canCheckConnectivity || !Networking.connectivityCheckEnabled) {
						networkNameText.text = ""
						return "ENABLE: CHKS"
					}
					// Wifi turned off by Software (rfkill block)
					if (!Networking.wifiEnabled) {
						networkNameText.text = "Disconnected"
						return "󰤮"
					}
					let device = null
					for (let i = 0; i < Networking.devices.values.length; i++) {
						const d = Networking.devices.values[i]
						if (d.connected) {
							device = d
							break
						}
					}
					if (!device) {
						networkNameText.text = "Disconnected"
						return "󰤮"
					}
					if (device.type === DeviceType.Wired) {
						networkNameText.text = device.name || "Ethernet"
						return ""
					}
					if (device.type === DeviceType.Wifi) {
						let network = null
						for (let i = 0; i < device.networks.values.length; i++) {
							const n = device.networks.values[i]
							if (n.connected) {
								network = n
								break
							}
						}
						if (network) {
							networkNameText.text = network.name || "Wi-Fi"
							let strengthIcons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
							let index = Math.max(0, Math.min(4, Math.ceil(network.signalStrength / (1 / 5)) - 1))
							return strengthIcons[index]
						}
					}
				}

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.RightButton | Qt.LeftButton

					onClicked: (mouse) => {
						console.log(mouse.button)
						// Right Click ==> Show/Hide Network name
						if (mouse.button == Qt.RightButton) {
							networkNameText.visible = !networkNameText.visible
						}
					}
				}
			}
		}

		Row {
			id: brightnessRoot
	
			property string brightnessPercentage: "100"
	
			anchors.verticalCenter: parent.verticalCenter
			spacing: root.spacingBetweenWidgetElements
	
			Text {
				id: brightnessIcon
	
				color: "white"
				font.family: root.fontFamily
				font.pixelSize: root.textIconSize
	
				anchors.verticalCenter: parent.verticalCenter
	
				text: {
					let brightnessIcons = ["󰃚", "󰃛", "󰃜", "󰃝", "󰃞", "󰃟", "󰃠"];
					let index = Math.max(0, Math.min(6, Math.ceil(brightnessRoot.brightnessPercentage / (100 / 7)) - 1))
					return brightnessIcons[index]
				}
				
				MouseArea {
					anchors.fill: parent
	
					onWheel: (wheel) => {
						if (wheel.angleDelta.y > 0) {
							Quickshell.execDetached(["brightnessctl", "set", "+1%"])
						} else {
							Quickshell.execDetached(["brightnessctl", "set", "1%-"])
						}
					}
				}
			}
	
			Process {
				id: getBrightness
				command: ["brightnessctl", "-m"]
				running: true
				stdout: StdioCollector {
					onStreamFinished: {
						let output = this.text.trim()
						if (output) {
							let rawString = output.split(",")[3].replace("%", "")
							brightnessRoot.brightnessPercentage = parseInt(rawString) || 100
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
						getBrightness.running = true
					}
				}
			}
		}

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
				text: "Hello, World!"
				delay: 400
				timeout: 4000
				popupType: Popup.Native
			}
	
	
			Row {
				anchors.right: parent.right
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
		}

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
	}
}
