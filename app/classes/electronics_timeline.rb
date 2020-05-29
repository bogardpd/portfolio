class ElectronicsTimeline

  CONFIG_FILE = "app/data/electronics/timeline_config.yml"

  def initialize(parts_association)
    @parts = Array(parts_association.includes(:part_use_periods))
    @today = Date.today
    calculate_initial_settings
  end
 
  # Creates XML for a timeline SVG graphic.
  def svg_xml
    return nil unless @parts.any?
    calculate_settings
    output = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.svg(
        xmlns: "http://www.w3.org/2000/svg",
        width: @settings[:canvas][:width],
        height: @settings[:canvas][:height]
      ) do
        xml.rect(id: "background", **@settings[:canvas])
        draw_timeline_block(xml, @parts, @settings[:chart][:anchor_y])
      end
    end
    return output.to_xml.html_safe
  end

  # Draw a timeline to the provided SVG file.
  def draw_timeline(output_file)
    File.write(output_file, svg_xml)
    puts "Saved timeline to #{output_file} (parts count: #{@parts.size})"
  end

  private

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
    @settings[:canvas][:height] = (2 * @settings[:canvas][:padding][:v]) + ((@parts.size + 1) * @settings[:bar][:row_height])
    @settings[:date_range] = {
      min: Date.new(@parts.min_by{|p| p.purchase_date}.purchase_date.year),
      max: Date.new(disposal_date(@parts.max_by{|p| disposal_date(p)}).year,-1,-1)
    }
    @settings[:date_range][:duration] = (@settings[:date_range][:max] - @settings[:date_range][:min]).to_i
    @settings[:date_range][:years] = (@settings[:date_range][:min].year..@settings[:date_range][:max].year).map{|y| [y, date_x_pos(Date.new(y))]}.to_h
  end

  def draw_part(xml, part, anchor_y, index)
    y = anchor_y + ((index + 1) * @settings[:bar][:row_height]) + @settings[:bar][:margin][:v]
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
      fill: @settings[:bar][:fill][:owned],
      stroke: @settings[:bar][:stroke],
      "stroke-width": @settings[:bar][:stroke_width]
    )

    # Draw used timelines.
    use_periods = part.part_use_periods
    if use_periods.any?
      use_periods.each_with_index do |use, use_index|
        use_x = date_x_pos(use.start_date)
        use_width = (date_x_pos(end_date(use.end_date)) - use_x)
        if @computer_key && @computer_key != use[:computer]
          use_fill = @settings[:bar][:fill][:used_other_computer]
        elsif use.end_date.nil?
          use_fill = @settings[:bar][:fill][:used_current]
        else
          use_fill = @settings[:bar][:fill][:used]
        end
        xml.rect(
          id: "part-#{index}-use-#{use_index}",
          x: use_x,
          y: y,
          width: use_width,
          height: @settings[:bar][:height],
          fill: use_fill
        )
      end
    end

    # Draw labels.
    if width / @settings[:bar][:max_width] >= 0.40
      # Place text on the bar
      text_x = left_x + @settings[:bar][:text][:margin][:h]
      text_anchor = "start"
      text_fill = @settings[:bar][:text][:fill][:over]
    elsif (left_x - @settings[:bar][:min_x]) > (@settings[:bar][:max_x] - right_x)
      # Place text to the left of the bar
      text_x = left_x - @settings[:bar][:text][:margin][:h]
      text_anchor = "end"
      text_fill = @settings[:bar][:text][:fill_side]
    else
      # Place text to the right of the bar
      text_x = right_x + @settings[:bar][:text][:margin][:h]
      text_anchor = "start"
      text_fill = @settings[:bar][:text][:fill][:side]
    end
    label = part[:name] ? "#{part[:name]} (#{part[:model]})" : part[:model]
    xml.text_(
      id: "part-#{index}-label",
      x: text_x,
      y: y + @settings[:bar][:height] - @settings[:bar][:text][:margin][:b],
      fill: text_fill,
      "font-size": @settings[:bar][:text][:font_size],
      "font-family": @settings[:font],
      "text-anchor": text_anchor
    ) do
      xml.text(label)
    end
  end

  # Draws timelines for a collection of parts.
  def draw_timeline_block(xml, parts, anchor_y)
    parts.sort_by!{|p| [p.purchase_date, disposal_date(p), p.model]}
    draw_years(xml, parts, anchor_y)
    parts.each_with_index do |part, index|
      xml.g(id: "part-#{index}-timelines") do
        draw_part(xml, part, anchor_y, index)
      end
    end
  end

  # Draws a vertical gridline and axis label for each year
  def draw_years(xml, parts, anchor_y)
    bottom_y = anchor_y + (parts.size + 1) * @settings[:bar][:row_height]
    xml.g do
      @settings[:date_range][:years].each do |year, x|
        next_x = @settings[:date_range][:years][year+1] || @settings[:bar][:max_x]
        xml.line(
          x1: x,
          y1: anchor_y,
          x2: x,
          y2: bottom_y,
          stroke: @settings[:year][:stroke]
        )
        xml.text_(
          x: (x + next_x)/2,
          y: anchor_y + @settings[:bar][:height] - @settings[:bar][:text][:margin][:b],
          fill: @settings[:year][:label][:fill],
          "font-size": @settings[:year][:label][:font_size],
          "font-family": @settings[:font],
          "text-anchor": "middle"
        ) do
          xml.text(year)
        end
      end
      xml.line(
        x1: @settings[:bar][:max_x],
        y1: anchor_y,
        x2: @settings[:bar][:max_x],
        y2: bottom_y,
        stroke: @settings[:year][:stroke]
      )
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

end