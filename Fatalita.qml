import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

import "fatalita"
                                                                                                                                
    //             *@@@@%      *%@@@@@@@.     #@@@@@@@%     =%@@@@@%.     #@@-        %@%      %@@@@@@@@@@@@@@@=   #%@@@@%+        
    //            #@@@@@%    =@@@#...       %@@%=. ..     #@@@#-.%@@@#   .@@#        +@@=     +@@*. ..%@@#...   +@@@%=.*@@@%       
    //           #@@  @@%    @@%           %@@           @@@#     #@@%   %@%         @@#      %@%     @@@      %@@%      @@@+      
    //          %@%  -@@#   -%@%           %@@*         @@@*      #@@%  +@@=        #@@      #@@     *@@-     %@@@      .@@@.      
    //         @@%   =@@+    =@@@%=         %@@@#      %@@%       @@@#  @@#        =@@+     -@@*     @@%     =@@@       %@@%       
    //        @@#    *@@-       %@@@*         *@@@%   -@@@       %@@@  #@@         %@%      %@%     %@@      %@@#       @@@=       
    //       %@@@%%%%@@@          %@@%          *@@@= #@@@      .@@@= =@@+        #@@      #@@.    *@@*     -@@@       @@@#        
    //     =@@%%%@@%@@@@          +@%%           %@@= %@@%     .@@@*  %@#        -@@*     -@@*     @@%      +@@@      %@@%         
    //    +@@-       %@@         %@@@.         =@@@#  *@@@-   %@@@=  #@@-        *@@*    .@@@     %@@        @@@#   *@@@#          
    //   #@%         %@@@@@@@@@@@@@#   %@@@@@@@@@%=    +%@@@@@@%-   -@@@@@@@@@%   #%@@@@@@@*     -@@#         %@@@@@@%*            
                                                                                                                                
                                                                                                                                
