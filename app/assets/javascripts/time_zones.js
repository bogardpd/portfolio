/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */

var timeZoneList = [["&minus;12:00", -12], ["&minus;11:00", -11], ["&minus;10:00", -10], ["&minus;09:30", -9.5], ["&minus;09:00", -9], ["&minus;08:00", -8], ["&minus;07:00", -7], ["&minus;06:00", -6], ["&minus;05:00", -5], ["&minus;04:00", -4], ["&minus;03:30", -3.5], ["&minus;03:00", -3], ["&minus;02:30", -2.5], ["&minus;02:00", -2], ["&minus;01:00", -1], ["", 0], ["+01:00", 1], ["+01:30", 1.5], ["+02:00", 2], ["+03:00", 3], ["+03:30", 3.5], ["+04:00", 4], ["+04:30", 4.5], ["+05:00", 5], ["+05:30", 5.5], ["+05:45", 5.75], ["+06:00", 6], ["+06:30", 6.5], ["+07:00", 7], ["+08:00", 8], ["+08:30", 8.5], ["+09:00", 9], ["+09:30", 9.5], ["+10:00", 10], ["+10:30", 10.5], ["+11:00", 11], ["+12:00", 12], ["+12:45", 12.75], ["+13:00", 13], ["+13:45", 13.75], ["+14:00", 14]];
var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
var msPerDay = 1000*60*60*24;

var minimumRows = 2;
var fadeSpeed = 300;

var chartConfig = {
  "width":           800, // px
  "height":          450, // px
  "margin":           15, // px
  "label":            30, // px
  "xGutter":          24, // px
  "yGutter":          55, // px
  "xValueLineHeight": 16, // px
  "hoverLineHeight":  15, // px
  "xMinSpacing":      35, // px
  "yMinSpacing":      20, // px
  "titleHeight":      30, // px
  "xBuffer":           1, // minimum days to show beyond data range at left and right of axis
  "yBuffer":           1, // minimum hours to show beyond data range at top and bottom of axis
  "locBlockHeight":   20, // px
  "locMargin":         4, // px
  "hoverWidth":      170, // px
  "hoverHeight":      50, // px
  "locSat":          "50%",
  "locLight":        "40%"
};

var chart = new TimeZoneChart(chartConfig);

