#encoding: utf-8

class SpotPlanExcelFile < UploadFile
  attr_accessor :project_name
  attr_accessible :project_name

  def parse(client_id, user_id, project_name)
    parser = Tida::Metis::ExcelParsers::SpotPlans::CaratParser.new(client_id, user_id)
    parser.parse(project_name, self.data_file.path)
  end
end
