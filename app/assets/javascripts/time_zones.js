/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

var timeZoneList = [["&minus;12:00", -12], ["&minus;11:00", -11], ["&minus;10:00", -10], ["&minus;09:30", -9.5], ["&minus;09:00", -9], ["&minus;08:00", -8], ["&minus;07:00", -7], ["&minus;06:00", -6], ["&minus;05:00", -5], ["&minus;04:00", -4], ["&minus;03:30", -3.5], ["&minus;03:00", -3], ["&minus;02:30", -2.5], ["&minus;02:00", -2], ["&minus;01:00", -1], ["", 0], ["+01:00", 1], ["+01:30", 1.5], ["+02:00", 2], ["+03:00", 3], ["+03:30", 3.5], ["+04:00", 4], ["+04:30", 4.5], ["+05:00", 5], ["+05:30", 5.5], ["+05:45", 5.75], ["+06:00", 6], ["+06:30", 6.5], ["+07:00", 7], ["+08:00", 8], ["+08:30", 8.5], ["+09:00", 9], ["+09:30", 9.5], ["+10:00", 10], ["+10:30", 10.5], ["+11:00", 11], ["+12:00", 12], ["+12:45", 12.75], ["+13:00", 13], ["+13:45", 13.75], ["+14:00", 14]];
var minimumRows = 2;
var fadeSpeed = 300;
var chartWidth = 800;
var chartHeight = 450;
var chartXAxisBuffer = 1; // Minimum number of full days to show beyond data range at left and right of axis
var chartYAxisBuffer = 1; // Minimum number of full hours to show beyond data range at top and bottom of axis
var msPerDay = 1000*60*60*24;

/* CALCULATION FUNCTIONS */

function calculateXRange(timeZoneLocations, buffer) {
  // Calculates the chart X axis range, based on the timeZoneLocations hash and
  // the minimum number of days of buffer on either side of the data.
  var allTimes, xMax, xMin;
  allTimes = timeZoneLocations.map(function(e) {
    return Date.parse(e.start + "Z");
  }).concat(timeZoneLocations.map(function(e) {
    return Date.parse(e.end + "Z");
  })).filter(function(e) {
    return e;
  }).sort();
  if (allTimes.length < 2) {return false;}
  xMin = new Date(allTimes[0] - (msPerDay * buffer) - (allTimes[0] % msPerDay));
  xMax = new Date(allTimes[allTimes.length-1] + (msPerDay * (buffer + 1)) - (allTimes[allTimes.length-1] % msPerDay));
  return [xMin,xMax];
}

/* FUNCTIONS TO UPDATE PAGE AND CHART ELEMENTS */

function updateChart() {
  var chartXRange, i, $row;
  var timeZoneLocations = [];
  var $locationRows = $("tr.row-location");
  for(i = 0; i < $locationRows.length; i++) {
    $row = $locationRows.eq(i);
    timeZoneLocations[i] = {
      start:    $row.find(".field-start").val(),
      location: $row.find(".field-location").val(),
      offset:   parseFloat($row.find(".field-offset").val()),
      end:      $row.find(".field-end").val()
    };
  }
  chartXRange = calculateXRange(timeZoneLocations, chartXAxisBuffer);
    
  
  console.log(timeZoneLocations.map(function(element, index) {
    return index + ": " + JSON.stringify(element);
  }).join("\n"));
  console.log("X range: " + chartXRange[0].toUTCString() + " to " + chartXRange[1].toUTCString());
  updateShareLink(timeZoneLocations);
}

function updateDeleteButtons() {
  if ($(".row-location").length <= minimumRows) {
    // Disable delete buttons
    $(".button-delete").off().addClass("disabled");
  } else {
    // Enable delete buttons
    $(".button-delete").off().on("click", function() { deleteRow($(this)); }).removeClass("disabled");
  }
}

function updateShareLink(timeZoneLocations) {
  var data = encodeURIComponent(JSON.stringify(timeZoneLocations));
  //window.history.replaceState({},"",[location.protocol, '//', location.host, location.pathname, "?data=", data].join(''));
  $("#share-link").attr("href", [location.protocol,"//",location.host,location.pathname,"?data=",data].join(""));
}

/* HTML CREATION FUNCTIONS */

function createInsertButton() {
  return '<div class="btn btn-success button-insert" title="Add a location before this one"><span class="glyphicon glyphicon-plus"></span></div>';
}

