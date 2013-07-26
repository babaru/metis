#encoding: utf-8

class SpotDataFile < UploadFile
  attr_accessible :website_id

  def website_id
    meta_data[:website_id]
  end

  def website_id=(val)
    meta_data[:website_id] = val
  end

  def parse(website_id)
    result = []
    Spreadsheet.open self.data_file.path do |book|
      sheet = book.worksheet(0)
      current_spot_category = nil
      1.upto(sheet.last_row_index) do |index|
        Rails.logger.debug "ROW: #{index}"
        type_id = sheet.row(index)[0].upcase
        case type_id
        when 'SC'
          current_spot_category = parse_spot_category(sheet.row(index), website_id)
          result << current_spot_category
        else
          if current_spot_category.nil?
            Rails.logger.error "First row is not SC!"
            return
          end
          current_spot_category[:spots] << parse_spot(sheet.row(index), website_id)
        end
      end
    end
    result
  end

  private

  def parse_spot(data, website_id)
    channel_name = data[0].strip
    spot_name = data[1].strip
    price = data[2].to_i
    unit = data[3].upcase
    specs_text = data[4].upcase if data[4]
    remark = data[5]

    spot_specs = {}
    spot_specs[:specs] = []
    if specs_text
      specs_text = specs_text.gsub(/[;；]/, ';').strip
      spec_blocks = specs_text.split('|')
      spec_blocks.each do |spec_block|
        spot_data = {}
        specs = spec_block.split(';')
        spot_data[:dimension] = specs[0]
        spot_data[:size] = specs[1] if specs.length > 1
        spot_data[:types] = specs[2].split('.') if specs.length > 2
        spot_data[:remark] = specs[3] if specs.length > 3
        spot_specs[:specs] << spot_data
      end
    end

    return {
        website_id: website_id,
        channel_name: channel_name,
        name: spot_name,
        price: price,
        unit: unit,
        spec: spot_specs
      }
  end

  def parse_spot_category(data, website_id)
    name = data[1]
    description = data[2]
    return {
      name: name,
      description: description,
      website_id: website_id,
      spots: []
    }
  end
end
