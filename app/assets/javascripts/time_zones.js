/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

$(function() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii"});
  $("input").on("blur change", updateChart);
  $("select").on("blur", updateChart);
  $(".insert-row").on("click", function() { insertRow($(this)); });
  $(".delete-row").on("click", function() { deleteRow($(this)); });
});

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
  $("#chart").text(JSON.stringify(timeZoneLocations));
}

function insertRow(button) {
  position = getPositionFromID(button.attr('id'));
  console.log("Insert row at position " + position);
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