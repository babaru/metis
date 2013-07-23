class SpotDataFile < UploadFile
  attr_accessible :website_id

  def website_id
    meta_data[:website_id]
  end

  def website_id=(val)
    meta_data[:website_id] = val
  end
end
