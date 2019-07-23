module JsonResponseHelpers
  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end

  def json_errors
    json['errors']
  end

  def json_attributes
    json_data['attributes']
  end
end
