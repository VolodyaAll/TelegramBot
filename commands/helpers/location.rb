module LocationHelper

  CAMP_LATITUDE = 53.914988..53.915491
  CAMP_LONGITUDE = 27.568656..27.569486

  def save_valid_location?(str)
    FileUtils.mkdir_p(path_for_check(str)) unless File.exist?(path_for_check(str))
    if payload['location'] && valid_latitude? && valid_longitude?
      File.open(path_for_check(str) + 'location.txt', 'wb') do |file|
        file << payload['location']
      end
      return true
    else
      return false
    end
  end

  def valid_latitude?
    CAMP_LATITUDE.cover? payload['location']['latitude']
  end

  def valid_longitude?
    CAMP_LONGITUDE.cover? payload['location']['longitude']
  end
end