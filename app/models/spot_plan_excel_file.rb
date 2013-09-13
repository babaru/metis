#encoding: utf-8

class SpotPlanExcelFile < UploadFile
  def parse!(client_id, user_id, file_format_type = nil)
    Tida::Metis::ExcelParsers::SpotPlans::CaratParser.parse!(client_id, user_id, self.data_file.path)
  end
end
