/* Uses "DateTime Picker for Bootstrap" from http://www.malot.fr/bootstrap-datetimepicker/index.php under the Apache License v2.0 http://www.apache.org/licenses/LICENSE-2.0 */
/* Uses moment.js */
/* Uses jQuery */

var timeZoneList = [["&minus;12:00", -12], ["&minus;11:00", -11], ["&minus;10:00", -10], ["&minus;09:30", -9.5], ["&minus;09:00", -9], ["&minus;08:00", -8], ["&minus;07:00", -7], ["&minus;06:00", -6], ["&minus;05:00", -5], ["&minus;04:00", -4], ["&minus;03:30", -3.5], ["&minus;03:00", -3], ["&minus;02:30", -2.5], ["&minus;02:00", -2], ["&minus;01:00", -1], ["", 0], ["+01:00", 1], ["+01:30", 1.5], ["+02:00", 2], ["+03:00", 3], ["+03:30", 3.5], ["+04:00", 4], ["+04:30", 4.5], ["+05:00", 5], ["+05:30", 5.5], ["+05:45", 5.75], ["+06:00", 6], ["+06:30", 6.5], ["+07:00", 7], ["+08:00", 8], ["+08:30", 8.5], ["+09:00", 9], ["+09:30", 9.5], ["+10:00", 10], ["+10:30", 10.5], ["+11:00", 11], ["+12:00", 12], ["+12:45", 12.75], ["+13:00", 13], ["+13:45", 13.75], ["+14:00", 14]].reverse();
var msPerDay = 1000*60*60*24;
var msPerHour = 1000*60*60;
var msPerMinute = 1000*60;

var minimumRows = 2;
var fadeSpeed = 300;

var chartConfig = {
  "width":           960, // px (default width)
  "height":          540, // px (default height)
  "title":            50, // px height
  "margin":           15, // px
  "label":            30, // px
  "xGutter":          24, // px
  "yGutter":          55, // px
  "xValueLineHeight": 16, // px
  "hoverLineHeight":  15, // px
  "xMinSpacing":      35, // px
  "yMinSpacing":      20, // px
  "xBuffer":           1, // minimum days to show beyond data range at left and right of axis
  "yBuffer":           1, // minimum hours to show beyond data range at top and bottom of axis
  "locBlockHeight":   20, // px
  "locMargin":         4, // px
  "hoverWidth":      190, // px
  "hoverHeight":      50, // px
  "locSat":          "50%",
  "locLight":        "40%"
};

var chart = new TimeZoneChart(chartConfig);

/**
 * Defines a Time Zone Chart object.
 * @param {Object} config - A hash of configuration parameters
 */
