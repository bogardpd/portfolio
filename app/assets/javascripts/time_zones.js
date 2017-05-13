/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

const timeZoneList = [["−12:00",-12],["−11:00",-11],["−10:00",-10],["−09:30",-9.5],["−09:00",-9],["−08:00",-8],["−07:00",-7],["−06:00",-6],["−05:00",-5],["−04:00",-4],["−03:30",-3.5],["−03:00",-3],["−02:30",-2.5],["−02:00",-2],["−01:00",-1],["",0],["+01:00",1],["+01:30",1.5],["+02:00",2],["+03:00",3],["+03:30",3.5],["+04:00",4],["+04:30",4.5],["+05:00",5],["+05:30",5.5],["+05:45",5.75],["+06:00",6],["+06:30",6.5],["+07:00",7],["+08:00",8],["+08:30",8.5],["+09:00",9],["+09:30",9.5],["+10:00",10],["+10:30",10.5],["+11:00",11],["+12:00",12],["+12:45",12.75],["+13:00",13],["+13:45",13.75],["+14:00",14]];

$(function() {
  // Run on page load:
  $("#js-warning").remove();
  data = location.search.split("data=")[1];
  if (typeof data == "undefined") {
    createTableRows(3);
  } else {
    data = JSON.parse(decodeURIComponent(data));
    createTableRows(data.length);
    populateTable(data);
    updateChart();
  }
  $(".hidden-by-default").show();
  setEventTriggers();
  
});

function setEventTriggers() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii", pickerPosition: "top-left"});
  $("input, select").off().on("blur change", updateChart);
  $(".button-insert").off().on("click", function() { insertRow($(this)); });
  $(".button-delete").off().on("click", function() { deleteRow($(this)); });
}

function updateChart() {
  var timeZoneLocations = [];
  $locationRows = $("tr.row-location");
  var rowCount = $locationRows.length;
  for(i = 0; i < rowCount; i++) {
    $row = $locationRows.eq(i);
    timeZoneLocations[i] = {
      start:    $row.find(".field-start").val(),
      location: $row.find(".field-location").val(),
      offset:   parseFloat($row.find(".field-offset").val()),
      end:      $row.find(".field-end").val()
    };
  }
  str = timeZoneLocations.map(function(element, index) {
    return index + ": " + JSON.stringify(element);
  }).join("<br/>");
  $("#chart").html(str);
  updateShareLink(timeZoneLocations);
}

function updateShareLink(timeZoneLocations) {
  data = encodeURIComponent(JSON.stringify(timeZoneLocations));
  //window.history.replaceState({},"",[location.protocol, '//', location.host, location.pathname, "?data=", data].join(''));
  $("#share-link").attr("href", [location.protocol,'//',location.host,location.pathname,"?data=",data].join(''));
}

/* HTML CREATION FUNCTIONS */

function createInsertButton() {
  return '<div class="btn btn-success button-insert" title="Add a location before this one"><span class="glyphicon glyphicon-plus"></span></div>';
}

function createDateTime(fieldName) {
  html = '<div class="form-group"><div class="input-group date dtpicker">';
  html += '<input type="text" class="form-control field-' + fieldName + '" />';
  html += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  html += '</div></div>';
  return html;
}

function createOffsetSelect() {
  html = '<div class="form-group"><select class="form-control field-offset">';
  html += timeZoneList.map(function(element) {
    return '<option value="' + element[1] + '"' + (element[1] == 0 ? ' selected' : '') +'>UTC' + element[0] + '</option>';
  }).join("\n");
  html += '</select></div>';
  return html;
}

function createTableRows(numberOfRows) {
  $tableBody = $("tbody");
  for (i = 0; i < numberOfRows; i++) {
    $tableBody.append(createRow());
  }
  $tableBody.append('<tr><td>' + createInsertButton() + '</td><td colspan="5"></td></tr>');
  $(".row-location .form-group").filter(":first, :last").remove(); // Remove first start time and last end time
}

function createRow() {
  row = '<tr class="row-location">';
  row += '<td class="cell-insert">' + createInsertButton() + '</td>';
  row += '<td class="cell-start">' + createDateTime("start") + '</td>';
  row += '<td class="cell-location"><div class="form-group"><input type="text" class="form-control field-location" /></div></td>'
  row += '<td class="cell-offset">' + createOffsetSelect() + '</td>';
  row += '<td class="cell-end">' + createDateTime("end") + '</td>';
  row += '<td class="cell-delete"><div class="btn btn-danger button-delete" title="Delete this location"><span class="glyphicon glyphicon-trash"></span></div></td>';
  row += '</tr>';
  return row
}

/* TABLE MANIPULATION FUNCTIONS */

function populateTable(timeZoneLocations) {
  timeZoneLocations.map(function(element, index) {
    $row = $(".row-location").eq(index);
    $row.find(".field-start").val(element["start"]);
    $row.find(".field-location").val(element["location"]);
    $row.find(".field-offset").val(element["offset"]);
    $row.find(".field-end").val(element["end"]);
  }).join("<br/>");
}

function insertRow(button) {
  position = parseInt($(".button-insert").index(button));
  if (position < $(".row-location").length) {
    $oldRow = $(".row-location").eq(position)
    $oldRow.before(createRow());
    $newRow = $(".row-location").eq(position)
    $newRow.hide();
    if (position == 0) {
      $oldRow.find("td").eq(1).append(createDateTime("start"));
      $newRow.find(".form-group").filter(":first").remove();
    }
    $newRow.find(".field-offset").val($oldRow.find(".field-offset").val())
    $newRow.fadeIn();
  } else {
    $oldRow = $(".row-location").filter(":last");
    $oldRow.find("td").eq(4).append(createDateTime("end"));
    $oldRow.after(createRow());
    $newRow = $(".row-location").filter(":last");
    $newRow.hide();
    $newRow.find(".form-group").filter(":last").remove();
    $newRow.find(".field-offset").val($oldRow.find(".field-offset").val())
    $newRow.fadeIn();
  }
  
  setEventTriggers();
  
}

function deleteRow(button) {
  position = getPositionFromID(button.attr('id'));
  console.log("Delete row " + position);
  // Delete row:
  // Shift everything up after the given position:  
  // Update chart:
}