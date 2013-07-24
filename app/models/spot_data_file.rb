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
      1.upto(sheet.last_row_index) do |index|

        channel_name = sheet.row(index)[0]
        spot_name = sheet.row(index)[1]
        price = sheet.row(index)[2]
        unit = sheet.row(index)[3]
        specs_text = sheet.row(index)[4]
        remark = sheet.row(index)[5]

        channel = Channel.where(name: channel_name, website_id: website_id).first
        if channel.nil?
          Rails.logger.error "Can not find channel named #{channel_name}"
          channel = Channel.create!(name: channel_name, website_id: website_id)
        end

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

        result << {
            website_id: website_id,
            channel_id: channel.id,
            name: spot_name,
            price: price,
            unit: unit,
            spec: spot_specs
            }
      end
    end
    result
  end
end
