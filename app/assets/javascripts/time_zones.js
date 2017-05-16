/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

var timeZoneList = [["&minus;12:00", -12], ["&minus;11:00", -11], ["&minus;10:00", -10], ["&minus;09:30", -9.5], ["&minus;09:00", -9], ["&minus;08:00", -8], ["&minus;07:00", -7], ["&minus;06:00", -6], ["&minus;05:00", -5], ["&minus;04:00", -4], ["&minus;03:30", -3.5], ["&minus;03:00", -3], ["&minus;02:30", -2.5], ["&minus;02:00", -2], ["&minus;01:00", -1], ["", 0], ["+01:00", 1], ["+01:30", 1.5], ["+02:00", 2], ["+03:00", 3], ["+03:30", 3.5], ["+04:00", 4], ["+04:30", 4.5], ["+05:00", 5], ["+05:30", 5.5], ["+05:45", 5.75], ["+06:00", 6], ["+06:30", 6.5], ["+07:00", 7], ["+08:00", 8], ["+08:30", 8.5], ["+09:00", 9], ["+09:30", 9.5], ["+10:00", 10], ["+10:30", 10.5], ["+11:00", 11], ["+12:00", 12], ["+12:45", 12.75], ["+13:00", 13], ["+13:45", 13.75], ["+14:00", 14]];
var msPerDay = 1000*60*60*24;

var minimumRows = 2;
var fadeSpeed = 300;

var chartConfig = {
  "width":      800, // px
  "height":     450, // px
  "margin":      15, // px
  "xGutter":     30, // px
  "yGutter":     30, // px
  "titleHeight": 30, // px
  "xBuffer":      1, // minimum days to show beyond data range at left and right of axis
  "yBuffer":      1  // minimum hours to show beyond data range at top and bottom of axis
};

var chart = new TimeZoneChart(chartConfig);

