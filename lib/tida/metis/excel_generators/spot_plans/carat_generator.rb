#encoding: utf-8
module Tida
  module Metis
    module ExcelGenerators
      module SpotPlans
        class CaratGenerator
          LINE_HEIGHT = 17
          FONT_NAME = '微软雅黑'
          FONT_SIZE = 11
          COLUMN_NAMES = [
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
          ]
          COLUMN_NAMES_2 = [
            '', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
          ]

          attr_reader :master_plan_id
          def initialize(master_plan_id)
            @master_plan_id = master_plan_id
          end

          def generate()
            master_plan = MasterPlan.find self.master_plan_id
            ap = ::Axlsx::Package.new

            styles = ap.workbook.styles
            table_header_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom, :right]}
            })
            table_header_first_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:left, :top, :bottom]}
              })
            table_header_last_cell = styles.add_style({
              sz: FONT_SIZE,
              font_name: FONT_NAME,
              b: true,
              alignment: {horizontal: :center, vertical: :center},
              border: {style: :thin, color: "00", edges: [:right, :top, :bottom]}
              })

            ap.workbook.add_worksheet name: master_plan.name do |sheet|
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()
              sheet.add_row()

              table_headers = [
                nil,
                "Media Type\r\n媒体类型",
                "Site\r\n网站",
                "Channel\r\n频道",
                "Position\r\n点位",
                "Material Format\r\n素材尺寸格式",
                "PV Tracking\r\nPV监测",
                "Click Tracking\r\nClick监测",
                "Link to Office Site\r\n可否外链",
                "MR Deadline\r\n素材提交时间",
                "Est. Imp/day\r\n预估曝光/天",
                "Est. Clicks/day\r\n预估点击/天",
                "Est. Total Imp\r\n预估曝光量",
                "Est. Total Clicks\r\n预估点击数",
                "Est. CTR\r\n预估点击率",
                "Est. CPC\r\n预估点击成本",
                "Est. CPM\r\n预估千次曝光成本",
                "Est. Days\r\n投放日数",
                "Est. CPM\r\n量",
                "Leads",
                "Unit Rate Card\r\n单位刊例价",
                "Discount\r\n折扣",
                "Nest Cost\r\n净价",
                "Total Rate Card\r\n总刊例价"
              ]

              table_calendar_days = []
              table_headers.length.times {|n| table_calendar_days << nil}

              calendar_column_index = table_headers.length

              months = master_plan.project.months
              days = master_plan.project.days

              Rails.logger.debug "months: #{months}"
              Rails.logger.debug "days: #{days}"

              month_segs = []
              months.each_with_index do |month, m_index|
                key = "#{month[:year]}#{sprintf('%02d', month[:month])}"
                table_headers << "#{month[:year]}-#{sprintf('%02d', month[:month])}"
                col_count = 0
                days[key].each_with_index do |day, index|
                  if m_index == 0
                    if day > 0
                      table_headers << nil if index + 1 < days[key].length
                      table_calendar_days << (index + 1)
                      col_count += 1 if index + 1 < days[key].length && index > 0
                    end
                  else
                    table_headers << nil if index > 0
                    table_calendar_days << (index + 1)
                    col_count += 1 if day > 0 && index > 0
                  end
                end
                month_segs << col_count
              end

              table_header_styles = [nil, table_header_first_cell, Array.new(table_headers.length - 3, table_header_cell), table_header_last_cell].flatten
              row = sheet.add_row(table_headers, style: table_header_styles)
              row.height = 18

              row = sheet.add_row(table_calendar_days, style: table_header_styles)
              row.height = 40

              Rails.logger.debug month_segs

              0.upto(calendar_column_index - 1) do |n|
                sheet.merge_cells("#{get_column_name(n)}10:#{get_column_name(n)}11")
              end

              month_segs.each do |seg|
                Rails.logger.debug "#{get_column_name(calendar_column_index)}10:#{get_column_name(calendar_column_index + seg)}10"
                sheet.merge_cells("#{get_column_name(calendar_column_index)}10:#{get_column_name(calendar_column_index + seg)}10")
                calendar_column_index = calendar_column_index + seg + 1
              end

              sheet.column_widths(2, 15, 12, 12, 45, 16, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
            end

            root_folder = File.join Rails.root, 'tmp/spot_plans'
            FileUtils.mkdir_p root_folder unless File.exist?(root_folder)
            result_file = File.join root_folder, "#{master_plan.client.name} #{master_plan.project.name} #{master_plan.name} #{Time.now.strftime('%Y%m%d')} #{Time.now.strftime('%H%M%S')}.xlsx"
            ap.serialize result_file
            Rails.logger.info "* Created excel file succeed: #{result_file}"

            # box_uploader = ::BackOffice::Box::Uploader.new
            # box_uploader.upload result_file, "#{Settings.file_system.box.sina_weibo_report_root}/#{sina_weibo_url_package.name}"
          end

          private

          def get_column_name(n)
            r = n % 26
            l = n / 26
            Rails.logger.debug "l: #{l} r: #{r}"
            first_char = COLUMN_NAMES_2[l]
            second_char = COLUMN_NAMES[r]
            "#{first_char}#{second_char}"
          end
        end
      end
    end
  end
end
