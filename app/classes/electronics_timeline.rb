class ElectronicsTimeline

  CONFIG_FILE = "app/data/electronics/timeline_config.yml"
  STYLES_FILE = "app/data/electronics/timeline.style_tag.css"

  # Accepts an ActiveRecord CollectionProxy of Parts, or hash of Part arrays
  # grouped by PartCategories, and initializes an ElectronicsTimeline.
  # 
  # @param parts_association [Part::ActiveRecord_Associations_CollectionProxy]
  #   a collection of Parts
  # @param grouped_categories [Hash] a hash with keys of PartCategories and
  #   values of Arrays of Parts
  # @param category_order [Array] an array of PartCategory slug strings
  #   specifying the order in which to sort the categories. PartCategories not
  #   in the array will be placed after the specified category and sorted
  #   alphabetically by name. If sort_order is not provided, all categories
  #   will be sorted alphabetically by name. Only used with a parts_association.
  def initialize(parts_association: nil, grouped_categories: nil, category_order: nil)
    return nil unless parts_association || grouped_categories
    if parts_association
      parts_association = parts_association.includes(:part_use_periods)
      @parts = Array(parts_association)
      if category_order
        @parts_by_category = parts_association.group_by_category(sort_order: category_order)
      else
        @parts_by_category = {nil: @parts}
      end
    elsif grouped_categories
      @parts = grouped_categories.values.flatten.uniq
      @parts_by_category = grouped_categories
    end
    @today = Date.today
    calculate_initial_settings
  end
 
  # Creates XML for a timeline SVG graphic.
  def svg_xml
    return nil unless @parts.any?
    calculate_settings
    output = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      svg_options = {
        xmlns: "http://www.w3.org/2000/svg",
        width: @settings[:canvas][:width],
        height: @settings[:canvas][:height]
      }
      xml.svg(**svg_options) do
        append_styles(xml)

        canvas_attr = {
          id: "canvas",
          width: @settings[:canvas][:width],
          height: @settings[:canvas][:height]
        }
        xml.rect(**canvas_attr)

        anchor_y = @settings[:canvas][:padding][:v]
        @parts_by_category.each do |category, parts|
          if @parts_by_category.size > 1
            draw_category_heading(xml, anchor_y, category)
            anchor_y += @settings[:category][:height]  
          end
          draw_timeline_block(xml, anchor_y, parts)
          anchor_y += timeline_block_height(parts) + @settings[:timeline_block][:margin][:b]
        end
      end
    end
    return output.to_xml.html_safe
  end

  # Draw a timeline to the provided SVG file.
  def export_timeline(output_file)
    File.write(output_file, svg_xml)
    puts "Saved timeline to #{output_file}"
  end

  private

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
    height[:timeline_blocks] = @parts_by_category.map{|c,p| timeline_block_height(p)}.sum

    if @parts_by_category.size > 1
      category_count = @parts_by_category.keys.size
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

    @settings[:date_range] = {
      min: Date.new(@parts.min_by{|p| p.purchase_date}.purchase_date.year),
      max: Date.new(disposal_date(@parts.max_by{|p| disposal_date(p)}).year,-1,-1)
    }

    day_count = @settings[:date_range][:max] - @settings[:date_range][:min]
    @settings[:date_range][:duration] = day_count.to_i

    year_range = (@settings[:date_range][:min].year..@settings[:date_range][:max].year)
    @settings[:date_range][:years] = year_range.map{|y| [y, date_x_pos(Date.new(y))]}.to_h
  end

  def draw_category_heading(xml, anchor_y, category)
    if category && category.name
      category_name = category.name
    else
      category_name = "Uncategorized"
    end
    text_attrs = {
      x: @settings[:bar][:min_x] + @settings[:category][:padding][:l],
      y: anchor_y + @settings[:category][:height] - @settings[:category][:padding][:b],
      class: "category"
    }
    xml.text_(**text_attrs) {xml.text(category_name)}
  end

  def draw_part(xml, anchor_y, index, part)
    y = anchor_y + (index * @settings[:bar][:row_height]) + @settings[:bar][:margin][:v]
    left_x = date_x_pos(part[:purchase_date])
    right_x = date_x_pos(disposal_date(part))
    width = right_x - left_x

    # Draw owned timelines.
    xml.rect(
      id: "part-#{index}-owned",
      x: left_x,
      y: y,
      width: width,
      height: @settings[:bar][:height],
      class: "owned"
    )

    # Draw used timelines.
    use_periods = part.part_use_periods
    if use_periods.any?
      use_periods.each_with_index do |use, use_index|
        use_x = date_x_pos(use.start_date)
        use_width = (date_x_pos(end_date(use.end_date)) - use_x)
        if @computer_key && @computer_key != use[:computer]
          use_class = "used-other-computer"
        elsif use.end_date.nil?
          use_class = "used-current"
        else
          use_class = "used"
        end
        xml.rect(
          id: "part-#{index}-use-#{use_index}",
          x: use_x,
          y: y,
          width: use_width,
          height: @settings[:bar][:height],
          class: use_class
        )
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
    label = part[:name] ? "#{part[:name]} (#{part[:model]})" : part[:model]
    label_attr = {
      id: "part-#{index}-label",
      x: text_x,
      y: y + @settings[:bar][:height] - @settings[:bar][:padding][:b],
      class: text_class.join(" "),
      "text-anchor": text_anchor
    }
    xml.text_(**label_attr) {xml.text(label)}
  end

  # Draws timelines for a collection of parts.
  def draw_timeline_block(xml, anchor_y, parts)
    draw_year_gridlines(xml, anchor_y, timeline_block_height(parts))

    anchor_y += @settings[:year][:height]
    parts.sort_by!{|p| [p.purchase_date, disposal_date(p), p.model]}
    parts.each_with_index do |part, index|
      xml.g(id: "part-#{index}-timelines") do
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
    xml.g do
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
    return end_date(part[:disposal_date])
  end

  # Takes a date or nil. Returns the provided date, or returns today's date if nil.
  def end_date(date)
    return date || @today
  end

  def timeline_block_height(parts)
    return @settings[:year][:height] + parts.size * @settings[:bar][:row_height] + @settings[:timeline_block][:padding][:b]
  end

end