function TimeZoneChart(config) {
  this.locations = [],
  this.title = "",
  this.xLeft = 0,
  this.xRight = 0,
  this.xSize = 0,
  this.yTop = 0,
  this.yBottom = 0,
  this.ySize = 0,
  this.width = config.width,
  this.height = config.height,
  
  /**
   * Sets the primary reference positions of the chart.
   */
  this.calculatePositions = function() {
    this.xLeft = config.margin + config.label + config.yGutter;
    this.xRight = (this.width - config.margin * 2);
    this.xSize = this.xRight - this.xLeft;
    this.yTop = config.margin + config.title;
    this.yBottom = this.height - config.margin - config.label - config.xGutter;
    this.ySize = this.yBottom - this.yTop;
  };
  
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
    xMin = allTimes[0] - (msPerDay * config.xBuffer) - (allTimes[0] % msPerDay);
    xMax = allTimes[allTimes.length-1] + (msPerDay * (config.xBuffer + 1)) - (allTimes[allTimes.length-1] % msPerDay);
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
  
  /**
   * Draws the chart axes.
   */
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
  
  /**
   * Draws the chart grid and axis labels.
   */
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
          xLabelDate = moment(i);
          if (xLastMonth !== xLabelDate.utc().format("M")) {
            xThisDate = xLabelDate.utc().format("MMM D");
          } else {
            xThisDate = xLabelDate.utc().format("D");
          }
          createSVG("text", {
            x: xPos,
            y: this.yBottom + config.xValueLineHeight
          }).text(xThisDate).addClass("axis-value axis-value-x").appendTo("#chart-axis-text");
          if (xLastYear !== xLabelDate.utc().format("Y")) {
            createSVG("text", {
              x: xPos,
              y: this.yBottom + (config.xValueLineHeight * 2)
            }).text(xLabelDate.utc().format("Y")).addClass("axis-value axis-value-x").appendTo("#chart-axis-text");
          }
          xLastMonth = xLabelDate.utc().format("M");
          xLastYear = xLabelDate.utc().format("Y");
        }
        xDays++;
      }
      createSVG("text", {
        x: this.xLeft + (this.xSize / 2),
        y: this.height - config.margin
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
  
  /**
   * Draws a location box and its associated hover.
   */
  this.drawLocationBlocks = function() {
    var startTime, endTime, hue;
    var locHues = this.generateLocationHues();
    
    $("#chart-location-blocks").empty();
    $("#chart-location-hovers").empty();
    
    this.locations.map(function(location, index) {
      startTime = (index === 0) ? this.xRange[0] : location.start;
      endTime = (index === this.locations.length - 1) ? this.xRange[1] : location.end;
      if (startTime && endTime) {
        hue = Object.keys(locHues).includes(location.location) ? locHues[location.location] : false;
        this.drawLocationBox(startTime, endTime, location.offset, location.location, hue, index);
        this.drawLocationHover(startTime, endTime, location.offset, location.location);
      }
    }, this);
    
  };
  
  /**
   * Draws a box on the chart representing a given location.
   * @param {number} startTime - UTC arrival time.
   * @param {number} endTime - UTC departure time.
   * @param {number} offset - The location's UTC offset in hours.
   * @param {string} locName - The location's name.
   * @param {number} hue - The integer hue to use for this location, or `false` for gray.
   * @param {number} index - An index number used to create unique IDs.
   */
  this.drawLocationBox = function(startTime, endTime, offset, locName, hue, index) {
    var x1, x2, y, locFill, locValue, locTextPath, locText;
    var $hoverGroup;
    
    x1 = this.xPos(startTime);
    x2 = this.xPos(endTime);
    y = this.yPos(offset);
    locFill = (hue !== false) ? "hsl(" + hue + ", " + config.locSat + ", " + config.locLight + ")" : "hsl(0, 0%, " + config.locLight + ")";
    
    $hoverGroup = createSVG("g", {}).addClass("location-block");
    
    if (startTime > endTime) {
      createSVG("rect", {}).addClass("location-block").hide().appendTo($hoverGroup);
    } else {
      createSVG("rect", {
        x: x1,
        y: y - (config.locBlockHeight / 2),
        width: x2 - x1,
        height: config.locBlockHeight
      }).addClass("location-block").attr("fill", locFill).appendTo($hoverGroup);
    }
    
    if (locName && x2 - x1 > 2 * config.locMargin) {
      createSVG("path", {
        id: "path-" + index,
        d: "M " + (x1 + config.locMargin) + " " + (y + (config.locBlockHeight * 0.25)) + " H " + (x2 - config.locMargin)
      }).appendTo($hoverGroup);
    
      locValue = document.createTextNode(locName);
      locTextPath = document.createElementNS("http://www.w3.org/2000/svg","textPath");
      locTextPath.setAttributeNS("http://www.w3.org/1999/xlink", "xlink:href", "#path-" + index);
      locTextPath.appendChild(locValue);
      locText = document.createElementNS("http://www.w3.org/2000/svg","text");
      locText.setAttribute("class", "location");
      locText.appendChild(locTextPath);
      $hoverGroup.append(locText);
    }
    
    $hoverGroup.appendTo("#chart-location-blocks");
  };
  
  /**
   * Draws a supplemental info box for a location.
   * @param {number} startTime - UTC arrival time.
   * @param {number} endTime - UTC departure time.
   * @param {number} offset - The location's UTC offset in hours.
   * @param {string} locName - The location's name.
   * @param {number} index - An index number used to create unique IDs.
   */
  this.drawLocationHover = function(startTime, endTime, offset, locName) {
    var x, y, xCenter, timeTextLocal, timeTextUTC, hoverHeight, $hoverGroup;
    
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
      timeTextLocal = formatTimeRange(null, endTime, offset);
      timeTextUTC = formatTimeRange(null, endTime, 0);
    } else if (endTime === this.xRange[1]) {
      timeTextLocal = formatTimeRange(startTime, null, offset);
      timeTextUTC = formatTimeRange(startTime, null, 0);
    } else {
      timeTextLocal = formatTimeRange(startTime, endTime, offset);
      timeTextUTC = formatTimeRange(startTime, endTime, 0);
    }
    
    $hoverGroup = createSVG("g", {}).addClass("supplemental");
    hoverHeight = (offset === 0) ? config.hoverHeight - config.hoverLineHeight : config.hoverHeight;
    createSVG("rect", {
      x: x,
      y: y,
      width: config.hoverWidth,
      height: hoverHeight
    }).addClass("supplemental").appendTo($hoverGroup);
    if (locName) {
      createSVG("text", {
        x: xCenter,
        y: y + config.hoverLineHeight
      }).text(locName).addClass("supplemental-location").appendTo($hoverGroup);
    }
    createSVG("text", {
      x: xCenter,
      y: y + (config.hoverLineHeight * 2)
    }).html(timeTextLocal).addClass("supplemental-time-local").appendTo($hoverGroup);
    if (offset !== 0) {
      createSVG("text", {
        x: xCenter,
        y: y + (config.hoverLineHeight * 3)
      }).html(timeTextUTC).addClass("supplemental-time-utc").appendTo($hoverGroup);
    }
    $hoverGroup.hide().appendTo("#chart-location-hovers");
  };
  
  /**
   * Draws the title.
   * @param {string} titleText
   */
  this.drawTitle = function(titleText) {
    $("#chart-title").empty();
    createSVG("text", {
      x: this.width / 2,
      y: this.yTop - config.margin
    }).text(titleText).addClass("title").appendTo("#chart-title");
  };
  
  /**
   * Draws lines between the location boxes.
   */
  this.drawTravelLines = function() {
    var i, time1, offset1, time2, offset2, xSplit;
    var chartDistance = [];
    $("#chart-travel-lines").empty();
    for (i = 0; i < (this.locations.length-1); i++) {
      time1 = this.locations[i].end;
      offset1 = this.locations[i].offset;
      time2 = this.locations[i+1].start;
      offset2 = this.locations[i+1].offset;
      if (time1 && time2 && (offset1 || offset1 === 0) && (offset2 || offset2 === 0)) {
        if (offset2 - offset1 > 12) {
          // Travel goes off bottom of chart
          chartDistance[0] = (offset1 - this.yRange[0]); // Bottom
          chartDistance[1] = (this.yRange[1] - offset2); // Top
          xSplit = this.xPos(time1) + (this.xPos(time2) - this.xPos(time1)) * chartDistance[0]/(chartDistance[0]+chartDistance[1]);
          createSVG("line", {
            x1: this.xPos(time1),
            y1: this.yPos(offset1),
            x2: xSplit,
            y2: this.yBottom
          }).addClass("travel").appendTo("#chart-travel-lines");
          createSVG("line", {
            x1: xSplit,
            y1: this.yTop,
            x2: this.xPos(time2),
            y2: this.yPos(offset2)
          }).addClass("travel").appendTo("#chart-travel-lines");
          createSVG("line", {
            x1: xSplit,
            y1: this.yBottom,
            x2: xSplit,
            y2: this.yTop
          }).addClass("travel-idl").appendTo("#chart-travel-lines");
        } else if (offset1 - offset2 > 12) {
          // Travel goes off top of chart
          chartDistance[0] = (offset2 - this.yRange[0]); // Bottom
          chartDistance[1] = (this.yRange[1] - offset1); // Top
          xSplit = this.xPos(time1) + (this.xPos(time2) - this.xPos(time1)) * chartDistance[1]/(chartDistance[0]+chartDistance[1]);
          createSVG("line", {
            x1: this.xPos(time1),
            y1: this.yPos(offset1),
            x2: xSplit,
            y2: this.yTop
          }).addClass("travel").appendTo("#chart-travel-lines");
          createSVG("line", {
            x1: xSplit,
            y1: this.yBottom,
            x2: this.xPos(time2),
            y2: this.yPos(offset2)
          }).addClass("travel").appendTo("#chart-travel-lines");
          createSVG("line", {
            x1: xSplit,
            y1: this.yBottom,
            x2: xSplit,
            y2: this.yTop
          }).addClass("travel-idl").appendTo("#chart-travel-lines");
        } else {
          createSVG("line", {
            x1: this.xPos(time1),
            y1: this.yPos(offset1),
            x2: this.xPos(time2),
            y2: this.yPos(offset2)
          }).addClass("travel").appendTo("#chart-travel-lines");
        }
      }
    }
  };
  
  /**
   * Converts the Location array into a string for use in the query string.
   * @return {string}
   */
  this.getLocationString = function() {
    var str;
    return chart.locations.map(function(loc, index) {
      str = [];
      if (index !== 0) {
        str.push(loc.start ? loc.start / msPerMinute : "");
      }
      str.push(loc.location ? encodeStringForQuery(loc.location) : "");
      str.push(loc.offset);
      if (index !== chart.locations.length - 1) {
        str.push(loc.end ? loc.end / msPerMinute : "");
      }
      return str.join(",");
    }).join("/");
  };
  
  /**
   * Creates a hash with location names as the keys and equally spaced hues as
   * the values.
   * @return {Object}
   */
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
  
  /**
   * Converts the form values into a location array and calculates the x and y
   * ranges.
   */
  this.retrieveFieldValues = function() {
    var i, start, end, $row, $locationRows;
    if ($("#field-title").val()) {this.title = $("#field-title").val();}
    $locationRows = $("tr.row-location");
    if ($locationRows.length > 0) {
      this.locations = [];
      for(i = 0; i < $locationRows.length; i++) {
        $row = $locationRows.eq(i);
        start = timeFieldToTimestamp($row.find(".field-start"));
        end = timeFieldToTimestamp($row.find(".field-end"));
        this.locations[i] = {
          start:    start,
          location: $row.find(".field-location").val() || null,
          offset:   parseFloat($row.find(".field-offset").val()),
          end:      end
        };
      }
    }
    this.xRange = this.calculateXRange();
    this.yRange = this.calculateYRange();
  };
  
  /**
   * Refreshes the chart.
   */
  this.update = function() {
    this.calculatePositions();
    this.retrieveFieldValues();
    $("#chart").attr("width", this.width).attr("height", this.height);
    this.drawAxes();
    this.drawTitle(this.title);
    this.drawGrid();
    this.drawLocationBlocks();
    this.drawTravelLines();
    setEventTriggers();
  };
  
  /**
   * Updates the size of the chart.
   * @param {number} width
   * @param {number} height
   */
  this.updateSize = function(width,height) {
    this.width = width;
    this.height = height;
  };
  
  /**
   * Takes an integer timestamp and returns the x position on the chart
   * @return {number}
   */
  this.xPos = function(timestamp) {
    if (this.xRange !== false) {
      return ((timestamp - this.xRange[0]) / (this.xRange[1] - this.xRange[0])) * this.xSize + this.xLeft;
    }
  };
  
  /**
   * Takes a float offset and returns the y position on the chart
   * @return {number}
   */
  this.yPos = function(offset) {
    if (this.yRange !== false) {
      return this.yBottom - ((offset - this.yRange[0]) / (this.yRange[1] - this.yRange[0])) * (this.ySize);
    }
  };
  
}


