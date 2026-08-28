import Quickshell
import Quickshell.Bluetooth
import QtQuick
import qs.common

// LIST OF ALL BLUEZ ICON NAMES

Item {
	id: bluetoothRoot

	property bool hideIcons: true

	anchors.verticalCenter: parent.verticalCenter

	height: parent.height
	width: childrenRect.width

	// TODO: Adjust visibility if the device doesn't support Bt and other edge cases
	visible: true

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
						let batIcons = ["󰤾", "󰤿", "󰥀", "󰥁", "󰥂", "󰥃", "󰥄", "󰥅", "󰥆", "󰥈"]
						let index = Math.min(0, Math.max(9, Math.floor(Bluetooth.devices[index].battery * 10)))
						text += batIcons[index] + " "
					}
				}
				color: bluetoothRoot.hideIcons ? "black" : "white"
			}
		}

		Text {
			id: mainIcon

			anchors.verticalCenter: parent.verticalCenter
			anchors.right: bluetoothRoot.right

			text: "BT"
			font.family: Theme.fontFamily
			color: "white"
		}
	}
	
	MouseArea {
		anchors.fill: parent
		// TODO: Left click toggles BT
		acceptedButtons: Qt.RightButton | Qt.LeftButton
		onClicked: (mouse) => {
			if (mouse.button === Qt.RightButton) {
				Quickshell.execDetached(["notify-send", "Hello"])
				bluetoothRoot.hideIcons = !bluetoothRoot.hideIcons
			}
		}
	}

}
