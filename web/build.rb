require 'erb'
require 'yaml'
require 'fileutils'

###############################################################################
# Build config
###############################################################################
@config = YAML.load(File.open("config.yml"))

###############################################################################
# Load master template
###############################################################################
template = File.open(@config["template_file"]).to_a.join

###############################################################################
# Define config class
###############################################################################
class Config
  
  attr_accessor :content
  
  def initialize(title, header, css, navigation)
    @title      = title
    @header     = header
    @css        = css
    @navigation = navigation
    @content    = ''
  end
  
  def get_binding
    binding
  end
  
end

###############################################################################
# Process data
###############################################################################
puts "Processing data...\n"
# Make sure output dir exists
if !File.exists?(@config["output_dir"])
  FileUtils.mkdir(@config["output_dir"])
else  
  # Clean out the output_dir if it exists
  FileUtils.rm_rf(Dir.glob(@config["output_dir"] + "/*"))
end
# First copy all static data over
FileUtils.cp_r(@config["static_dir"] + "/.", @config["output_dir"])
# Build a list of files to generate
files = []
FileUtils.cd(@config["page_dir"]) do
  Dir.glob("*") do |file|
    files << file if File.file?(file)
  end
end
config = Config.new(@config["title"], @config["header"], @config["css"], @config["navigation"])
# Generate our new buddies and introduce them to the @config["output_dir"]
for file in files
  config.content = File.open("%s/%s" % [@config["page_dir"], file]).to_a.join
  html = ERB.new(template)
  data = html.result(config.get_binding)
  f = File.open("%s/%s" % [@config["output_dir"], file], "w")
  data.split("\n").each do |line|
    f << line + "\n"
  end
  f.close
end
puts "Process complete.\n"
  