class ComputerPartsData

  PARTS_DATA_FILE = "app/data/computers/parts.yml"
  INITIAL_SETTINGS = {
    canvas: {
      width: 900,
      fill: "#f4f5f6",
      v_padding: 20,
      h_padding: 20
    },
    bar: {
      height: 25,
      v_margin: 2,
      h_margin: 5,
      fill_owned: "#a5a8af",
      fill_used_other_computer: "#50ac5f",
      fill_used_current: "#00358c",
      fill_used: "#42454a",
      text: {
        b_margin: 7,
        h_margin: 5,
        font_size: "12pt",
        fill_over: "#fbfbfc",
        fill_side: "#42454a"
      }
    },
    font: "Source Sans Pro",
    year: {
      label: {
        fill: "#c1c3c8",
        font_size: "12pt"
      },
      stroke: "#c1c3c8",
      stroke_width: 1
    }
  }

  def initialize(computer: nil, type: nil)
    computer = computer&.underscore
    type = type&.underscore

    @parts_data = YAML.load_file(PARTS_DATA_FILE).with_indifferent_access
    @current_parts = @parts_data[:parts]
    @part_types = @parts_data[:part_types]
    @computers = @parts_data[:computers]
    @today = Date.today
    
    if computer
      @current_parts.select!{|p| p[:use_dates] && p[:use_dates].map{|u| u[:computer]}.include?(computer)}
      @computer = @computers[computer]
      @computer_key = computer
    end
    if type
      @current_parts.select!{|p| p[:part_types] && p[:part_types].include?(type)}
      @part_type = @part_types[type]
    end

    calculate_initial_settings
  end

  # Returns the current parts list.
  def current_parts
    return @current_parts
  end

  # Returns a hash of all computers.
  def all_computers
    return @computers
  end

  # Returns a hash of all part types which have at least one instance not associated with a computer.
  def standalone_types
    standalone_types = @parts_data[:parts]
      .select{|p| p[:use_dates].nil? || p[:use_dates].map{|u| u[:computer]}.include?(nil)}
      .map{|p| p[:part_types]}.flatten.compact.uniq
      .map(&:to_sym)
    return @part_types.slice(*standalone_types).sort_by{|k,t| t[:name]}.to_h
  end

  # Returns true if the provided computer is defined in the data file.
  def computer_exists?(computer)
    return false if computer.nil?
    return @computers[computer.underscore].present?
  end

  # Returns true if the provided type is defined in the data file.
  def type_exists?(type)
    return false if type.nil?
    return @part_types[type.underscore].present?
  end

  # Returns the computer form factor if the collection is filtered by computer.
  def computer_form_factor
    return nil unless @computer
    return @computer[:form_factor]
  end
  
  # Returns the computer model if the collection is filtered by computer.
  def computer_model
    return nil unless @computer
    return @computer[:model]
  end

  # Returns the computer name if the collection is filtered by computer.
  def computer_name
    return nil unless @computer
    return @computer[:name]
  end

  # Returns the type name if the collection is filtered by type.
  def type_name(meta: false)
    return nil unless @part_type
    if meta
      return @part_type[:lowercase_plural] || @part_type[:name].downcase
    else
      return @part_type[:name]
    end
  end

  # Creates XML for a timeline SVG graphic.
  def svg_xml
    return nil unless @current_parts.any?
    calculate_settings
    output = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.svg(
        xmlns: "http://www.w3.org/2000/svg",
        width: @settings[:canvas][:width],
        height: @settings[:canvas][:height]
      ) do
        xml.rect(id: "background", **@settings[:canvas])
        draw_timeline_block(xml, @current_parts, @settings[:chart][:anchor_y])
      end
    end
    return output.to_xml.html_safe
  end

  # Draw a timeline to the provided SVG file.
  def draw_timeline(output_file)
    File.write(output_file, svg_xml)
    puts "Saved timeline to #{output_file} (parts count: #{@current_parts.size})"
  end

  private

  # Calculates unchanging timeline elements from initial settings.
  def calculate_initial_settings
    @settings = INITIAL_SETTINGS
    @settings[:chart] = {
      x_anchor: @settings[:canvas][:h_padding],
      anchor_y: @settings[:canvas][:v_padding],
      width: @settings[:canvas][:width] - (2 * @settings[:canvas][:h_padding])
    }
    @settings[:bar][:row_height] = @settings[:bar][:height] + 2 * @settings[:bar][:v_margin]
    @settings[:bar][:max_width] = @settings[:chart][:width] - 2 * @settings[:bar][:h_margin]
    @settings[:bar][:min_x] = @settings[:chart][:x_anchor] + @settings[:bar][:h_margin]
    @settings[:bar][:max_x] = @settings[:bar][:min_x] + @settings[:bar][:max_width]
  end

  # Updates settings based on chart data.
  def calculate_settings
    @settings[:canvas][:height] = (2 * @settings[:canvas][:v_padding]) + ((@current_parts.size + 1) * @settings[:bar][:row_height])
    @settings[:date_range] = {
      min: Date.new(@current_parts.min_by{|p| p[:purchase_date]}[:purchase_date].year),
      max: Date.new(disposal_date(@current_parts.max_by{|p| disposal_date(p)}).year,-1,-1)
    }
    @settings[:date_range][:duration] = (@settings[:date_range][:max] - @settings[:date_range][:min]).to_i
    @settings[:date_range][:years] = (@settings[:date_range][:min].year..@settings[:date_range][:max].year).map{|y| [y, date_x_pos(Date.new(y))]}.to_h
  end

  # Draws timelines for a collection of parts.
  def draw_timeline_block(xml, parts, anchor_y)
    parts.sort_by!{|p| [p[:purchase_date], disposal_date(p), p[:model]]}

    # Draw years.
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
          y: anchor_y + @settings[:bar][:height] - @settings[:bar][:text][:b_margin],
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

    parts.each_with_index do |part, index|
      xml.g(id: "part-#{index}-timelines") do
        left_x = date_x_pos(part[:purchase_date])
        right_x = date_x_pos(disposal_date(part))
        width = right_x - left_x
        y = anchor_y + ((index + 1) * @settings[:bar][:row_height]) + @settings[:bar][:v_margin]

        # Draw owned timelines.
        xml.rect(
          id: "part-#{index}-owned",
          x: left_x,
          y: y,
          width: width,
          height: @settings[:bar][:height],
          fill: @settings[:bar][:fill_owned],
          stroke: @settings[:bar][:stroke],
          "stroke-width": @settings[:bar][:stroke_width]
        )

        # Draw used timelines.
        if part[:use_dates]
          part[:use_dates].each_with_index do |use, use_index|
            use_x = date_x_pos(use[:start])
            use_width = (date_x_pos(end_date(use[:end])) - use_x)
            if @computer_key && @computer_key != use[:computer]
              use_fill = @settings[:bar][:fill_used_other_computer]
            elsif use[:end].nil?
              use_fill = @settings[:bar][:fill_used_current]
            else
              use_fill = @settings[:bar][:fill_used]
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
          text_x = left_x + @settings[:bar][:text][:h_margin]
          text_anchor = "start"
          text_fill = @settings[:bar][:text][:fill_over]
        elsif (left_x - @settings[:bar][:min_x]) > (@settings[:bar][:max_x] - right_x)
          # Place text to the left of the bar
          text_x = left_x - @settings[:bar][:text][:h_margin]
          text_anchor = "end"
          text_fill = @settings[:bar][:text][:fill_side]
        else
          # Place text to the right of the bar
          text_x = right_x + @settings[:bar][:text][:h_margin]
          text_anchor = "start"
          text_fill = @settings[:bar][:text][:fill_side]
        end
        label = part[:name] ? "#{part[:name]} (#{part[:model]})" : part[:model]
        xml.text_(
          id: "part-#{index}-label",
          x: text_x,
          y: y + @settings[:bar][:height] - @settings[:bar][:text][:b_margin],
          fill: text_fill,
          "font-size": @settings[:bar][:text][:font_size],
          "font-family": @settings[:font],
          "text-anchor": text_anchor
        ) do
          xml.text(label)
        end
      end
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