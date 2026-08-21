import Quickshell
import QtQuick

PanelWindow {
	aboveWindows: true
	focusable: true
	implicitWidth: Math.round(screen.width / 2)
	TextInput {
		anchors.centerIn: parent
		text: "Hello, World!"
		font.family: "monospace"
		font.pointSize: 24
	}
}
