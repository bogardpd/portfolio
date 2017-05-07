/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

$(function() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii"});
  $("input").on("blur change", updateChart);
  $("select").on("blur", updateChart);
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