function createDateTime(fieldName) {
  var html = '<div class="form-group"><div class="input-group date dtpicker">';
  html += '<input type="text" class="form-control field-' + fieldName + '" />';
  html += '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>';
  html += '</div></div>';
  return html;
}

function createOffsetSelect() {
  var html = '<div class="form-group"><select class="form-control field-offset">';
  html += timeZoneList.map(function(element) {
    return '<option value="' + element[1] + '"' + (element[1] === 0 ? ' selected' : '') +'>UTC' + element[0] + '</option>';
  }).join("\n");
  html += '</select></div>';
  return html;
}

function createTableRows(numberOfRows) {
  var $tableBody = $("tbody");
  for (var i = 0; i < numberOfRows; i++) {
    $tableBody.append(createRow());
  }
  $tableBody.append('<tr><td>' + createInsertButton() + '</td><td colspan="5"></td></tr>');
  removeFirstStartLastEnd();
}

function createRow() {
  var row = '<tr class="row-location">';
  row += '<td class="cell-insert">' + createInsertButton() + '</td>';
  row += '<td class="cell-start">' + createDateTime("start") + '</td>';
  row += '<td class="cell-location"><div class="form-group"><input type="text" class="form-control field-location" /></div></td>';
  row += '<td class="cell-offset">' + createOffsetSelect() + '</td>';
  row += '<td class="cell-end">' + createDateTime("end") + '</td>';
  row += '<td class="cell-delete"><div class="btn btn-danger button-delete" title="Delete this location"><span class="glyphicon glyphicon-trash"></span></div></td>';
  row += '</tr>';
  return row;
}

/* TABLE MANIPULATION FUNCTIONS */

function populateTable(timeZoneLocations) {
  timeZoneLocations.map(function(element, index) {
    var $row = $(".row-location").eq(index);
    $row.find(".field-start").val(element.start);
    $row.find(".field-location").val(element.location);
    $row.find(".field-offset").val(element.offset);
    $row.find(".field-end").val(element.end);
  }).join("<br/>");
}

function insertRow(button) {
  var $oldRow, $newRow;
  var position = parseInt($(".button-insert").index(button),10);
  if (position < $(".row-location").length) {
    $oldRow = $(".row-location").eq(position);
    $oldRow.before(createRow());
    $newRow = $(".row-location").eq(position);
    $newRow.hide();
    if (position === 0) {
      $oldRow.find(".cell-start").append(createDateTime("start"));
      $newRow.find(".form-group").first().remove();
    }
    $newRow.find(".field-offset").val($oldRow.find(".field-offset").val());
    $newRow.fadeIn(fadeSpeed);
  } else {
    $oldRow = $(".row-location").last();
    $oldRow.find(".cell-end").append(createDateTime("end"));
    $oldRow.after(createRow());
    $newRow = $(".row-location").last();
    $newRow.hide();
    $newRow.find(".form-group").last().remove();
    $newRow.find(".field-offset").val($oldRow.find(".field-offset").val());
    $newRow.fadeIn(fadeSpeed);
  }
  setEventTriggers();
  updateChart();
}

function deleteRow(button) {
  var position = parseInt($(".button-delete").index(button),10);
  var $delRow = $(".row-location").eq(position);
  $delRow.fadeOut(fadeSpeed, function() {
    $(this).remove();
    removeFirstStartLastEnd();
    updateDeleteButtons();
    updateChart();
  });
}

function removeFirstStartLastEnd() {
  $(".row-location").first().find(".cell-start").empty();
  $(".row-location").last().find(".cell-end").empty();
}

/* FUNCTIONS TO MANAGE EVENT TRIGGERS */

function setEventTriggers() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii", pickerPosition: "top-left"});
  $("input, select").off().on("blur change", updateChart);
  $(".button-insert").off().on("click", function() { insertRow($(this)); });
  updateDeleteButtons();
}

/* RUN ON PAGE LOAD */

$(function() {
  var data = location.search.split("data=")[1];
  $("#js-warning").remove();
  if (data === undefined) {
    createTableRows(3);
  } else {
    data = JSON.parse(decodeURIComponent(data));
    createTableRows(data.length);
    populateTable(data);
    updateChart();
  }
  $(".hidden-by-default").show();
  setEventTriggers();
  $("#chart").attr("width", chartWidth).attr("height", chartHeight);
  
});
