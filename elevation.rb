require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'cgi'

ELEVATION_BASE_URL = 'http://maps.googleapis.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getChart(chartData, chartDataScaling="-100,5000", chartType="lc",chartLabel="Elevation in Meters",chartSize="500x160",chartColor="0000FF")

	chart_args = {
		'cht' => chartType,
		'chs' => chartSize,
		'chl' => chartLabel,
		'chco' => chartColor,
		'chds' => chartDataScaling,
		'chxt' => 'x,y',
		'chxr' => '1,-500,5000'
	};

	dataString = "";

	for x in chartData
		dataString += x.to_s[0...-1] + ',';
	end
	dataString = 't:'+dataString
	dataString = dataString[0...-1];
	chart_args['chd'] = dataString.to_s;

	chartUrl = CHART_BASE_URL + '?chxt=' + CGI.escape(chart_args['chxt']) + '&chds=' + CGI.escape(chart_args['chds']) + '&chs=' + CGI.escape(chart_args['chs']) + '&cht=' + CGI.escape(chart_args['cht']) + '&chxr=' + CGI.escape(chart_args['chxr']) + '&chd=' + CGI.escape(chart_args['chd']) + '&chco=' + CGI.escape(chart_args['chco']) + '&chl=' + CGI.escape(chart_args['chl']);

	puts chartUrl

end

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false")

	elvtn_args = {
		'path' => path,
		'samples' => samples,
		'sensor' => sensor
	}

	url = ELEVATION_BASE_URL + '?path='+CGI.escape(elvtn_args['path'])+'&samples='+CGI.escape(elvtn_args['samples'])+'&sensor='+CGI.escape(elvtn_args['sensor']);

	resp = Net::HTTP.get_response(URI.parse(url))
	data = resp.body
	response = JSON.parse(data)

	elevationArray = Array.new

	for resultset in response['results']
		elevationArray << resultset['elevation']
	end

	getChart(chartData=elevationArray)
end

getElevation()

