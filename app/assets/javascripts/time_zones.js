/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

$(function() {
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
  var rowCount = $("tr.location-row").length;
  for(i = 0; i < rowCount; i++) {
    timeZoneLocations[i] = {
      start:    $("#start_"+i).val(),
      location: $("#location_"+i).val(),
      offset:   parseFloat($("#offset_"+i).val()),
      end:      $("#end_"+i).val()
    };
  }
  str = timeZoneLocations.map(function(element, index) {
    return index + ": " + JSON.stringify(element);
  }).join("<br/>");
  $("#chart").html(str);
}

function createRow(id) {
  row = '<tr class="location-row" id="row_' + id + '">';
  row += '<td><div class="btn btn-success insert-row" id="insert_' + id + '" title="Add a location before this one"><span class="glyphicon glyphicon-plus"></span></div></td>';
  row += '<td><div class="form-group"><div class="input-group date dtpicker">';
  row += '<input id="start_' + id + '" type="text" class="form-control" />';
  row += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  row += '</div></div></td>';
  row += '<td><div class="form-group"><input type="text" class="form-control" id="location_' + id + '" /></div></td>'
  row += '<td><div class="form-group"><select class="form-control" id="offset_' + id + '">';
  row += '<option value="1.5">UTC+01:30</option>';
  row += '<option value="-5">UTC-05:00</option>';
  row += '</select></div></td>';
  row += '<td><div class="form-group"><div class="input-group date dtpicker">';
  row += '<input id="end_' + id + '" type="text" class="form-control" />';
  row += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  row += '</div></div></td>';
  row += '<td><div class="btn btn-danger delete-row" id="delete_' + id + '" title="Delete this location"><span class="glyphicon glyphicon-trash"></span></div></td>';
  row += '</tr>';
  return row
}

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