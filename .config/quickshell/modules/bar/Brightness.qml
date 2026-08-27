import Quickshell
import Quickshell.Io
import QtQuick
import qs.common

Row {
	id: brightnessRoot

	property string brightnessPercentage: "100"

	anchors.verticalCenter: parent.verticalCenter
	spacing: Theme.spacingBetweenWidgetElements

	Text {
		id: brightnessIcon

		color: "white"
		font.family: Theme.fontFamily
		font.pixelSize: Theme.textIconSize

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
