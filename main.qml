import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3





Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Fault Detector")
    color: "#0f1f2f"


    property string filename
    property int name: 0




    Text{
        text: "POWERED BY A.ELAHI M.ASLANI"
        font.pixelSize: 8
        color: "white"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
    }



    FileDialog {
        id: fileDialog
        title: "Please choose an CSV file"
        nameFilters: ["CSV files (*.csv)"]

        onAccepted: {
            filename = fileDialog.fileUrl
            fileNameTitle.text = filename.toUpperCase()

        }
        onRejected: {
            fileNameTitle.text = "loading file Rejected..."

        }
        Component.onCompleted: visible = false
    }



    SplitView{
        //        color: "#0f1f2f"
        anchors.fill: parent
        orientation: Qt.Horizontal
        Rectangle{
            SplitView.minimumWidth: parent.width/4
            SplitView.preferredWidth: parent.width *0.75
            border.width: 2
            border.color: "gray"
            width: parent.width
            //            height: parent.height * 0.75
            height: parent.height
            anchors.top: parent.top
            color: "transparent"

            Image{
                id:logo
                source: "./logo.png"
                width: parent.width/12
                height: parent.width/12
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: parent.width/35

            }


            Text {
                id: title
                text: qsTr("Insert your signal ")
                color: "white"
                font.pixelSize: parent.width / 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.margins: parent.width /40
            }

            Rectangle{
                id: browser
                width: parent.width /1.5
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.width/23
                color: "#bfbfbf"
                anchors.top: title.bottom
                radius: height/4
                anchors.margins: parent.width /40
                Rectangle{
                    width: parent.width - parent.height*2.1
                    height: parent.height/1.5
                    color: "white"
                    radius: height/4
                    anchors.centerIn: parent

                    Text {
                        id: fileNameTitle
                        text: "Click left button to browse file then right button to load signal"
                        font.pixelSize: parent.height/2
                        anchors.centerIn: parent
                    }
                }

                Rectangle{
                    width: parent.height/1.5
                    height: parent.height/1.5
                    radius: width/4
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.margins: parent.height - 1.2*height
                    Image {
                        source: "./upload.png"
                        anchors.fill: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if(filename){
                                backend.fileToBackend(filename)
                                loadSignal.visible=true
                                loadSignal.reload()
                            }else{
                                fileNameTitle.text = "ERROR : please insert a valid file..."
                            }
                        }
                    }


                }
                Rectangle{
                    width: parent.height/1.5
                    height: parent.height/1.5
                    radius: width/4
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: parent.height - 1.2*height
                    Image {
                        source: "./file.jpg"
                        anchors.fill: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: fileDialog.open()
                    }
                }
            }
            Rectangle{
                id: bottomSwitch
                width: parent.width / 1.05
                //                height: parent.height/1.4
                anchors.top: browser.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                radius: width/25
                anchors.margins: parent.width /40
                clip: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: bottomSwitch.width
                        height: bottomSwitch.height
                        Rectangle {
                            anchors.centerIn: parent
                            width:  bottomSwitch.width
                            height:  bottomSwitch.height
                            radius: bottomSwitch.width/25
                        }
                    }
                }

                WebView {
                    id: loadSignal
                    visible: false
                    url: "./file.html"
                    anchors.fill: parent
                }
            }
        }
        Rectangle{

            SplitView.minimumWidth: parent.width/4
            border.width: 2
            border.color: "gray"
            width: parent.width
            //            height: parent.height *0.25
            height: parent.height
            anchors.bottom:  parent.bottom
            color: "transparent"

            Text {
                id: rightTitle
                text: qsTr("Choose Model")
                color: "white"
                font.pixelSize: parent.height / 30
                anchors.margins: parent.height / 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
            }

            ComboBox{
                id: combo
                model: [
                    "MASS UNBALANCE",
                    "ECCENTRIC ROTOR",
                    "BENT SHAFT",
                    "MISALIGNEMENT",
                    "MECHANICAL LOOSENESS",
                    "ROTOR RUB",
                    "JOURNAL BEARINGS",
                    "ROLLEING ELEMENT BEARING",
                    "HYDRAULIC AND AERODYNAMIC FORCES",
                    "GEAR (A)",
                    "GEAR (B)",
                    "AC INDUCTION MOTORS",
                    "DC MOTORS AND CONTROLS",
                    "BELT DRIVE PROBLEMS",
                    "FOOT RELATED RESONANC"
                ]
                y: parent.height / 8
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                currentIndex: 0
                onCurrentIndexChanged: {
                    name = currentIndex
                }

            }


            Rectangle{
                id: imgHolder
                width: parent.width * 0.8
//                height: parent.height - 2*combo.y
                height: img.height
                anchors.horizontalCenter: parent.horizontalCenter
                y: combo.y + parent.height / 12
                radius: width/30
                border.width: 1
                border.color: "#bfbfbf"
                color: "transparent"
                Image {
                    id: img
                    source: "./"+name+".jpg"
                    width: parent.width

                }
            }
        }
    }

    Connections{
        target: backend
    }
}
