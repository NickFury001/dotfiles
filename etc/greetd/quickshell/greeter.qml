import Quickshell
import Quickshell.Services.Greetd
import QtQuick
import QtQuick.Controls
import qs.common

FloatingWindow {
	id: greeter

	property string username: ""
	property string password: ""

	fullscreen: true
	Rectangle {
		anchors.fill: parent
		color: "black"
	}
	Column {
		anchors.centerIn: parent
		spacing: 32
		Row {
			Text {
				id: text
				anchors.verticalCenter: parent.verticalCenter
				font.family: Theme.fontFamily
				color: "white"
				text: "username: "
			}

			TextField {
				id: field
				anchors.verticalCenter: parent.verticalCenter
				implicitWidth: 256

				font.family: Theme.fontFamily

				background: Rectangle {
					color: "black"
					border.color: "white"
				}
				color: "white"
				placeholderTextColor: "grey"

				focus: true

				placeholderText: "Username..."

				Keys.onPressed: (event) => {
					if (event.key === Qt.Key_Return) {
						if (text.text.includes("username")) {
							greeter.username = field.text
							text.text = "password: "
							field.placeholderText = "Password..."
							field.clear()
							field.echoMode = TextInput.Password
							field.passwordCharacter = "*"
						} else {
							greeter.password = field.text
							errorText.text = ""
							greeter.attemptLogin(greeter.username, greeter.password)
						}
					}
					if (event.key === Qt.Key_Escape) {
						if (text.text.includes("password")) {
							text.text = "username: "
							field.text = greeter.username
							field.placeholderText = "Username..."
							field.echoMode = TextInput.Normal
							errorText.text = ""
							Greetd.cancelSession()
						}
					}
				}
			}
		}
		Text {
			id: errorText

			anchors.horizontalCenter: parent.horizontalCenter
			
			font.family: Theme.fontFamily
			color: "red"
			
			text: ""
		}
	}

	function attemptLogin(username, password) {
		Greetd.createSession(username)
	}

	Connections {
		target: Greetd

		function onAuthMessage(message, error, responseRequired, echoResponse) {
			if (responseRequired) {
				Greetd.respond(password)
			}
		}

		function onReadyToLaunch() {
			field.clear()
			Greetd.launch(["start-hyprland"])
		}

		function onAuthFailure(message) {
			errorText.text = message
			greeter.password = ""
		}
	}
}
