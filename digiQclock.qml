/****************************************************************************
**
** Code based on: http://code.google.com/p/nokia-screensaver/source/browse/branches/minimal/qtscreensaver/qml/qtscreensaver/main.qml?r=28
** License: Apache License 2.0: http://www.apache.org/licenses/LICENSE-2.0
** Modified by me for use on Haiku: hey68you@gmail.com (January 2013).
**
****************************************************************************/

import QtQuick 2.5
import QtQuick.Window
// import QtQuick.Controls 2.15
import QtQuick.Controls.Basic


Window {

    id: topWin

    // width: 600
    // height: 480
    visible: true
    title: qsTr("DigiQClock")
    ////////////////////////////////////////////////
    // Edit settings
    //  1. Colors
    //  2. Show Seconds
    //  3. 12 or 24 hours
    ////////////////////////////////////////////////
    property bool   showSeconds: true //false
    property bool	twelveHours: true
    property int    hoursOffset: 0
    // property string foregroundTextColor: "#373634" //"#80C1FF" //"#00FF00"
    // property string gradientStartColor:  "#99B0A0" //"#424242"
    // property string gradientEndColor:    "#737F78" //"black"


    // property string foregroundTextColor: "#FA0901"
    // property string gradientStartColor:  "#211E27"
    // property string gradientEndColor:    "#211E27"

    //282828
    //property string foregroundTextColor: "#83FD82"
    property string foregroundTextColor: "#33B0F5"
    property string gradientStartColor:  "#242424"
    property string gradientEndColor:    "#242424"
    ////////////////////////////////////////////////
    ////////////////////////////////////////////////


    ////////////////////////////////////////////////
    // I don't think you should need to change
    //  these values...
    ////////////////////////////////////////////////
    property int    winWidth:  (showSeconds) ? 500 : 180
    property int    winHeight: (showSeconds) ? 130 : 75

    property int    upperMargin: 0
    property real   sideMargin:  10

    property real   fontProportion: (showSeconds) ? 0.27 : 0.40

    property string dateString: ""
    property bool   toggleSeparator: true
    property bool   blinkColon: false
    property bool   showBorder: false
    property string separtorString: ":"
    property variant timeStrElements: []
    property variant locale: Qt.locale()
    ////////////////////////////////////////////////

    width:   winWidth
    height:  winHeight

    // flags: Qt.FramelessWindowHint | Qt.Window

    Component.onCompleted: {
        // console.log('Qt.platform.os', Qt.platform.os);
        const firstArgs = Qt.application.arguments;
        const args = firstArgs.slice(1);
        args.forEach((arg, index) => {

            if (arg === '-h' || arg === '--help') {
                console.log('\n\The following CLI parameters may be passed when running from the command line:\n
--fg           ===> font color: friendly color names or hex string with # notation e.g. \'#73D292\' or \'green\' - qoutes are required when using hex
--bg-start     ===> background start gradient color (same format as --fg parameter)
--bg-end       ===> background end gradient color (if you don\'t want gradient make sure to pass same value that you passed for --bg-start)
--offset-hours ===> e.g. for different time-zones (use minus sign or just plain number for forward e.g. \'--offset-hours -3\' or \'--offset-hours 5\')
--win-title    ===> use quotes for titles with spaces e.g. --win-title \'Los Angeles\')
--font         ===> name of font .otf /.ttf file (must be in same folder as the executable)
--no-italics   ===> only need to add this flag (default is using italic font)
--24hrs        ===> only need to add this flag (default is 12hr AM/PM implied )
--hide-secs    ===> don\'t show seconds
--frameless    ===> borderless window
--hide-dimmer  ===> don\'t display the \'ghost\' background 00:00:00 LED effect (good if you\'re not usin monospaced fonts)
--blink-colon  ===> blinking colon seperator
--show-border  ===> show a 1pt border of same color as foreground color

Here\'s a full example:\n
> ./DigiQClock --fg \'#000000\' --bg-start lightblue --bg-end lightblue --offset-hours -3 --win-title \'Los Angeles\' --no-italics --24hrs
\n\n');
            Qt.quit();
            return;
            }
            if (arg === '--fg') {
                console.log('\nset font color to:', args[index+1]);
                foregroundTextColor = args[index+1];
            }

            if (arg === '--bg-start') {
                console.log('\nset bg start color to:', args[index+1]);
                gradientStartColor = args[index+1];
            }

            if (arg === '--bg-end') {
                console.log('\nset bg end color to:', args[index+1]);
                gradientEndColor = args[index+1];
            }

            if (arg === '--offset-hours') {
                console.log('\nset hours offset:', args[index+1]);
                hoursOffset = Number(args[index+1]);
            }

            if (arg === '--win-title') {
                console.log('\nset widow title to:', args[index+1]);
                topWin.title = args[index+1];
            }

            if (arg === '--font') {
                console.log('\nset font to:', args[index+1]);
                fixedFont.source = args[index+1];
            }

            if (arg === '--no-italics') {
                console.log('\nset no italics:');
                timeText.font.italic = false;
                timeTextBackground.font.italic = false;

            }

            if (arg === '--24hrs') {
                console.log('\nset 24 hour time');
                twelveHours = false;
            }

            if (arg === '--hide-secs') {
                console.log('\nset hide seconds');
                showSeconds = false;
            }

            if (arg === '--hide-dimmer') {
                console.log('\nset hide dimmer');
                timeTextBackground.opacity = 0;
                timeTextBackground.text = "";
            }

            if (arg === '--frameless') {
                console.log('\nset frameless');
                // topWin.flags = Qt.FramelessWindowHint | Qt.Window
                topWin.flags = /*Qt.WindowStaysOnTopHint |*/ Qt.FramelessWindowHint
            }

            if (arg === '--blink-colon') {
                console.log('\nset blinking colon');
                topWin.blinkColon = true;
            }

            if (arg === '--show-border') {
                console.log('\nset show border');
                topWin.showBorder = true;
            }

        });
    }

    Rectangle {
        id: screen

        anchors.fill: parent

        FontLoader {
            //id: fixedFont; name: "Digi7"; source: "digital_7_mono.ttf"
            // id: fixedFont; source: "digital_7_mono.ttf"
            id: fixedFont;
            source: "digital_7_mono_italic.ttf";
            // source: "Digital Dismay.otf";
        }

        Rectangle {
            id: backgroundGradient
            anchors.fill: parent
            smooth: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: gradientStartColor }
                GradientStop { position: 1.0; color: gradientEndColor   }
            }
            opacity: 1.0
            border.color: (topWin.showBorder) ? foregroundTextColor : 'transparent'
            border.width: (topWin.showBorder) ? 1 : 0
        }

        Text {
            id: timeTextBackground
            text: (showSeconds) ? "88:88:88" : "88:88"
            anchors.fill: parent

            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.margins: sideMargin

            color: foregroundTextColor
            opacity: 0.15
            font.family: fixedFont.name
            font.pointSize: 62
            font.italic: true
            // font.styleName: font.italic
            // font.bold: true
        }

        Text {
            id: timeText
            text: "88:88:88"
            anchors.fill: parent
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.margins: sideMargin

            color: foregroundTextColor

            // opacity: 0.85
            font.family: fixedFont.name
            font.pointSize: 62
            font.italic: true
            // font.bold: true
            // font.letterSpacing: 100

            function updateFontSize() {
                font.pointSize = width * fontProportion;
                control.contentItem.font.pointSize = width * fontProportion * 0.33;
                timeTextBackground.font.pointSize = width * fontProportion;
                timeTextBackground.anchors.leftMargin = sideMargin * fontProportion;
            }

            onWidthChanged: updateFontSize()

        }

        Button {
            // text: qsTr("")
            opacity: 0

            anchors.fill: parent

            MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton // Accept both left and right clicks

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton && Qt.platform.os === 'osx') {
                            console.log("Right-clicked the button!");
                            // topWin.flags = Qt.FramelessWindowHint | Qt.Window;
                            topWin.flags = (topWin.flags === (Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint)) ? Qt.Window : (Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint);
                        }
                    }
                    onPressAndHold: {
                        control.show(topWin.dateString);
                        timeText.opacity = 0;
                        timeTextBackground.opacity = 0;
                    }

            onReleased: {
                control.hide();
                timeText.opacity = 1;
                timeTextBackground.opacity = (timeTextBackground.text) ? 0.15 : 0;
            }
            }

            // onPressAndHold: {
            //     control.show(topWin.dateString);
            //     timeText.opacity = 0;
            //     timeTextBackground.opacity = 0;
            // }

            // onReleased: {
            //     control.hide();
            //     timeText.opacity = 1;
            //     timeTextBackground.opacity = (timeTextBackground.text) ? 0.15 : 0;
            // }
        }

        ToolTip {
            id: control
            // text: qsTr("A descriptive tool tip of what the button does")
            // font: fixedFont.source

            contentItem: Text {
                text: control.text
                font.bold: true
                // font.pointSize: 16
                color: foregroundTextColor
                // color: SystemPalette.text
                anchors.centerIn: parent
            }

            background: Rectangle {
                // border.color: foregroundTextColor
                // border.width: 1.2
                // color: SystemPalette.base
                color: 'transparent'
                // opacity: 0.667
                anchors.fill: parent
            }

            anchors.centerIn: parent
        }

        Timer {
            id: clocktimerForSeparator
            triggeredOnStart: topWin.blinkColon ? true : false
            running: topWin.blinkColon ? true : false
            repeat: topWin.blinkColon ? true : false
            // interval: 750
            interval: 500
            onTriggered: {
                //
                topWin.separtorString = (topWin.toggleSeparator) ? ":" : " ";
                topWin.toggleSeparator = !topWin.toggleSeparator;
                timeText.text = topWin.timeStrElements.join(separtorString);
            }
        }

        Timer {
            id:clocktimer
            triggeredOnStart: true
            running: true
            repeat: true
            onTriggered: {
                //console.log(runtime.isActiveWindow);
                var timeStamp = Number(Date.now() + (hoursOffset * 60*60*1000));
                var date = new Date(timeStamp);
                // var rawHr = date.getHours();
                // if (rawHr < 12 /* midnight */) {
                //     rawHr = rawHr + 12;
                // }
                // var th = Number(date.getHours() + hoursOffset);
                // var th = Number(rawHr + hoursOffset);
                var th = date.getHours();
                var tm = date.getMinutes();
                var ts = date.getSeconds();

                // topWin.dateString = new Date(date.setHours(th)).toDateString();
                topWin.dateString = new Date(date.setHours(th)).toLocaleDateString(locale, "ddd MMM d yyyy");

                function formatHours(hrs) {
                    if ((twelveHours) && (hrs !== 12)) {
                        return hrs % 12;
                    }
                    return hrs;
                }

                function format(x) {
                    if (x < 10){
                        return '0' + x;
                    }
                    return x;
                }

                // // const sep = !(ts % 2) ? ":" : " ";
                // const sep = (topWin.toggleSeparator /* && !(tms % 250) */) ? ":" : " ";
                // if (!Boolean(tms % 500)) {
                //     topWin.toggleSeparator = !topWin.toggleSeparator;
                // }
                // var secondsString = (showSeconds) ? topWin.separtorString + format(ts) : "";
                var secondsString = (showSeconds) ? ":" + format(ts) : "";

                topWin.timeStrElements = [format(formatHours(th)), format(tm)];
                if (showSeconds) {
                    topWin.timeStrElements.push(format(ts));
                }
                // timeText.text = format(formatHours(th)) + topWin.separtorString + format(tm) + secondsString;
                // timeText.text = format(formatHours(th)) + ":" + format(tm) + secondsString;
                timeText.text = topWin.timeStrElements.join(separtorString);

                /* To show a date string ...
            var day = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][date.getDay()];
            var td = format(date.getDate());

            var tM = format(date.getMonth() + 1);
            var ty = format(date.getFullYear());
            */


                clocktimer.interval = 1000;
            }
        }
    }
}