/* FUNCTIONS TO UPDATE PAGE */

/**
 * Disables the delete row buttons if the location table has the minimum number
 * of rows, and enables them if the table has more than the minimum number of
 * rows.
 */
function updateDeleteButtons() {
  if ($(".row-location").length <= minimumRows) {
    // Disable delete buttons
    $("#component-data .button-delete").off().addClass("disabled");
  } else {
    // Enable delete buttons
    $("#component-data .button-delete").off().on("click", function() { deleteRow($(this)); }).removeClass("disabled");
  }
}

/**
 * Updates the querystring in the window URL and the share link to reflect
 * the chart's values.
 */
function updatePageLinks() {
  var titleStr, title, data, base, link, svgData, $chartElement, file;
  data = chart.getLocationString();
  titleStr = $("#field-title").val();
  title = encodeStringForQuery(titleStr);
  base = [location.protocol,"//",location.host,location.pathname].join("");
  link = [base,"?data=",data,"&title=",title].join("");
  $("#fullscreen-link").removeClass("disabled");
  $("#fullscreen-link").attr("href", link);
  $("#edit-link").attr("href", link + "&edit=true");
  window.history.replaceState({},"",link + "&edit=true");
  
  $chartElement = $("#chart").clone();
  $chartElement.find("#chart-location-hovers").remove();
  svgData = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="chart" width="' + chart.width + '" height="' + chart.height + '">' + $chartElement.html() + '</svg>';
  file = new Blob([svgData], {type: "image/svg+xml"});
  $("#download-link").attr("href", URL.createObjectURL(file)).attr("download", titleStr + ".svg");
}

