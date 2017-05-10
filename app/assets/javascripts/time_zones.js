/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

const timeZoneList = [["−12:00",-12],["−11:00",-11],["−10:00",-10],["−09:30",-9.5],["−09:00",-9],["−08:00",-8],["−07:00",-7],["−06:00",-6],["−05:00",-5],["−04:00",-4],["−03:30",-3.5],["−03:00",-3],["−02:30",-2.5],["−02:00",-2],["−01:00",-1],["",0],["+01:00",1],["+01:30",1.5],["+02:00",2],["+03:00",3],["+03:30",3.5],["+04:00",4],["+04:30",4.5],["+05:00",5],["+05:30",5.5],["+05:45",5.75],["+06:00",6],["+06:30",6.5],["+07:00",7],["+08:00",8],["+08:30",8.5],["+09:00",9],["+09:30",9.5],["+10:00",10],["+10:30",10.5],["+11:00",11],["+12:00",12],["+12:45",12.75],["+13:00",13],["+13:45",13.75],["+14:00",14]];

$(function() {
  // Run on page load:
  $("#js-warning").remove();
  createTableRows(3);
  $(".hidden-by-default").show();
  setEventTriggers();
});

function setEventTriggers() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii"});
  $("input").on("blur change", updateChart);
  $("select").on("blur", updateChart);
  $(".insert-row").on("click", function() { insertRow($(this)); });
  $(".delete-row").on("click", function() { deleteRow($(this)); });
}

function updateChart() {
  var timeZoneLocations = [];
  $locationRows = $("tr.location-row");
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
}

/* HTML CREATION FUNCTIONS */

function createInsertButton() {
  return '<div class="btn btn-success insert-row" title="Add a location before this one"><span class="glyphicon glyphicon-plus"></span></div>';
}

function createOffsetSelect() {
  html = '<div class="form-group"><select class="form-control field-offset">';
  html += timeZoneList.map(function(element) {
    return '<option value="' + element[1] + '"' + (element[1] == 0 ? ' selected' : '') +'>UTC' + element[0] + '</option>';
  }).join("\n");
  html += '</select></div>';
  console.log(html);
  return html;
}

function createTableRows(numberOfRows) {
  $tableBody = $("tbody");
  for (i = 0; i < numberOfRows; i++) {
    $tableBody.append(createRow());
  }
  $tableBody.append('<tr><td>' + createInsertButton() + '</td><td colspan="5"></td></tr>');
  $(".location-row .form-group").filter(":first, :last").remove(); // Remove first start time and last end time
}

function createRow() {
  row = '<tr class="location-row">';
  row += '<td>' + createInsertButton() + '</td>';
  row += '<td><div class="form-group"><div class="input-group date dtpicker">';
  row += '<input type="text" class="form-control field-start" />';
  row += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  row += '</div></div></td>';
  row += '<td><div class="form-group"><input type="text" class="form-control field-location" /></div></td>'
  row += '<td>' + createOffsetSelect() + '</td>';
  row += '<td><div class="form-group"><div class="input-group date dtpicker">';
  row += '<input type="text" class="form-control field-end" />';
  row += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  row += '</div></div></td>';
  row += '<td><div class="btn btn-danger delete-row" title="Delete this location"><span class="glyphicon glyphicon-trash"></span></div></td>';
  row += '</tr>';
  return row
}

/* TABLE MANIPULATION FUNCTIONS */

function insertRow(button) {
  position = getPositionFromID(button.attr('id'));
  console.log("Insert row at position " + position);
  // Add new row at end:
  var newRowID = $("tr.location-row").length;
  $(".location-row").last().after(createRow(newRowID));
  setEventTriggers();
  
  // Shift everything down after the given position:
  // Insert row:  
  // Update chart:
}

function deleteRow(button) {
  position = getPositionFromID(button.attr('id'));
  console.log("Delete row " + position);
  // Delete row:
  // Shift everything up after the given position:  
  // Update chart:
}

// Takes an ID string and extracts the integer potion from it
function getPositionFromID(id) {
  return parseInt(id.substring(id.indexOf("_")+1,id.length))
}