Item {
    /*#########################################################################
      #############################################################################
      Imported Values From GAWR inits
      #############################################################################
      #############################################################################
     */
    id: root
    ////////// IC7 LCD RESOLUTION ////////////////////////////////////////////
    width: 800
    height: 480
    
    z: 0
    
    property int myyposition: 0
    property int udp_message: rpmtest.udp_packetdata

    property bool udp_up: udp_message & 0x01
    property bool udp_down: udp_message & 0x02
    property bool udp_left: udp_message & 0x04
    property bool udp_right: udp_message & 0x08

    property int membank2_byte7: rpmtest.can203data[10]
    property int inputs: rpmtest.inputsdata

    //Inputs//31 max!!
    property bool ignition: inputs & 0x01
    property bool battery: inputs & 0x02
    property bool lapmarker: inputs & 0x04
    property bool rearfog: inputs & 0x08
    property bool mainbeam: inputs & 0x10
    property bool up_joystick: inputs & 0x20 || root.udp_up
    property bool leftindicator: inputs & 0x40
    property bool rightindicator: inputs & 0x80
    property bool brake: inputs & 0x100
    property bool oil: inputs & 0x200
    property bool seatbelt: inputs & 0x400
    property bool sidelight: inputs & 0x800
    property bool tripresetswitch: inputs & 0x1000
    property bool down_joystick: inputs & 0x2000 || root.udp_down
    property bool doorswitch: inputs & 0x4000
    property bool airbag: inputs & 0x8000
    property bool tc: inputs & 0x10000
    property bool abs: inputs & 0x20000
    property bool mil: inputs & 0x40000
    property bool shift1_id: inputs & 0x80000
    property bool shift2_id: inputs & 0x100000
    property bool shift3_id: inputs & 0x200000
    property bool service_id: inputs & 0x400000
    property bool race_id: inputs & 0x800000
    property bool sport_id: inputs & 0x1000000
    property bool cruise_id: inputs & 0x2000000
    property bool reverse: inputs & 0x4000000
    property bool handbrake: inputs & 0x8000000
    property bool tc_off: inputs & 0x10000000
    property bool left_joystick: inputs & 0x20000000 || root.udp_left
    property bool right_joystick: inputs & 0x40000000 || root.udp_right

    property int odometer: rpmtest.odometer0data/10*0.62 //Need to div by 10 to get 6 digits with leading 0
    property int tripmeter: rpmtest.tripmileage0data*0.62
    property real value: 0
    property real shiftvalue: 0

    property real rpm: rpmtest.rpmdata
    property real rpmlimit: 8000 //Originally was 7k, switched to 8000 -t
    property real rpmdamping: 5
    property real speed: rpmtest.speeddata
    property int speedunits: 2

    property real watertemp: rpmtest.watertempdata
    property real waterhigh: 0
    property real waterlow: 80
    property real waterunits: 1

    property real fuel: rpmtest.fueldata
    property real fuelhigh: 0
    property real fuellow: 0
    property real fuelunits
    property real fueldamping

    property real o2: rpmtest.o2data
    property real map: rpmtest.mapdata
    property real maf: rpmtest.mafdata

    property real oilpressure: rpmtest.oilpressuredata
    property real oilpressurehigh: 0
    property real oilpressurelow: 0
    property real oilpressureunits: 0

    property real oiltemp: rpmtest.oiltempdata
    property real oiltemphigh: 90
    property real oiltemplow: 90
    property real oiltempunits: 1
    property real oiltemppeak: 0

    property real batteryvoltage: rpmtest.batteryvoltagedata

    property int mph: (speed * 0.62)

    property int gearpos: rpmtest.geardata

    property real speed_spring: 1
    property real speed_damping: 1

    property real rpm_needle_spring: 3.0 //if(rpm<1000)0.6 ;else 3.0
    property real rpm_needle_damping: 0.2 //if(rpm<1000).15; else 0.2

    property bool changing_page: rpmtest.changing_pagedata


    property string primary_color: "#FFFFFF"
    property string sidelight_yellow: "#FFFF00"
    property string warning_red: "#EF3D23"
    property string digital_green: "#9BC963"
    property string idle_green: "#232F17"

    property int timer_time: 1

    //Peak Values

    property int peak_rpm: 0
    property int peak_speed: 0
    property int peak_water: 0
    property int peak_oil: 0

    x: 0
    y: 0

    //Fonts
    FontLoader {
        id: dSEGbi
        source: "./fonts/DSEG7ClassicMini-BoldItalic.ttf"
    }

    //Master Function/Timer for Peak values
    function checkPeaks() {
        if (root.rpm > root.peak_rpm) {
            root.peak_rpm = root.rpm;
        }
        if (root.speed > root.peak_speed) {
            root.peak_speed = root.speed;
        }
        if (root.watertemp > root.peak_water) {
            root.peak_water = root.watertemp;
        }
        if (root.oiltemp > root.peak_oil) {
            root.peak_oil = root.oiltemp;
        }
    }
    function getGear(){
        switch(rpmtest.geardata){
            case 0:
                return "./fatalita/shift/n.png"
            case 1:
                return "./fatalita/shift/1.png"
            case 2:
                return "./fatalita/shift/2.png"
            case 3:
                return "./fatalita/shift/3.png"
            case 4:
                return "./fatalita/shift/4.png"
            case 5:
                return "./fatalita/shift/5.png"
            case 6:
                return "./fatalita/shift/6.png"
            case 10:
                return "./fatalita/shift/r.png"
            default:
                return  "./fatalita/shift/dash.png"
        }
    }

    
    function easyFtemp(degreesC){
        return ((((degreesC.toFixed(0))*9)/5)+32).toFixed(0)
    }

    function getTemp(fluid) {
        var isCoolant = (fluid === "COOLANT");
        var isPeak = root.seatbelt;
        var units = isCoolant ? root.waterunits : root.oiltempunits;
        var value = isCoolant
            ? (isPeak ? root.peak_water : root.watertemp)
            : (isPeak ? root.peak_oil : root.oiltemp);
        var suffix = isPeak ? "P" : (units !== 1 ? "F" : "C");
        if (units !== 1) {
            value = easyFtemp(value);
        } else {
            value = value.toFixed(0);
        }
        return value + suffix;
    }

    function padStart(str, targetLength, padString) {
        while (str.length < targetLength) {
            str = padString + str;
        }
        return str;
    }

    function roundToNearest250(num) {
        if (num <= 0) return 0;
        if (num <= 500) return 500;
        if (num <= 1000) return 1000;
        return Math.floor((num - 1000) / 250) * 250 + 1000;
    }

    Timer{
        interval: 10; running: true; repeat: true 
        onTriggered: checkPeaks()
    }

    /* ########################################################################## */
    /* Main Layout items */
    /* ########################################################################## */
    Rectangle {
        id: background_rect
        x: 0
        y: 0
        width: 800
        height: 480
        color: "#000000"
        border.width: 0
        z: 0
    }
    Image{
        x:34;y:16;z:2
        source: "./fatalita/tach/"+(root.sidelight?"yellow":"white")+"/"+roundToNearest250(root.rpm);
    }
    Image{
        x:0;y:289;z:1
        source: "./fatalita/gauge_holder.png"
    }
    Image{
        x:362;y:191;z:2
        source:getGear();
    }
    Image{
        id: left_blinker
        x: 300; y:242; z: 2
        source: root.leftindicator ? "./fatalita/left_blinker_on.png" : "./fatalita/left_blinker_off.png"
    }
    Image{
        id: right_blinker
        x: 470; y:242; z: 2
        source: root.rightindicator ? "./fatalita/right_blinker_on.png" : "./fatalita/right_blinker_off.png"
    }
    Image{
        x: 213;y:295;z:2
        source: "./fatalita/shiftlight_dim.png"
    }
    Image{
        x:201;y:282;z:2
        source: "./fatalita/shiftlight_lit.png"
        visible: root.rpm >= root.rpmlimit
        Timer{
                id: rpm_shift_blink
                running: true
                interval: 50
                repeat: true
                onTriggered: if(parent.opacity === 0){
                    parent.opacity = 100
                }
                else{
                    parent.opacity = 0
                } 
            }
    }
        // Sequential fade-in animation for column items at y:343
    property real col1Opacity: 0
    property real col2Opacity: 0
    property real col3Opacity: 0
    property real col4Opacity: 0
    property real col5Opacity: 0

    SequentialAnimation {
        id: columnsFadeIn
        running: true
        NumberAnimation { target: root; property: "col1Opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { target: root; property: "col2Opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { target: root; property: "col3Opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { target: root; property: "col4Opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { target: root; property: "col5Opacity"; from: 0; to: 1; duration: 200 }
    }

    Item{
        x:28;y:343.6
        z:2
        opacity: root.col1Opacity
        Image{
            source: !root.sidelight ? "./fatalita/secondaries/water_white.png" : "./fatalita/secondaries/water_yellow.png"
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            text: "8888"
            color: root.idle_green
            z:3
            x:20;y:85
            width:52
            horizontalAlignment: Text.AlignRight
        }

        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:20;y:85
            text: getTemp("COOLANT")
            width:52
            horizontalAlignment: Text.AlignRight
        } 
        
        Rectangle {
            color: "transparent"
            height: 78
            width: 65
            x: 10
            y: 0
            z: 4
            Column {
                z:5
                id: waterColumn
                spacing: 2.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                property int visibleBars: Math.max(0, Math.min(10, Math.floor((root.watertemp - 10) / 10)))
                property bool blink: root.watertemp > root.waterhigh
                property real blinkOpacity: 1.0
                Timer {
                    interval: 60; running: parent.blink; repeat: true
                    onTriggered: parent.blinkOpacity = parent.blinkOpacity === 1.0 ? 0.1 : 1.0
                }
                Repeater {
                    model: 10
                    Rectangle {
                        width: 65
                        height: 5.5
                        color: (9 - index) < parent.visibleBars ? (index < 2 ? root.warning_red : (!root.sidelight ? root.primary_color : root.sidelight_yellow)) : "transparent"
                        border.width: (9 - index) < parent.visibleBars ? 0 : 1
                        border.color: index < 2 ? root.warning_red : (!root.sidelight ? root.primary_color : root.sidelight_yellow)
                        opacity: (9 - index) < parent.visibleBars ? (parent.blink ? parent.blinkOpacity : 1.0) : 0.5
                    }
                }
            }
        }

    }
    Item{
        x:209;y:343.6
        z:2
        opacity: root.col2Opacity
        Image{
            source: !root.sidelight ? "./fatalita/secondaries/oil_temp_white.png" : "./fatalita/secondaries/oil_temp_yellow.png"
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            text: "8888"
            color: root.idle_green
            z:3
            x:20;y:85
            width:52
            horizontalAlignment: Text.AlignRight
        }

        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:20;y:85
            text: getTemp("OIL")
            width:52
            horizontalAlignment: Text.AlignRight
        }
        Rectangle {
            color: "transparent"
            height: 78
            width: 65
            x: 10
            y: 0
            z: 4
            Column {
                z:5
                id: oilTempColumn
                spacing: 2.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                property int visibleBars: Math.max(0, Math.min(10, Math.floor((root.oiltemp - 40) / 10)))
                property bool blink: root.oiltemp > root.oiltemphigh
                property real blinkOpacity: 1.0
                Timer {
                    interval: 60; running: parent.blink; repeat: true
                    onTriggered: parent.blinkOpacity = parent.blinkOpacity === 1.0 ? 0.1 : 1.0
                }
                Repeater {
                    model: 10
                    Rectangle {
                        width: 65
                        height: 5.5
                        color: (9 - index) < parent.visibleBars ? (index < 2 ? root.warning_red : (!root.sidelight ? root.primary_color : root.sidelight_yellow)) : "transparent"
                        border.width: (9 - index) < parent.visibleBars ? 0 : 1
                        border.color: index < 2 ? root.warning_red : (!root.sidelight ? root.primary_color : root.sidelight_yellow)
                        opacity: (9 - index) < parent.visibleBars ? (parent.blink ? parent.blinkOpacity : 1.0) : 0.5
                    }
                }
            }
        }
    }
    Item{
        x:308;y:343.6
        z:2
        opacity: root.col3Opacity   
        Image{
            source: !root.sidelight ? "./fatalita/secondaries/oil_press_white.png" : "./fatalita/secondaries/oil_press_yellow.png"
        }
        
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            text: "8888"
            color: root.idle_green
            z:3
            x:20;y:85
            width:52
            horizontalAlignment: Text.AlignRight
        }

        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:20;y:85
            text: if(root.oilpressureunits === 1) root.oilpressure.toFixed(1); else (root.oilpressure.toFixed(1) * 14.504).toFixed(0)
            width:52
            horizontalAlignment: Text.AlignRight
        } 
        Rectangle {
            color: "transparent"
            height: 78
            width: 65
            x: 10
            y: 0
            z: 4
            
            Column {
                z:5
                id: oilPressColumn
                spacing: 2.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                property int visibleBars: Math.max(0, Math.min(10, Math.floor((root.oilpressure.toFixed(0)))))
                property bool blink: root.oilpressure < root.oilpressurelow
                property real blinkOpacity: 1.0
                Timer {
                    interval: 60; running: parent.blink; repeat: true
                    onTriggered: parent.blinkOpacity = parent.blinkOpacity === 1.0 ? 0.1 : 1.0
                }
                Repeater {
                    model: 10
                    Rectangle {
                        width: 65
                        height: 5.5
                        color: (9 - index) < parent.visibleBars ? (index < 8 ? (!root.sidelight ? root.primary_color : root.sidelight_yellow) : root.warning_red) : "transparent"
                        border.width: (9 - index) < parent.visibleBars ? 0 : 1
                        border.color: index < 8 ? (!root.sidelight ? root.primary_color : root.sidelight_yellow) : root.warning_red
                        opacity: (9 - index) < parent.visibleBars ? (parent.blink ? parent.blinkOpacity : 1.0) : 0.5
                        
                    }
                }
            }
        }
    }
    Item{
        id: extrasColumn
        x:407;y:343
        z:2
        opacity: root.col4Opacity
        Image{
            source: !root.sidelight ? "./fatalita/secondaries/extras_white.png" : "./fatalita/secondaries/extras_yellow.png"
        }
        Image{
            x: 11; y: 82
            z: 3    
            source: !root.sidelight ? (root.speedunits === 0 ? "./fatalita/km_label_white.png" : "./fatalita/mi_label_white.png") : (root.speedunits === 0 ? "./fatalita/km_label_yellow.png" : "./fatalita/mi_label_yellow.png")
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            text: "8888"
            color: root.idle_green
            z:3
            x:115;y:12
            width:52
            horizontalAlignment: Text.AlignRight
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:115;y:12
            text: root.o2.toFixed(2)
            width:52
            horizontalAlignment: Text.AlignRight
        }

        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            text: "8888"
            color: root.idle_green
            z:3
            x:115;y:46
            width: 52
            horizontalAlignment: Text.AlignRight
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:115;y:46
            text: root.batteryvoltage.toFixed(1)
            width: 52
            horizontalAlignment: Text.AlignRight
        }

        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            text: "888888"
            color: root.idle_green
            width: 86
            z:3
            x:80;y:80
            horizontalAlignment: Text.AlignRight
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 18
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:80;y:80
            text: root.speedunits === 0 ? root.odometer.toFixed(0) : (root.odometer * 0.621371).toFixed(0)
            width: 86
            horizontalAlignment: Text.AlignRight
        }
    }
    Item{
        x:681;y:343.6
        z:2
        opacity: root.col5Opacity
        Image{
            source: !root.sidelight ? "./fatalita/secondaries/fuel_white.png" : "./fatalita/secondaries/fuel_yellow.png"
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            text: "888"
            color: root.idle_green
            z:3
            x:16;y:85
            width:52
            horizontalAlignment: Text.AlignRight
        }
        Text{
            font.family: dSEGbi.name
            font.pixelSize: 16
            font.bold: true
            font.italic: true
            color: root.digital_green
            z:4
            x:16;y:85
            text: root.fuel
            width:52
            horizontalAlignment: Text.AlignRight
        }
        Rectangle {
            color: "transparent"
            height: 78
            width: 65
            x: 15
            y: 0
            z: 4
            
            Column {
                z:5
                id: fuelColumn
                spacing: 2.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                property int visibleBars: Math.max(0, Math.min(10, Math.floor((root.fuel.toFixed(0)) / 10)))
                property bool blink: root.fuel < root.fuellow
                property real blinkOpacity: 1.0
                Timer {
                    interval: 60; running: parent.blink; repeat: true
                    onTriggered: parent.blinkOpacity = parent.blinkOpacity === 1.0 ? 0.1 : 1.0
                }
                Repeater {
                    model: 10
                    Rectangle {
                        width: 65
                        height: 5.5
                        color: (9 - index) < parent.visibleBars ? (index < 8 ? (!root.sidelight ? root.primary_color : root.sidelight_yellow) : root.warning_red) : "transparent"
                        border.width: (9 - index) < parent.visibleBars ? 0 : 1
                        border.color: index < 8 ? (!root.sidelight ? root.primary_color : root.sidelight_yellow) : root.warning_red
                        opacity: (9 - index) < parent.visibleBars ? (parent.blink ? parent.blinkOpacity : 1.0) : 0.5
                    }
                }
            }
        } 
    }
    Text{
        id: rpm_text
        font.family: dSEGbi.name
        font.pixelSize: 32
        font.bold: true
        font.italic: true
        text: root.rpm.toFixed(0)
        color: root.digital_green
        z: 3
        x: 664.2; y: 140
        width: 105.4
        horizontalAlignment: Text.AlignRight
    }
    Text{
        id: rpm_text_bkg
        font.family: dSEGbi.name
        font.pixelSize: 32
        font.bold: true
        font.italic: true
        text: "18888"
        color: root.idle_green
        z: 2
        x: 664.2; y: 140
        width: 105.4
        horizontalAlignment: Text.AlignRight
    }
    Text{
        id: speed_text
        font.family: dSEGbi.name
        font.pixelSize: 60
        font.bold: true
        font.italic: true
        text: if (root.speedunits === 0) root.speed.toFixed(0); else (root.speed*.62).toFixed(0)

        color: root.digital_green
        z: 3
        x: 620.6; y: 185
        width: 148
        horizontalAlignment: Text.AlignRight
    }
    Text{
        id: speed_text_bkg
        font.family: dSEGbi.name
        font.pixelSize: 60
        font.bold: true
        font.italic: true
        text: "888"
        color: root.idle_green
        z: 2
        x: 620.6; y: 185
        width: 148
        horizontalAlignment: Text.AlignRight
    }
    Image{
        id: speed_label
        x: 648; y: 260
        source: root.speedunits !== 0 ? "./fatalita/mi_speed.png" : "./fatalita/km_speed.png"
    }
    Item{
        id: idiotLights
        x: 16; y: 16
        Image{
            x:0;y:0;z:2
            source: "./fatalita/idiotlights/door.png"
            opacity: root.doorswitch ? 1 : 0.2
        }
        Image{
            x:64;y:0;z:2
            source: "./fatalita/idiotlights/seatbelt.png"
            opacity: root.seatbelt ? 1 : 0.2
        }
        Image{
            x:124;y:0;z:2
            source: "./fatalita/idiotlights/battery.png"
            opacity: root.battery ? 1 : 0.2
        }
        Image{
            x:0;y:44;z:2
            source: "./fatalita/idiotlights/cil.png"
            opacity: root.mil ? 1 : 0.2
        }
        Image{
            x: 54;y:44;z:2
            source: "./fatalita/idiotlights/oil.png"
            opacity: root.oil ? 1 : 0.2
        }
        Image{
            x:131;y:44;z:2
            source: "./fatalita/idiotlights/airbag.png"
            opacity: root.airbag ? 1 : 0.2
        }
        Image{
            x:0;y:90;z:2
            source: "./fatalita/idiotlights/brake.png"
            opacity: root.brake ? 1 : 0.2
        }
        Image{
            x:60;y:90;z:2
            source: "./fatalita/idiotlights/abs.png"
            opacity: root.abs ? 1 : 0.2
        }
        Image{
            x:0;y:130;z:2
            source: "./fatalita/idiotlights/brights.png"
            opacity: root.mainbeam ? 1 : 0.2
        }
    }


} //End Fatalita dash