/**
 * Encodes a string to place in the query string and replaces spaces with `+`
 * @param {string} str - The string to encode
 * @return {string}
 */
function encodeStringForQuery(str) {
  return encodeURIComponent(str).replace(/\%20/g, "+");
}

/**
 * Decodes a string from the query string and replaces `+` with spaces
 * @param {string} str - The string to decode
 * @return {string}
 */
function decodeStringFromQuery(str) {
  return decodeURIComponent(str.replace(/\+/g, "%20"));
}

/**
 * Decodes a data querystring into a locations array
 * @param {string} data
 * @return {Array}
 */
function decodeData(data) {
  var locations, locData;
  locations = data.split("/");
  return locations.map(function(loc, index) {
    locData = loc.split(",");
    if (index === 0) {
      return {
        start: null,
        location: decodeStringFromQuery(locData[0]),
        offset: locData[1],
        end: locData[2] ? locData[2] * msPerMinute : null
      };
    } else if (index === locations.length - 1) {
      return {
        start: locData[0] ? locData[0] * msPerMinute : null,
        location: decodeStringFromQuery(locData[1]),
        offset: locData[2],
        end: null
      };
    } else {
      return {
        start: locData[0] ? locData[0] * msPerMinute : null,
        location: decodeStringFromQuery(locData[1]),
        offset: locData[2],
        end: locData[3] ? locData[3] * msPerMinute : null
      };
    }
  }) || null;
}


