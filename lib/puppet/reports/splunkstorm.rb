require 'puppet'
require 'yaml'
require 'json'
require 'rest-client'
require 'uri'

unless Puppet.version >= '2.6.5'
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:splunkstorm) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "splunkstorm.yaml"])
  raise(Puppet::ParseError, "SplunkStorm report config file #{configfile} not readable") unless File.exist?(configfile)
  CONFIG = YAML.load_file(configfile)
  SPLUNKSTORM_URL = 'https://api.splunkstorm.com'
  API_ENDPOINT = '/1/inputs/http'

  desc <<-DESC
  Send notification of reports to Splunk.
  DESC

  def process
    output = []
    self.logs.each do |log|
      output << log
    end

    @host = self.host
    self.status == 'failed' ? @failed = true : @failed = false
    @start_time = self.logs.first.time
    @elapsed_time = metrics["time"]["total"]

    report_metrics(output)
  end

  def report_metrics(output)
    event_metadata = {
      :sourcetype => 'generic_single_line',
      :host => @host,
      :project => CONFIG[:project_id]}

    status_event = {
      :failed => @failed,
      :start_time => @start_time,
      :end_time => Time.now,
      :elapsed_time => @elapsed_time,
      :exception => output}

    api_params = event_metadata.collect{ |k,v| [k, v].join('=') }.join('&')
    url_params = URI.escape(api_params)
    endpoint_path = [API_ENDPOINT, url_params].join('?')

    request = RestClient::Resource.new(
      SPLUNKSTORM_URL, :user => CONFIG[:access_token], :password => 'x'
    )

    request[endpoint_path].post(status_event.to_json)
  end
end
