/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

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
  return '<td><div class="btn btn-success insert-row" title="Add a location before this one"><span class="glyphicon glyphicon-plus"></span></div></td>';
}

function createTableRows(numberOfRows) {
  $tableBody = $("tbody");
  for (i = 0; i < numberOfRows; i++) {
    $tableBody.append(createRow());
  }
  $tableBody.append('<tr>' + createInsertButton() + '<td colspan="5"></td></tr>');
  $(".location-row .form-group").filter(":first, :last").remove(); // Remove first start time and last end time
}

function createRow() {
  row = '<tr class="location-row">';
  row += createInsertButton();
  row += '<td><div class="form-group"><div class="input-group date dtpicker">';
  row += '<input type="text" class="form-control field-start" />';
  row += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  row += '</div></div></td>';
  row += '<td><div class="form-group"><input type="text" class="form-control field-location" /></div></td>'
  row += '<td><div class="form-group"><select class="form-control field-offset">';
  row += '<option value="1.5">UTC+01:30</option>';
  row += '<option value="-5">UTC-05:00</option>';
  row += '</select></div></td>';
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