/* HTML CREATION FUNCTIONS */

/**
 * Generates the HTML for an Insert Row button.
 * @return {string} - HTML
 */
function createInsertButton() {
  return '<div class="btn btn-success button-insert" title="Add a location before this one">Insert</div>';
}

/**
 * Generates the HTML for a date/time input field and picker.
 * @return {string} - HTML
 */
function createDateTime(fieldName) {
  var html = '<div class="form-group"><div class="input-group date dtpicker">';
  html += '<input type="text" class="form-control field-' + fieldName + '" />';
  html += '<div class="input-group-append"><span class="input-group-text"><span class="custom-icon">&#128197;</span></span></div>';
  html += '</div></div>';
  return html;
}

/**
 * Generates the HTML for a UTC offset select box.
 * @return {string} - HTML
 */
function createOffsetSelect() {
  var html = '<div class="form-group"><select class="form-control field-offset">';
  html += timeZoneList.map(function(element) {
    return '<option value="' + element[1] + '"' + (element[1] === 0 ? ' selected' : '') +'>UTC' + element[0] + '</option>';
  }).join("\n");
  html += '</select></div>';
  return html;
}

/**
 * Generates the HTML for the location table.
 * @param {number} numberOfRows - The number of rows this table should have.
 * @return {string} - HTML
 */
function createTableRows(numberOfRows) {
  var $tableBody = $("tbody");
  for (var i = 0; i < numberOfRows; i++) {
    $tableBody.append(createRow());
  }
  $tableBody.append('<tr><td>' + createInsertButton() + '</td><td colspan="5"></td></tr>');
  removeFirstStartLastEnd();
}

/**
 * Generates the HTML for an individual location table row.
 * @return {string} - HTML
 */
function createRow() {
  var row = '<tr class="row-location">';
  row += '<td class="cell-insert">' + createInsertButton() + '</td>';
  row += '<td class="cell-start">' + createDateTime("start") + '</td>';
  row += '<td class="cell-location"><div class="form-group"><input type="text" class="form-control field-location" /></div></td>';
  row += '<td class="cell-offset">' + createOffsetSelect() + '</td>';
  row += '<td class="cell-end">' + createDateTime("end") + '</td>';
  row += '<td class="cell-delete"><div class="btn btn-danger button-delete" title="Delete this location">Delete</div></td>';
  row += '</tr>';
  return row;
}

