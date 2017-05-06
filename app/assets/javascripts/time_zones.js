var rowCount;

$(function() {
  $(".datetimepicker").datetimepicker({format: "YYYY-MM-DD HH:mm"});
  rowCount = $("tr.location-row").length;

  $("input").on("blur", updateChart);
  $("select").on("blur", updateChart);
});

function updateChart() {
  var timeZoneLocations = [];
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