class ElectronicsTimeline

  CONFIG_FILE = "app/data/electronics/timeline_config.yml"
  STYLES_FILE = "app/data/electronics/timeline.style_tag.css"

  # Accepts a CategorizedPartCollection, and initializes an ElectronicsTimeline.
  # 
  # @param cat_part_collection [CategorizedPartCollection] the categorized
  #   parts to draw a timeline for.
  def initialize(cat_part_collection)
    @groupings = cat_part_collection.groupings
    @parts = cat_part_collection.parts
    @date_range = cat_part_collection.date_range
    @today = Date.today
        
    calculate_initial_settings
  end
 
  # Creates XML for a timeline SVG graphic.
  def svg_xml
    return "" unless @parts.any?
    calculate_settings
    output = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      svg_options = {
        xmlns: "http://www.w3.org/2000/svg",
        viewBox: "0 0 #{@settings[:canvas][:width]} #{@settings[:canvas][:height]}"
      }
      xml.svg(**svg_options) do
        append_defs(xml)
        append_styles(xml)
        
        canvas_attr = {
          id: "canvas",
          width: @settings[:canvas][:width],
          height: @settings[:canvas][:height]
        }
        xml.rect(**canvas_attr)
        
        cursor_y = @settings[:canvas][:padding][:v]

        draw_legend(xml, cursor_y)
        cursor_y += @settings[:legend][:height]
        
        @groupings.each do |category|
          if @groupings.size > 1
            draw_category_heading(xml, cursor_y, category)
            cursor_y += @settings[:category][:height]  
          end
          draw_timeline_block(xml, cursor_y, category[:items])
          cursor_y += timeline_block_height(category[:items]) + @settings[:timeline_block][:margin][:b]
        end

      end
    end
    return output.to_xml
  end

  # Draw a timeline to the provided SVG file.
  def export_timeline(output_file)
    File.write(output_file, svg_xml)
    puts "Saved timeline to #{output_file}"
  end

  private

  # Adds an SVG <defs> tag to the XML document.
  def append_defs(xml)
    xml.defs do
      %w(used-other-computer used-other-computer-current).each do |pattern|
        pattern_attr = {
          id: pattern,
          width: 4,
          height: 4,
          patternTransform: "rotate(45 0 0)",
          patternUnits: "userSpaceOnUse"
        }
        xml.pattern(**pattern_attr) do
          line_attr = {
            x1: 2,
            y1: 0,
            x2: 2,
            y2: 4,
            class: pattern
          }
          xml.line(**line_attr)
        end
      end
    end
  end

  # Adds an SVG <style> tag to the XML document.
  def append_styles(xml)
    styles = File.open(STYLES_FILE, "r", textmode: true) {|io| io.read}   
    xml.style do
      xml.text(styles)
    end
  end

  def calculate_canvas_height
    height = Hash.new
    height[:margin] = 2 * @settings[:canvas][:padding][:v]
    height[:legend] = @settings[:legend][:height]
    height[:timeline_blocks] = @groupings.map{|c| timeline_block_height(c[:items])}.sum

    if @groupings.size > 1
      category_count = @groupings.size
      height[:category_headings] = category_count * @settings[:category][:height]
      height[:timeline_margins] = (category_count - 1) * @settings[:timeline_block][:margin][:b]
    end

    @settings[:canvas][:height] = height.values.sum
  end

  # Calculates unchanging timeline elements from initial settings.
  def calculate_initial_settings
    @settings = YAML.load_file(CONFIG_FILE).deep_symbolize_keys
    @settings[:chart] = {
      x_anchor: @settings[:canvas][:padding][:h],
      anchor_y: @settings[:canvas][:padding][:v],
      width: @settings[:canvas][:width] - (2 * @settings[:canvas][:padding][:h])
    }
    @settings[:bar][:row_height] = @settings[:bar][:height] + 2 * @settings[:bar][:margin][:v]
    @settings[:bar][:max_width] = @settings[:chart][:width] - 2 * @settings[:bar][:margin][:h]
    @settings[:bar][:min_x] = @settings[:chart][:x_anchor] + @settings[:bar][:margin][:h]
    @settings[:bar][:max_x] = @settings[:bar][:min_x] + @settings[:bar][:max_width]
  end

  # Updates settings based on chart data.
  def calculate_settings
    calculate_canvas_height

    # Calculate y-positions of chart elements:
    @settings[:legend][:top] = @settings[:canvas][:padding][:v]

    @settings[:date_range] = {
      min: Date.new(@date_range.begin.year),
      max: Date.new(end_date(@date_range.end).year,-1,-1)
    }

    day_count = @settings[:date_range][:max] - @settings[:date_range][:min]
    @settings[:date_range][:duration] = day_count.to_i

    year_range = (@settings[:date_range][:min].year..@settings[:date_range][:max].year)
    @settings[:date_range][:years] = year_range.map{|y| [y, date_x_pos(Date.new(y))]}.to_h
  end

  # Returns a short name for an item.
  def chart_label(item)
    if item[:model].present?
      if item[:name].present?
        return "#{item[:name]} (#{item[:model]})"
      else
        return item[:model]
      end
    else
      return item[:name]
    end
  end

  def draw_category_heading(xml, anchor_y, category)
    if category[:category]
      category_name = category[:category]
    else
      category_name = "Uncategorized"
    end
    text_attr = {
      x: @settings[:bar][:min_x] + @settings[:category][:padding][:l],
      y: anchor_y + @settings[:category][:height] - @settings[:category][:padding][:b],
      class: "category"
    }
    xml.text_(**text_attr) {xml.text(category_name)}
  end

  def draw_legend(xml, top_y)
    legend = @settings[:legend]
    used_classes = @groupings.map{|category|
      category[:items].map{|part|
        part[:uses].map{|dates, use_attr| use_period_class(dates, use_attr)}
      }
    }.flatten.uniq
        
    labels = {
      "owned" => {text: "Owned", width: 65},
      "used" => {text: "In Use", width: 60},
      "used-current" => {text: "Currently In Use", width: 115},
      "used-other-computer" => {text: "Used in Other Computer", width: 165},
      "used-other-computer-current" => {text: "Currently Used in Other Computer", width: 220}
    }
    labels = labels.select{|k,v| ["owned", *used_classes].include?(k)}
    labels_width = legend[:box][:size] * labels.size + labels.inject(0){|s,(k,v)| s + v[:width]}
    
    xml.g(id: "legend") do
      bottom_y = top_y + legend[:height]

      box_x = @settings[:canvas][:width] - @settings[:canvas][:padding][:h] - labels_width
      box_y = bottom_y - legend[:box][:margin][:b] - legend[:box][:size]
      text_y = bottom_y - legend[:text][:margin][:b]
      labels.each do |css_class, label|
        text_x = box_x + legend[:box][:size] + legend[:text][:margin][:h]
        box_attr = {
          x: box_x,
          y: box_y,
          width: legend[:box][:size],
          height: legend[:box][:size],
          class: css_class
        }
        xml.rect(**box_attr)
        text_attr = {
          x: text_x,
          y: text_y,
          class: "legend"
        }
        xml.text_(**text_attr) {xml.text(label[:text])}
        box_x += legend[:box][:size] + label[:width]
      end
    end
  end

  def draw_part(xml, anchor_y, index, part)
    y = anchor_y + (index * @settings[:bar][:row_height]) + @settings[:bar][:margin][:v]
    left_x = date_x_pos(part[:owned].begin)
    right_x = date_x_pos(disposal_date(part))
    width = right_x - left_x
    label = chart_label(part)
    
    # Draw owned timelines.
    rect_owned_attr = {
      id: "#{part[:id]}-owned",
      x: left_x,
      y: y,
      width: width,
      height: @settings[:bar][:height],
      class: "owned"
    }
    xml.rect(**rect_owned_attr)

    # Draw used timelines.
    use_periods = part[:uses]
    if use_periods.any?
      use_periods.each_with_index do |(dates, use_attr), use_index|
        use_x = date_x_pos(dates.begin)
        use_width = (date_x_pos(end_date(dates.end)) - use_x)
        use_class = use_period_class(dates, use_attr)
        rect_use_attr = {
          id: "#{part[:id]}-use-#{use_index}",
          x: use_x,
          y: y,
          width: use_width,
          height: @settings[:bar][:height],
          class: use_class
        }
        xml.rect(**rect_use_attr)
      end
    end

    # Draw labels.
    text_class = ["part-bar"]
    if width / @settings[:bar][:max_width] >= 0.40
      # Place text on the bar
      text_x = left_x + @settings[:bar][:padding][:h]
      text_anchor = "start"
      text_class.push("part-bar-over")
    elsif (left_x - @settings[:bar][:min_x]) > (@settings[:bar][:max_x] - right_x)
      # Place text to the left of the bar
      text_x = left_x - @settings[:bar][:padding][:h]
      text_anchor = "end"
      text_class.push("part-bar-side")
    else
      # Place text to the right of the bar
      text_x = right_x + @settings[:bar][:padding][:h]
      text_anchor = "start"
      text_class.push("part-bar-side")
    end
    label_attr = {
      id: "#{part[:id]}-label",
      x: text_x,
      y: y + @settings[:bar][:height] - @settings[:bar][:padding][:b],
      class: text_class.join(" "),
      "text-anchor": text_anchor
    }
    xml.text_(**label_attr) {xml.text(label)}

    # Draw invisible rectangles over owned for allowing tooltip hovers.
    rect_tooltip_zone_attr = {
      **(rect_owned_attr.slice(:x, :y, :width, :height)),
      id: "#{part[:id]}-tooltip-zone",
      class: "tooltip-zone",
      "data-tippy-template": CategorizedPartCollection.tooltip_id(part[:id])
    }
    xml.rect(**rect_tooltip_zone_attr)
    
  end

  # Draws timelines for a collection of parts.
  def draw_timeline_block(xml, anchor_y, parts)
    draw_year_gridlines(xml, anchor_y, timeline_block_height(parts))

    anchor_y += @settings[:year][:height]
    parts.sort_by!{|p| [p[:owned].begin, disposal_date(p), p[:model]]}
    parts.each_with_index do |part, index|
      xml.g(id: "#{part[:id]}-timelines") do
        draw_part(xml, anchor_y, index, part)
      end
    end
  end

  # Draws a vertical gridline and axis label for each year
  def draw_year_gridlines(xml, anchor_y, height)
    top_y = anchor_y
    bottom_y = anchor_y + height
    line_y_attr = {
      y1: top_y,
      y2: bottom_y,
      class: "gridline"
    }
    xml.g(id: "year-gridlines") do
      @settings[:date_range][:years].each do |year, x|
        next_x = @settings[:date_range][:years][year+1] || @settings[:bar][:max_x]
        xml.line(x1: x, x2: x, **line_y_attr)
        year_attr = {
          x: (x + next_x)/2,
          y: top_y + @settings[:year][:height] - @settings[:year][:padding][:b],
          class: "year"
        }
        xml.text_(**year_attr) {xml.text(year)}
          
      end
      xml.line(x1: @settings[:bar][:max_x], x2: @settings[:bar][:max_x], **line_y_attr)
    end
  end

  # Given a date between the min and max dates, calculates an x position.
  def date_x_pos(date)
    range_fraction = (date - @settings[:date_range][:min]).to_f / @settings[:date_range][:duration]
    return @settings[:bar][:min_x] + range_fraction * @settings[:bar][:max_width]
  end

  # Returns the disposal date of a part. Returns today's date if nil.
  def disposal_date(part)
    return end_date(part[:owned].end)
  end

  # Takes a date or nil. Returns the provided date, or returns today's date if nil.
  def end_date(date)
    return date || @today
  end

  # Determine if a parts association is filtered by a single computer (all parts
  # have exactly one Computer in common amongst all their use periods) and
  # return that computer if so. Returns nil otherwise.
  def find_common_computer(parts_association)
    common_computers = parts_association.map{|p| p.part_use_periods.map(&:computer)}.inject(:&)
    if common_computers.size == 1
      return common_computers.first
    else
      return nil
    end
  end

  def timeline_block_height(parts)
    return @settings[:year][:height] + parts.size * @settings[:bar][:row_height] + @settings[:timeline_block][:padding][:b]
  end

  # Determines which class of timeline bar to use, based on whether the part is 
  # current and whether it's used in another computer.
  def use_period_class(date_range, use_attr)
    use_class = "used"
    if use_attr[:other_computer]
      use_class += "-other-computer"
    end
    if date_range.end.nil?
      use_class += "-current"
    end
    return use_class
  end

end