/**
 * Create an SVG element.
 * @param {string} type - SVG element to create
 * @param {hash} attr - Hash of attributes to apply to the element
 * @return {jQuery} jQuery object representing the SVG element
 */
function createSVG(type, attr) {
  return $(document.createElementNS("http://www.w3.org/2000/svg",type)).attr(attr);
}


/* TABLE MANIPULATION FUNCTIONS */

/**
 * Fills in the table fields with the location array.
 * @param {Object} timeZoneLocations - The location array.
 */
function populateTable(timeZoneLocations) {
  var dateFormat = "Y-MM-DD HH:mm";
  timeZoneLocations.map(function(element, index) {
    var $row = $(".row-location").eq(index);
    $row.find(".field-start").val(element.start > 0 ? moment(element.start).utc().format(dateFormat) : "");
    $row.find(".field-location").val(element.location);
    $row.find(".field-offset").val(element.offset);
    $row.find(".field-end").val(element.end > 0 ? moment(element.end).utc().format(dateFormat) : "");
  }).join("<br/>");
}

/**
 * Inserts a table row at the location of the clicked Insert Row button.
 * @param {jQuery} $button - The button which was clicked
 */
function insertRow($button) {
  var $oldRow, $newRow;
  var position = parseInt($(".button-insert").index($button),10);
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
  chart.update();
  updateDeleteButtons();
}

/**
 * Deletes the table row at the location of the clicked Delete Row button.
 * @param {jQuery} $button - The button which was clicked
 */
function deleteRow($button) {
  var position = parseInt($(".button-delete").index($button),10);
  var $delRow = $(".row-location").eq(position);
  $delRow.fadeOut(fadeSpeed, function() {
    $(this).remove();
    removeFirstStartLastEnd();
    updateDeleteButtons();
    chart.update();
  });
}

/**
 * Removes the first arrival time field and the last departure time field.
 */
function removeFirstStartLastEnd() {
  $(".row-location").first().find(".cell-start").empty();
  $(".row-location").last().find(".cell-end").empty();
}

/**
 * Checks that all time fields are in order. Highlights any out of order
 * fields and clears highlights for fields in the correct order.
 */
function validateDates() {
  var $allTimes, allTimestamps, i, outOfOrderTimes;
  $allTimes = $("input.field-start, input.field-end");
  outOfOrderTimes = [];
  allTimestamps = $allTimes.map(function() {
    return timeFieldToTimestamp($(this)) || false;
  });
  for (i = 0; i < allTimestamps.length; i++) {
    if (allTimestamps[i] && allTimestamps[i+1] && allTimestamps[i] > allTimestamps[i+1] || allTimestamps[i] && allTimestamps[i-1] && allTimestamps[i] < allTimestamps[i-1]) {
      outOfOrderTimes.push(i);
    }
  }
  $allTimes.parent().removeClass("has-error");
  outOfOrderTimes.map(function(e) {
    $allTimes.eq(e).parent().addClass("has-error");
  });
}


/* STRING FUNCTIONS */

/**
 * Creates a formatted string for UTC offset.
 * @param {number} offset - The UTC offset.
 * @return {string} - A formatted string.
 */
function formatUTCOffset(offset) {
  offset = parseInt(offset, 10);
  var output = "UTC";
  if (offset !== 0) {
    output += (offset < 0) ? "&minus;" : "+";
    output += Math.abs(offset);
  }
  return output;
}

/**
 * Creates a formatted string shwoing a range between two times.
 * @param {number} startTime - A Unix timestamp.
 * @param {number} endTime - A Unix timestamp.
 * @return {string} - A formatted string.
 */
function formatTimeRange(startTime, endTime, offset) {
  var range, output;
  output = "";
  if (startTime === null) {
    range = [endTime + offset*msPerHour];
    output += "Depart ";
  } else if (endTime === null) {
    range = [startTime + offset*msPerHour];
    output += "Arrive ";
  } else {
    range = [startTime + offset*msPerHour, endTime + offset*msPerHour];
  }
  output += range.map(function(e) {
    return moment(e).utc().format("D MMM HH:mm");
  }).join(" &ndash; ");
  output += " (" + formatUTCOffset(offset) + ")";
  return output;
}


/* TIME FUNCTIONS */

