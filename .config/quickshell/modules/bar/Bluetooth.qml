import Quickshell
import Quickshell.Bluetooth
import QtQuick
import qs.common

// LIST OF ALL BLUEZ ICON NAMES

Item {
	id: bluetoothRoot

	property bool hideIcons: false

	anchors.verticalCenter: parent.verticalCenter

	height: parent.height
	width: childrenRect.width

	visible: Bluetooth.adapters.values.length > 0

	Row {
		anchors.verticalCenter: parent.verticalCenter
		spacing: Theme.spacingBetweenWidgetElements

		Repeater {
			id: deviceIcons

			model: Bluetooth.devices.values.length

			Text {
				font.family: Theme.fontFamily
				font.pixelSize: Theme.textIconSize

				text: {
					let out = ""
					switch (Bluetooth.devices.values[index].icon) {
						case "computer":
						text += "󰟀"
						break
						case "phone":
						text += "󰏳"
						break
						case "modem":
						text += "󰑩"
						break
						case "network-wireless":
						text += "?"
						break
						case "audio-headset":
						text += "󰋎"
						break
						case "audio-headphones":
						text += "󰋋"
						break
						case "camera-video":
						text += ""
						break
						case "audio-card":
						text += "󰂰"
						break
						case "input-gaming":
						text += "󰖺"
						break
						case "input-keyboard":
						text += "󰌌"
						break
						case "input-tablet":
						text += "󰓶"
						break
						case "input-mouse":
						text += "󰦋"
						break
						case "printer":
						text += "󰦋"
						break
						case "camera-photo":
						text += "󰄀"
						break
					}
					if (Bluetooth.devices.values[index].batteryAvailable) {
						text += " "
						let batIcons = ["󰤾", "󰤿", "󰥀", "󰥁", "󰥂", "󰥃", "󰥄", "󰥅", "󰥆", "󰥈"]
						let idx = Math.max(0, Math.min(9, Math.floor(Bluetooth.devices.values[index].battery * 10)))
						text += batIcons[idx] + " "
					}
				}
				color: (!Bluetooth.devices.values[index].connected || bluetoothRoot.hideIcons) ? "black" : "white"
			}
		}

		Text {
			id: mainIcon

			anchors.verticalCenter: parent.verticalCenter
			anchors.right: bluetoothRoot.right

			text: Bluetooth.devices.values.filter((e)=>{return e.connected}).length > 0 ? "󰂱" : "󰂯"
			font.family: Theme.fontFamily
			font.pixelSize: Theme.textIconSize
			color: "white"
		}
	}
	
	MouseArea {
		anchors.fill: parent
		// TODO: Left click toggles BT
		acceptedButtons: Qt.RightButton | Qt.LeftButton
		onClicked: (mouse) => {
			if (mouse.button === Qt.RightButton) {
				bluetoothRoot.hideIcons = !bluetoothRoot.hideIcons
			}
		}
	}

}
