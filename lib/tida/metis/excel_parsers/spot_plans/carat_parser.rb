#encoding: utf-8
module Tida
  module Metis
    module ExcelParsers
      module SpotPlans
        class CaratParser
          attr_reader :client_id, :user_id

          def initialize(client_id, user_id)
            @client_id = client_id
            @user_id = user_id
          end

          def parse(excel_file)
            Spreadsheet.open excel_file do |excel|
              ws = excel.worksheet(0)
              master_plan_data = {}
              medium_name = nil

              calendar_month_row = ws.row(12)
              calendar_day_row = ws.row(13)

              calendar_array = []
              calendar_month_value = nil
              23.upto(ws.column_count) do |index|
                if calendar_day_row[index]
                  if calendar_month_row[index]
                    calendar_month_row.format(index).number_format = 'yyyy-mm-dd'
                    calendar_month_value = calendar_month_row[index]
                  end
                  calendar_day_row.format(index).number_format = '@'
                  calendar_array << Date.new(calendar_month_value.year, calendar_month_value.month, calendar_day_row[index].to_i)
                end
              end

              0.upto(ws.last_row_index) do |index|
                if index == 6
                  get_master_plan_name(master_plan_data, ws.row(index))
                end
                if index > 13
                  medium_name = get_medium_name(ws.row(index), medium_name)
                  get_master_plan_item(master_plan_data, medium_name, ws.row(index), calendar_array)
                end
              end

              Rails.logger.debug "name: #{master_plan_data[:name]}"
              master_plan_data[:master_plan_items].each do |mpi|
                # Rails.logger.debug "mpi[:medium_name]: #{mpi[:medium_name]}"
                # Rails.logger.debug "mpi[:channel_name]: #{mpi[:channel_name]}"
                # Rails.logger.debug "mpi[:spot_name]: #{mpi[:spot_name]}"
                # Rails.logger.debug "mpi[:material_format]: #{mpi[:material_format]}"
                # Rails.logger.debug "mpi[:pv_tracking]: #{mpi[:pv_tracking]}"
                # Rails.logger.debug "mpi[:click_tracking]: #{mpi[:click_tracking]}"
                # Rails.logger.debug "mpi[:link_to_official_site]: #{mpi[:link_to_official_site]}"
                # Rails.logger.debug "mpi[:mr_deadline]: #{mpi[:mr_deadline]}"
                # Rails.logger.debug "mpi[:est_imp]: #{mpi[:est_imp]}"
                # Rails.logger.debug "mpi[:est_clicks]: #{mpi[:est_clicks]}"
                # Rails.logger.debug "mpi[:est_clicks]: #{mpi[:est_clicks]}"
                # Rails.logger.debug "mpi[:est_total_imp]: #{mpi[:est_total_imp]}"
                # Rails.logger.debug "mpi[:est_total_clicks]: #{mpi[:est_total_clicks]}"
                # Rails.logger.debug "mpi[:est_ctr]: #{mpi[:est_ctr]}"
                # Rails.logger.debug "mpi[:est_cpc]: #{mpi[:est_cpc]}"
                # Rails.logger.debug "mpi[:est_cpm]: #{mpi[:est_cpm]}"
                # Rails.logger.debug "mpi[:count]: #{mpi[:count]}"
                # Rails.logger.debug "mpi[:cpc] : #{mpi[:cpc] }"
                # Rails.logger.debug "mpi[:unit_rate_card]: #{mpi[:unit_rate_card]}"
                # Rails.logger.debug "mpi[:reality_company_discount]: #{mpi[:reality_company_discount]}"
                # Rails.logger.debug "mpi[:reality_company_net_cost]: #{mpi[:reality_company_net_cost]}"
                # Rails.logger.debug mpi[:spot_plan]
              end

              Project.transaction do
                @project = HistoryProject.create!({
                  name: master_plan_data[:name],
                  client_id: self.client_id,
                  created_by_id: self.user_id,
                  budget: 0.1,
                  started_at: calendar_array.first,
                  ended_at: calendar_array.last,
                  is_started: true,
                  is_started_at: Time.now
                })

                master_plan = @project.current_master_plan
                master_plan_data[:master_plan_items].each do |item_data|
                  item_data[:master_plan_id] = master_plan.id
                  medium = Medium.where("name like '%#{item_data[:medium_name]}%'").first
                  Rails.logger.error "Not found medium named #{item_data[:medium_name]}" if medium.nil?
                  if medium
                    medium_master_plan = HistoryMediumMasterPlan.create_by_data!(
                      {
                        medium_id: medium.id,
                        master_plan_id: master_plan.id,
                        reality_company_discount: item_data[:discount],
                        is_history: true
                      }
                    )
                    item_data[:medium_id] = medium.id
                    item_data[:medium_master_plan_id] = medium_master_plan.id
                    item_data[:client_name] = @project.client.name
                    item_data[:project_name] = @project.name
                    spot_plan = item_data.delete(:spot_plan)
                    master_plan_item = HistoryMasterPlanItem.create!(item_data)
                    spot_plan.each_with_index do |item, index|
                      SpotPlanItem.create!({
                        master_plan_id: master_plan.id,
                        master_plan_item_id: master_plan_item.id,
                        count: item,
                        placed_at: calendar_array[index]
                      }) if item
                    end
                  end
                end

                Rails.logger.info "Succeed to create master plan #{master_plan.id}"
              end
            end
            @project
          end

          private

          def get_master_plan_name(mp, row)
            title = row[1]
            title = title.gsub('Product:', '').strip if title
            mp[:name] = title #TODO add unique name
          end

          def get_medium_name(row, medium_name)
            return row[2].gsub(/\s+/, ';').split(';')[0] unless row[2].nil?
            medium_name
          end

          def get_master_plan_item(mp, medium_name, row, calendar_array)
            if row && row[3] && row[3].strip.length > 0
              row.default_format.number_format = '@'
              mpi = {}
              mpi[:medium_name] = medium_name
              mpi[:channel_name] = row[3]
              mpi[:spot_name] = row[4]
              mpi[:material_format] = row[5]
              mpi[:pv_tracking] = row[6]
              mpi[:click_tracking] = row[7]
              mpi[:link_to_official_site] = row[8]
              mpi[:mr_deadline] = row[9]
              mpi[:est_imp] = get_integer_field_value(row[10])
              mpi[:est_clicks] = get_integer_field_value(row[11])
              mpi[:est_total_imp] = get_integer_field_value(row[12])
              mpi[:est_total_clicks] = get_integer_field_value(row[13])
              mpi[:est_ctr] = get_decimal_field_value(row[14])
              mpi[:est_cpc] = get_integer_field_value(row[15])
              mpi[:est_cpm] = get_integer_field_value(row[16])
              mpi[:count] = get_integer_field_value(row[17])
              mpi[:cpc] = get_integer_field_value(row[18])
              mpi[:unit_rate_card] = get_integer_field_value(row[19])
              mpi[:reality_company_discount] = get_decimal_field_value(row[20])
              mpi[:reality_company_net_cost] = get_integer_field_value(row[21])
              mpi[:is_on_house] = true if mpi[:reality_company_net_cost] == 0
              mpi[:spot_plan] = []
              (0..calendar_array.length - 1).each do |n|
                spot_count = get_integer_field_value(row[23 + n])
                mpi[:spot_plan] << spot_count
              end
              # mpi[:total_rate_card] = get_integer_field_value(row[22])
              mp[:master_plan_items] = [] if mp[:master_plan_items].nil?
              mp[:master_plan_items] << mpi
            end
          end

          def get_integer_field_value(field)
            val = get_field_value field
            return nil unless val
            val.to_i
          end

          def get_decimal_field_value(field)
            val = get_field_value field
            return nil unless val
            val.to_f
          end

          def get_field_value(field)
            return nil unless field
            return field.value if field.is_a?(Spreadsheet::Formula)
            field
          end

          def get_spot_plan
          end
        end
      end
    end
  end
end