/**
 * Converts a time field (assumed UTC) into a timestamp.
 * @param {jQuery} $timeField - The jQuery selector for the time field
 * @return {number} - The unix timestamp
 */
function timeFieldToTimestamp($timeField) {
  if ($timeField.val()) {
    return moment($timeField.val().replace(" ","T") + "Z").valueOf();
  } else {
    return null;
  }
}


/* FUNCTIONS TO MANAGE EVENT TRIGGERS */

/**
 * Clears and sets event triggers.
 */
function setEventTriggers() {  
  var selectedSize;
  $("#component-chart g.location-block").off().on("click", function() {toggleHover($(this));} ).on("mouseenter", function() {showHover($(this));} ).on("mouseleave", function() {hideHover();} );
 
  $("#component-data .dtpicker").datetimepicker({format: "yyyy-mm-dd hh:ii", pickerPosition: "top-left"});
  $("input.field-title, input.field-location, select.field-offset").off().on("change", function() {
    chart.update();
    updatePageLinks();
  });
  $("input.field-start, input.field-end").off().on("change", function() {
    chart.update();
    updatePageLinks();
    validateDates();
  });
  $("#field-size").off().on("change", function() {
    selectedSize = $("#field-size").val().split(",");
    chart.updateSize(selectedSize[0],selectedSize[1]);
    chart.update();
    updatePageLinks();
  });
  
  $("#component-data .button-insert").off().on("click", function() { insertRow($(this)); });
  
  updateDeleteButtons();
}

/**
 * Shows a hover box if it's hidden, or hides it if its visible.
 * @param {jQuery} $locationBox - The location box whose hover should be toggled.
 */
function toggleHover($locationBox) {
  var index = $("g.location-block").index($locationBox);
  if ($("g.supplemental").eq(index).css("display") === "none") {
    // Hidden
    showHover($locationBox);
  } else {
    // Visible
    hideHover();
  }
}

/**
 * Shows a hover box.
 * @param {jQuery} $locationBox - The location box whose hover should be shown.
 */
function showHover($locationBox) {
  var index = $("g.location-block").index($locationBox);
  hideHover(); // Hide all other hovers
  $("#component-chart g.supplemental").eq(index).fadeIn(fadeSpeed).off().on("click", function() {hideHover();} );
}

function hideHover() {
  $("g.supplemental").fadeOut(fadeSpeed);
}

/* RUN ON PAGE LOAD */

$(function() {
  var query, data, title, selectedSize;
  query = {};
  
  if ($("#component-chart").length) {
    location.search.slice(1).split("&").forEach(function(pair) {
      pair = pair.split("=");
      query[pair[0]] = (pair[1] || "");
    });
  
    title = (query.title === undefined) ? "" : decodeStringFromQuery(query.title);
  
    selectedSize = $("#field-size").val().split(",");
    chart.updateSize(selectedSize[0],selectedSize[1]);
    if (query.data === undefined) {
      $("#fullscreen-buttons").hide();
      $("#fullscreen-link").addClass("disabled");
      createTableRows(3);
      $("#field-title").val(title);
    } else {
      if (query.edit === undefined) {
        $("#navbar").appendTo("body");
        $("#component-chart").appendTo("body");
        $(".container").remove();
        $("#edit-buttons").hide();
        $("#edit-link").attr("href", [location.protocol, "//", location.host, location.pathname, "?data=", query.data, "&title=", encodeStringForQuery(title), "&edit=true"].join(""));
      
        chart.locations = decodeData(query.data);
        chart.title = title;
        chart.updateSize($(window).width(),($(window).height()-$("#navbar").height())*0.98);
        $(window).on("resize", function() {
          chart.updateSize($(window).width(),($(window).height()-$("#navbar").height())*0.98);
          chart.update();
        });
      } else {
        $("#fullscreen-buttons").hide();
        data = JSON.parse(JSON.stringify(decodeData(query.data)));
        createTableRows(data.length);
        populateTable(data);
        $("#field-title").val(title);
      }
    }
  
    setEventTriggers();
    chart.update();
    if (query.data !== undefined && query.edit !== undefined) {
      updatePageLinks();
    }
  
    validateDates();
    $("#component-title div.input").hide();
    $("#js-warning").remove();
    $(".hidden-by-default").show();
  }  
  
});
