import Quickshell
import Quickshell.Networking
import QtQuick
import qs.common
Row {
	id: networkRoot

	anchors.verticalCenter: parent.verticalCenter
	spacing: Theme.spacingBetweenWidgetElements

	property string networkName: "text"

	Text {
		id: networkNameText
		anchors.verticalCenter: parent.verticalCenter

		color: "white"
		font.family: Theme.fontFamily

		visible: false

		text: networkRoot.networkName
	}

	Text {
		id: networkIcon

		color: "white"
		font.family: Theme.fontFamily
		font.pixelSize: Theme.textIconSize

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
