#encoding: utf-8

class SpotPlanExcelFile < UploadFile
  def parse(client_id, user_id, file_format_type = nil)
    parser = Tida::Metis::ExcelParsers::SpotPlans::CaratParser.new(client_id, user_id)
    parser.parse(self.data_file.path)
  end
end
