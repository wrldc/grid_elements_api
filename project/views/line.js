function createLines() {
    createLine(1);
}

function createLine(i) {
    //voltage	End-1	End-2	Id	Line Owner	End-1 Owner	End-2 Owner	Km
    // Conductor Type	SIL	No Load MVAR Generated	End1 LR MVAR	End1 LR S/W	End2 LR MVAR	End2 LR S/W

    var voltage = sReader.statesArrays[0][i][0];
    if (voltage == undefined || voltage == null || voltage.trim() == "") {
        WriteLineConsole("Encountered a blank voltage level at row " + i + ". So this row insertion is skipped");
        return;
    }
    var end1SSName = sReader.statesArrays[0][i][1];
    var end2SSName = sReader.statesArrays[0][i][2];
    var lineNumber = sReader.statesArrays[0][i][3];
    var lineOwnerName = sReader.statesArrays[0][i][4].split("/").map(Function.prototype.call, String.prototype.trim);
    var end1SSOwnerName = sReader.statesArrays[0][i][5];
    var end2SSOwnerName = sReader.statesArrays[0][i][6];
    var km = sReader.statesArrays[0][i][7];
    var conductor_type_Name = sReader.statesArrays[0][i][8];
    var sil = sReader.statesArrays[0][i][9];
    var noLoadMVar = sReader.statesArrays[0][i][10];
    var end1LRMvar = sReader.statesArrays[0][i][11];
    var end1IsSwitchable = sReader.statesArrays[0][i][12];
    var end2LRMvar = sReader.statesArrays[0][i][13];
    var end2IsSwitchable = sReader.statesArrays[0][i][14];

    if (end1SSName == undefined || end1SSName == null || end1SSName.trim() == "") {
        WriteLineConsole("Encountered a blank end1 SS Name name at row " + i);
        return
    }
    if (end2SSName == undefined || end2SSName == null || end2SSName.trim() == "") {
        WriteLineConsole("Encountered a blank end2 SS Name name at row " + i);
        return
    }
    //WriteLineConsole("Creating (" + Line + ", " + ownerName + ", " + voltage + ")");
    //Insert into the lines table
    forceCreateALine(voltage, end1SSName, end2SSName, lineNumber, lineOwnerName, end1SSOwnerName, end2SSOwnerName, km, conductor_type_Name, sil, noLoadMVar, end1LRMvar, end1IsSwitchable, end2LRMvar, end2IsSwitchable, i);
}

function forceCreateALine(voltage, end1SSName, end2SSName, lineNumber, lineOwnerName, end1SSOwnerName, end2SSOwnerName, km, conductor_type_Name, sil, noLoadMVar, end1LRMvar, end1IsSwitchable, end2LRMvar, end2IsSwitchable, iter, callback) {
    var successFunction = (function (iter) {
        return function (data) {
            if (data["Error"]) {
                WriteLineConsole("Line " + iter + "couldn't be inserted, Error: " + JSON.stringify(data.Error));
            } else {
                console.log(data);
                if (true) {
                    WriteLineConsole("The Line " + iter + " is created :-)");
                } else {
                    WriteLineConsole("The Line " + iter + " is not created :-(");
                }
            }
            createLine(iter + 1);
        };
    })(iter);
    var errorFunction = (function (iter) {
        return function (jqXHR, textStatus, errorThrown) {
            console.log(textStatus, errorThrown);
            WriteLineConsole("The Line " + iter + " is not created :-(");
            createLine(iter + 1);
        };
    })(iter);
    $.ajax({
            //create owner through post request
            url: "http://localhost:3000/api/lines/create_from_csv",
            type: "POST",
            data: {
                voltage: voltage,
                substation_names: [end1SSName, end2SSName].map(Function.prototype.call, String.prototype.trim),
                substation_voltages: [voltage, voltage],
                line_number: lineNumber,
                owner_names: lineOwnerName,
                end1SSOwnerName: end1SSOwnerName,
                end2SSOwnerName: end2SSOwnerName,
                line_length: km,
                conductor_type: conductor_type_Name,
                sil: sil,
                no_load_mvar: noLoadMVar,
                end1LRMvar: end1LRMvar,
                end1IsSwitchable: end1IsSwitchable,
                end2LRMvar: end2LRMvar,
                end2IsSwitchable: end2IsSwitchable
            },
            dataType: "json",
            success: successFunction,
            error: errorFunction
        }
    );
}