function TimeZoneChart(config) {
  this.locations = [],
  this.xLeft = config.margin + config.yGutter,
  this.xRight = config.width - config.margin,
  this.xSize = this.xRight - this.xLeft,
  this.yTop = config.margin + config.titleHeight,
  this.yBottom = config.height - config.margin - config.xGutter,
  this.ySize = this.yBottom - this.yTop,
  
  this.calculateXRange = function() {
    // Calculates the chart X axis range, based on the locations hash and
    // the minimum number of days of buffer on either side of the data.
    var allTimes, xMin, xMax;
    allTimes = this.locations.map(function(e) {
      return Date.parse(e.start + "Z");
    }).concat(this.locations.map(function(e) {
      return Date.parse(e.end + "Z");
    })).filter(function(e) { // Remove blanks
      return e;
    }).sort(function(a,b){return a - b});
    if (allTimes.length < 2) {return false;}
    xMin = new Date(allTimes[0] - (msPerDay * config.xBuffer) - (allTimes[0] % msPerDay));
    xMax = new Date(allTimes[allTimes.length-1] + (msPerDay * (config.xBuffer + 1)) - (allTimes[allTimes.length-1] % msPerDay));
    return [xMin,xMax];
  };
  
  this.calculateYRange = function() {
    // Calculates the Y axis range, based on the locations hash and the
    // minimum number of hours of buffer on either side of the data.
    var allOffsets, yMin, yMax;
    allOffsets = this.locations.map(function(e) {
      return parseFloat(e.offset);
    }).filter(function(e) { // Remove blanks
      return e;
    }).sort(function(a,b){return a - b});
    if (allOffsets.length < 1) {return false;}
    yMin = Math.floor(allOffsets[0]) - config.yBuffer;
    yMax = Math.ceil(allOffsets[allOffsets.length-1]) + config.yBuffer;
    return [yMin,yMax];
  }
  
  this.drawAxes = function() {
    $(document.createElementNS('http://www.w3.org/2000/svg','line')).attr({
      x1: chart.xLeft,
      y1: chart.yBottom,
      x2: chart.xRight,
      y2: chart.yBottom
    }).addClass("axis").appendTo("#chart");
    $(document.createElementNS('http://www.w3.org/2000/svg','line')).attr({
      x1: chart.xLeft,
      y1: chart.yTop,
      x2: chart.xLeft,
      y2: chart.yBottom
    }).addClass("axis").appendTo("#chart-axes");
  };
    
  this.drawBase = function() {
    $("#chart-grid").empty();
    $("#chart-axes").empty();
    $("#chart").attr("width", config.width).attr("height", config.height);
    this.drawAxes();
  };
  
  this.drawGrid = function() {
    var i;
    var xStart, xEnd, xPos;
    var yStart, yEnd, yPos;
    
    // Vertical gridlines:
    if (this.xRange !== false) {
      xStart = this.xRange[0].getTime();
      xEnd = this.xRange[1].getTime();
          
      for (i = xStart; i <= xEnd; i += msPerDay) {
        xPos = ((i - xStart) / (xEnd - xStart)) * (this.xSize) + this.xLeft;
        $(document.createElementNS('http://www.w3.org/2000/svg','line')).attr({
          x1: xPos,
          y1: this.yTop,
          x2: xPos,
          y2: this.yBottom
        }).addClass("grid").appendTo("#chart-grid");
      }
    }
    
    // Horizontal gridlines:
    if (this.yRange !== false) {
      yStart = this.yRange[0];
      yEnd = this.yRange[1];
    
      for (i = yStart; i <= yEnd; i += 1) {
        yPos = ((i - yStart) / (yEnd - yStart)) * (this.ySize) + this.yTop;
        $(document.createElementNS('http://www.w3.org/2000/svg','line')).attr({
          x1: this.xLeft,
          y1: yPos,
          x2: this.xRight,
          y2: yPos
        }).addClass("grid").appendTo("#chart-grid");
      }
    }
  };
  
  this.getFieldValues = function() {
    var i, $row;
    var $locationRows = $("tr.row-location");
    for(i = 0; i < $locationRows.length; i++) {
      $row = $locationRows.eq(i);
      this.locations[i] = {
        start:    $row.find(".field-start").val(),
        location: $row.find(".field-location").val(),
        offset:   parseFloat($row.find(".field-offset").val()),
        end:      $row.find(".field-end").val()
      };
    }
    this.xRange = this.calculateXRange();
    this.yRange = this.calculateYRange();
    //this.locations.map(function(element) {console.log("Locations: " + JSON.stringify(element));});
  };
  
  this.update = function() {
    console.log("update");
    this.getFieldValues();
    this.drawBase();
    this.drawGrid();
    
    //console.log("X range: " + chartXRange[0].toUTCString() + " to " + chartXRange[1].toUTCString());
    updateShareLink();
  };
  
}

/* CALCULATION FUNCTIONS */


/* FUNCTIONS TO UPDATE PAGE */

function updateDeleteButtons() {
  if ($(".row-location").length <= minimumRows) {
    // Disable delete buttons
    $(".button-delete").off().addClass("disabled");
  } else {
    // Enable delete buttons
    $(".button-delete").off().on("click", function() { deleteRow($(this)); }).removeClass("disabled");
  }
}

function updateShareLink() {
  var data = encodeURIComponent(JSON.stringify(chart.locations));
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
  chart.update();
}

function deleteRow(button) {
  var position = parseInt($(".button-delete").index(button),10);
  var $delRow = $(".row-location").eq(position);
  $delRow.fadeOut(fadeSpeed, function() {
    $(this).remove();
    removeFirstStartLastEnd();
    updateDeleteButtons();
    chart.update();
  });
}

function removeFirstStartLastEnd() {
  $(".row-location").first().find(".cell-start").empty();
  $(".row-location").last().find(".cell-end").empty();
}

/* FUNCTIONS TO MANAGE EVENT TRIGGERS */

function setEventTriggers() {
  $(".dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii", pickerPosition: "top-left"});
  $("input, select").off().on("change", function() {chart.update();} );
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
    //console.log(chart.xLeft);
    chart.update();
  }
  $(".hidden-by-default").show();
  setEventTriggers();
});
