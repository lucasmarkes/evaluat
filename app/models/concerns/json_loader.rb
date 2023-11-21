module JsonLoader
  extend ActiveSupport::Concern

  def load_json_file(filename)
    file_path = Rails.root.join('lib', "#{filename}.json")
    JSON.parse(File.read(file_path))
  end

  def load_json_erb_file(filename)
    file_path = Rails.root.join('lib', "#{filename}.json.erb")
    json_content = ERB.new(File.read(file_path)).result
    JSON.parse(json_content)
  end
end