function TimeZoneChart(config) {
  this.locations = [],
  this.xLeft = config.margin + config.label + config.yGutter,
  this.xRight = (config.width - config.margin * 2),
  this.xSize = this.xRight - this.xLeft,
  this.yTop = config.margin + config.titleHeight,
  this.yBottom = config.height - config.margin - config.label - config.xGutter,
  this.ySize = this.yBottom - this.yTop,
  
  /**
   * Calculates the chart X axis range, based on the locations hash and
   * the minimum number of days of buffer on either side of the data.
   * @return {array} An array containing the integer minimum and maximum time.
   */
  this.calculateXRange = function() {
    // Calculates the chart X axis range, based on the locations hash and
    // the minimum number of days of buffer on either side of the data.
    var allTimes, xMin, xMax;
    allTimes = this.locations.map(function(e) {
      return e.start;
    }).concat(this.locations.map(function(e) {
      return e.end;
    })).filter(function(e) { // Remove blanks
      return e;
    }).sort(function(a,b){return a - b;});
    if (allTimes.length < 1) {return false;}
    xMin = new Date(allTimes[0] - (msPerDay * config.xBuffer) - (allTimes[0] % msPerDay)).getTime();
    xMax = new Date(allTimes[allTimes.length-1] + (msPerDay * (config.xBuffer + 1)) - (allTimes[allTimes.length-1] % msPerDay)).getTime();
    return [xMin,xMax];
  };
  
  /**
   * Calculates the chart Y axis range, based on the locations hash and
   * the minimum number of hours of buffer on either side of the data.
   * @return {array} An array containing the integer minimum and maximum offset.
   */
  this.calculateYRange = function() {
    var allOffsets, yMin, yMax;
    allOffsets = this.locations.map(function(e) {
      return parseFloat(e.offset);
    }).filter(function(e) { // Remove blanks
      return e !== undefined;
    }).sort(function(a,b){return a - b;});
    if (allOffsets.length < 1) {return false;}
    yMin = Math.floor(allOffsets[0]) - config.yBuffer;
    yMax = Math.ceil(allOffsets[allOffsets.length-1]) + config.yBuffer;
    return [yMin,yMax];
  };
  
  this.drawAxes = function() {
    $("#chart-axes").empty();
    createSVG("line", {
      x1: chart.xLeft,
      y1: chart.yBottom,
      x2: chart.xRight,
      y2: chart.yBottom
    }).addClass("axis").appendTo("#chart-axes");
    createSVG("line", {
      x1: chart.xLeft,
      y1: chart.yTop,
      x2: chart.xLeft,
      y2: chart.yBottom
    }).addClass("axis").appendTo("#chart-axes");
  };
  
  this.drawGrid = function() {
    var i;
    var xPos, xEvery, xLabelDate, xLastMonth, xLastYear, xDays, xThisDate;
    var yPos, yEvery, yLabelPos;
    
    $("#chart-grid").empty();
    $("#chart-axis-text").empty();
    // X axis labels and vertical gridlines:
    if (this.xRange !== false) {
      xEvery = Math.ceil(((this.xRange[1] - this.xRange[0]) / msPerDay) / (this.xSize / config.xMinSpacing)); // Place an x value every `xEvery` gridlines
      xDays = 0; // Number of days since xStart
      for (i = this.xRange[0]; i <= this.xRange[1]; i += msPerDay) {
        xPos = this.xPos(i);
        if (i > this.xRange[0]) {
          createSVG("line", {
            x1: xPos,
            y1: this.yTop,
            x2: xPos,
            y2: this.yBottom
          }).addClass("grid").appendTo("#chart-grid");
        }
        if (xDays % xEvery === 0) {
          xLabelDate = new Date(i);
          xThisDate = xLabelDate.getUTCDate();
          if (xLastMonth !== xLabelDate.getUTCMonth()) {xThisDate += " " + monthNames[xLabelDate.getUTCMonth()];}
          createSVG("text", {
            x: xPos,
            y: this.yBottom + config.xValueLineHeight
          }).text(xThisDate).addClass("axis-value axis-value-x").appendTo("#chart-axis-text");
          if (xLastYear !== xLabelDate.getUTCFullYear()) {
            createSVG("text", {
              x: xPos,
              y: this.yBottom + (config.xValueLineHeight * 2)
            }).text(xLabelDate.getUTCFullYear()).addClass("axis-value axis-value-x").appendTo("#chart-axis-text");
          }
          xLastMonth = xLabelDate.getUTCMonth();
          xLastYear = xLabelDate.getUTCFullYear();
        }
        xDays++;
      }
      createSVG("text", {
        x: this.xLeft + (this.xSize / 2),
        y: config.height - config.margin
      }).text("UTC Date").addClass("axis-label").appendTo("#chart-axis-text");
    }
    
    // Y Axis labels and horizontal gridlines:
    if (this.yRange !== false) {
      yEvery = Math.ceil((this.yRange[1] - this.yRange[0]) / (this.ySize / config.yMinSpacing)); // Place a y value every `yEvery` gridlines
      for (i = this.yRange[0] + 1; i <= this.yRange[1]; i += 1) {
        yPos = this.yPos(i);
        createSVG("line", {
          x1: this.xLeft,
          y1: yPos,
          x2: this.xRight,
          y2: yPos
        }).addClass("grid").appendTo("#chart-grid");
        if (i !== this.yRange[1] && i % yEvery === 0) {
          createSVG("text", {
            x: this.xLeft - config.yGutter,
            y: yPos + 5
            }).html(formatUTCOffset(i)).addClass("axis-value axis-value-y").appendTo("#chart-axis-text");
        }
      }
      yLabelPos = [config.margin + config.label - 15, this.yTop + (this.ySize / 2)];
      createSVG("text", {
        x: yLabelPos[0],
        y: yLabelPos[1],
        transform: "rotate(270 " + yLabelPos[0] + " " + yLabelPos[1] + ")"
      }).text("UTC Offset (Hours)").addClass("axis-label").appendTo("#chart-axis-text");
    }
  };
  
  this.drawLocationBlocks = function() {
    var startTime, endTime, hue;
    var locHues = this.generateLocationHues();
    
    $("#chart-location-blocks").empty();
    $("#chart-location-text").empty();
    $("#chart-location-hovers").empty();
    
    this.locations.map(function(location, index) {
      startTime = (index === 0) ? this.xRange[0] : location.start;
      endTime = (index === this.locations.length - 1) ? this.xRange[1] : location.end;
      if (startTime && endTime) {
        hue = Object.keys(locHues).includes(location.location) ? locHues[location.location] : false;
        this.drawLocationBox(startTime, endTime, location.offset, hue);
        this.drawLocationLabel(startTime, endTime, location.offset, location.location, index);
        this.drawLocationHover(startTime, endTime, location.offset, location.location, index);
      }
    }, this);
    
  };
  
  /**
   * Draws a box on the chart representing a given location.
   * @param {number} startTime - UTC arrival time.
   * @param {number} endTime - UTC departure time.
   * @param {number} offset - The location's UTC offset in hours.
   * @param {number} hue - The integer hue to use for this location, or `false` for gray.
   */
  this.drawLocationBox = function(startTime, endTime, offset, hue) {
    var locFill = (hue !== false) ? "hsl(" + hue + ", " + config.locSat + ", " + config.locLight + ")" : "hsl(0, 0%, " + config.locLight + ")";
    createSVG("rect", {
      x: this.xPos(startTime),
      y: this.yPos(offset) - (config.locBlockHeight / 2),
      width: this.xPos(endTime) - this.xPos(startTime),
      height: config.locBlockHeight
    }).addClass("location-block").attr("fill", locFill).appendTo("#chart-location-blocks");
  };
  
  /**
   * Draws a supplemental info box for a location.
   * @param {number} startTime - UTC arrival time.
   * @param {number} endTime - UTC departure time.
   * @param {number} offset - The location's UTC offset in hours.
   * @param {string} locName - The location's name.
   * @param {number} index - An index number used to create unique IDs.
   */
  this.drawLocationHover = function(startTime, endTime, offset, locName, index) {
    var x, y, xCenter, timeText, $hoverGroup;
    
    xCenter = ((this.xPos(startTime) + this.xPos(endTime))/2);
    x = xCenter - (config.hoverWidth / 2);
    if (x < this.xLeft) {
      // Hover is off left edge of chart area
      x = this.xLeft;
      xCenter = this.xLeft + config.hoverWidth/2;
    } else if (x > this.xRight - config.hoverWidth) {
      // Hover is off right edge of chart area
      x = this.xRight - config.hoverWidth;
      xCenter = this.xRight - config.hoverWidth/2;
    }
    if (this.yPos(offset) < (this.yTop + this.yBottom)/2) {
      // Bar is in top half of chart, so place hover beneath
      y = this.yPos(offset) + (config.locBlockHeight/2) + config.locMargin;
    } else {
      // Bar is in bottom half of chart, so place hover above
      y = this.yPos(offset) - (config.locBlockHeight/2) - config.locMargin - config.hoverHeight;
    }
    if (startTime === this.xRange[0]) {
      timeText = formatTimeRange(null, endTime);
    } else if (endTime === this.xRange[1]) {
      timeText = formatTimeRange(startTime, null);
    } else {
      timeText = formatTimeRange(startTime, endTime);
    }
    
    $hoverGroup = createSVG("g", {
      id: "hover-" + index
    });
    createSVG("rect", {
      x: x,
      y: y,
      width: config.hoverWidth,
      height: config.hoverHeight
    }).addClass("supplemental").appendTo($hoverGroup);
    createSVG("text", {
      x: xCenter,
      y: y + config.hoverLineHeight
    }).text(locName).addClass("supplemental-location").appendTo($hoverGroup);
    createSVG("text", {
      x: xCenter,
      y: y + (config.hoverLineHeight * 2)
    }).html(formatUTCOffset(offset)).addClass("supplemental-offset").appendTo($hoverGroup);
    createSVG("text", {
      x: xCenter,
      y: y + (config.hoverLineHeight * 3)
    }).html(timeText).addClass("supplemental-time").appendTo($hoverGroup);
    $hoverGroup.appendTo("#chart-location-hovers");
  };
  
  /**
   * Draws a text label on the chart for a given location.
   * @param {number} startTime - UTC arrival time.
   * @param {number} endTime - UTC departure time.
   * @param {number} offset - The location's UTC offset in hours.
   * @param {string} locName - The location's name.
   * @param {number} index - An index number used to create unique IDs.
   */
  this.drawLocationLabel = function(startTime, endTime, offset, locName, index) {
    var x1, x2, y;
    x1 = this.xPos(startTime);
    x2 = this.xPos(endTime);
    y = this.yPos(offset);
    var locationValue, locationTextPath, locationText;
    if (x2 - x1 > 2 * config.locMargin) {
      createSVG("path", {
        id: "path-" + index,
        d: "M " + (x1 + config.locMargin) + " " + (y + (config.locBlockHeight * 0.25)) + " H " + (x2 - config.locMargin)
      }).appendTo("#chart-location-text");
    
      locationValue = document.createTextNode(locName);
      locationTextPath = document.createElementNS("http://www.w3.org/2000/svg","textPath");
      locationTextPath.setAttributeNS("http://www.w3.org/1999/xlink", "xlink:href", "#path-" + index);
      locationTextPath.appendChild(locationValue);
      locationText = document.createElementNS("http://www.w3.org/2000/svg","text");
      locationText.setAttribute("class", "location");
      locationText.appendChild(locationTextPath);
      document.getElementById("chart-location-text").appendChild(locationText);
    }
  };
  
  this.drawTravelLines = function() {
    var i, time1, offset1, time2, offset2;
    $("#chart-travel-lines").empty();
    for (i = 0; i < (this.locations.length-1); i++) {
      time1 = this.locations[i].end;
      offset1 = this.locations[i].offset;
      time2 = this.locations[i+1].start;
      offset2 = this.locations[i+1].offset;
      if (!(Number.isNaN(time1) || Number.isNaN(offset1) || Number.isNaN(time2) || Number.isNaN(offset2))) {
        createSVG("line", {
          x1: this.xPos(time1),
          y1: this.yPos(offset1),
          x2: this.xPos(time2),
          y2: this.yPos(offset2)
        }).addClass("travel").appendTo("#chart-travel-lines");
      }
    }
  };
  
  this.getFieldValues = function() {
    var i, $row;
    var $locationRows = $("tr.row-location");
    this.locations = [];
    for(i = 0; i < $locationRows.length; i++) {
      $row = $locationRows.eq(i);
      this.locations[i] = {
        start:    Date.parse($row.find(".field-start").val() + "Z"),
        location: $row.find(".field-location").val(),
        offset:   parseFloat($row.find(".field-offset").val()),
        end:      Date.parse($row.find(".field-end").val() + "Z")
      };
    }
    this.xRange = this.calculateXRange();
    this.yRange = this.calculateYRange();
    updateShareLink();
  };
  
  this.generateLocationHues = function() {
    var locHues = {};
    var uniqLocations;
    this.locations.map(function(e) {
      return e.location;
    }).filter(function(e) {
      return e !== "";
    }).map(function(e) {
      locHues[e] = true;
    });
    uniqLocations = Object.keys(locHues).sort();
    uniqLocations.map(function(e, index) {
      locHues[e] = Math.round(360 * (index/uniqLocations.length));
    });
    return locHues;
  };
  
  this.update = function() {
    this.getFieldValues();
    $("#chart").attr("width", config.width).attr("height", config.height);
    this.drawAxes();
    if (this.xRange === false || this.yRange === false) {return;}
    this.drawGrid();
    this.drawLocationBlocks();
    this.drawTravelLines();
  };
  
  // Take an integer timestamp and return the x position on the chart
  this.xPos = function(timestamp) {
    if (this.xRange !== false) {
      return ((timestamp - this.xRange[0]) / (this.xRange[1] - this.xRange[0])) * this.xSize + this.xLeft;
    }
  };
  
  // Take a float offset and return the y position on the chart
  this.yPos = function(offset) {
    if (this.yRange !== false) {
      return this.yBottom - ((offset - this.yRange[0]) / (this.yRange[1] - this.yRange[0])) * (this.ySize);
    }
  };
  
}

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
  html += timeZoneList.reverse().map(function(element) {
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

// Create an SVG element of type `type` with attributes specified in the `attr`
// hash, and return it as a jQuery object.
function createSVG(type, attr) {
  return $(document.createElementNS("http://www.w3.org/2000/svg",type)).attr(attr);
}


/* TABLE MANIPULATION FUNCTIONS */

function populateTable(timeZoneLocations) {
  timeZoneLocations.map(function(element, index) {
    var $row = $(".row-location").eq(index);
    $row.find(".field-start").val(element.start > 0 ? formatDate(new Date(element.start)) : "");
    $row.find(".field-location").val(element.location);
    $row.find(".field-offset").val(element.offset);
    $row.find(".field-end").val(element.end > 0 ? formatDate(new Date(element.end)) : "");
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

/* STRING FUNCTIONS */

function formatUTCOffset(offset) {
  offset = parseInt(offset, 10);
  var output = "UTC";
  if (offset !== 0) {
    output += (offset < 0) ? "&minus;" : "+";
    output += Math.abs(offset);
  }
  return output;
}

function formatDate(date) {
  var str;
  str = date.getUTCFullYear() + "-";
  str += ("0" + (date.getUTCMonth() + 1)).slice(-2) + "-";
  str += ("0" + date.getUTCDate()).slice(-2) + " ";
  str += ("0" + date.getUTCHours()).slice(-2) + ":";
  str += ("0" + date.getUTCMinutes()).slice(-2);
  return str;
}

function formatTimeRange(startTime, endTime) {
  var range, output, str;
  output = "";
  if (startTime === null) {
    range = [new Date(endTime)];
    output += "Depart ";
  } else if (endTime === null) {
    range = [new Date(startTime)];
    output += "Arrive ";
  } else {
    range = [new Date(startTime), new Date(endTime)];
  }
  output += range.map(function(e) {
    str = e.getUTCDate() + " ";
    str += monthNames[e.getUTCMonth()] + " ";
    str += ("0" + e.getUTCHours()).slice(-2) + ":";
    str += ("0" + e.getUTCMinutes()).slice(-2);
    return str;
  }).join(" &ndash; ");
  output += " (UTC)";
  return output;
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
  }
  chart.update();
  $(".hidden-by-default").show();
  setEventTriggers();
});
