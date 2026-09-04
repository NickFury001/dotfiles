import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import qs.common

PanelWindow {
	id: clipboardRoot
	visible: false

	property ListModel clipboard: ListModel {}

	implicitWidth: Hyprland.focusedMonitor.width / 2

	Rectangle {
		anchors.fill: parent
		color: "black"
		border.color: "white"
	}

	ScrollView {
		anchors.fill: parent
		background: Rectangle {
			anchors.fill: parent
			color: "black"
			border.color: "white"
		}

		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
		ScrollBar.vertical.policy: ScrollBar.AlwaysOn

		ListView {
			anchors.margins: 10
			model: clipboardRoot.clipboard.count
			delegate: ItemDelegate {
				id: clipboardItem
				background: Rectangle {
					anchors.fill: parent
					color: "black"
				}
				Text {
					visible: false
					color: "white"
					text: {
						clipboardItem.loadData()
						return "beep"
					}
				}
				function loadData(): void {
					Quickshell.execDetached(["notify-send", "beep"])
					let data = clipboardRoot.clipboard.get(index)
					let textIndex = data.split("\t")[0]
					let rawData = text.split("\t").filter((a, i)=>{return i != 0}).join("\t")
					let pngRegex = /\[\[ binary data \d\d (?:KiB|MiB|GiB) png \d*x\d* \]\]/
					if (pngRegex.test(rawData)) {
						Quickshell.execDetached(["notify-send", "PNG Image"])
					}
				}
			}
		}
	}

	IpcHandler {
		target: "clipboardRoot"

		function toggleVisibility(): void {
			clipboardRoot.visible = !clipboardRoot.visible
		}
	}
}
