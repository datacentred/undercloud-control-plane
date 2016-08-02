require 'xmlsimple'
require 'curb'
require 'pp'

# Store the XML output from both OA's
@data = Hash.new




def enumerate_oa(name, url)
  c = Curl::Easy.new
  c.url = url
  c.ssl_verify_peer = false
  c.ssl_verify_host = false
  c.perform
  @data[name] = c.body_str 
end

enumerate_oa('left', "https://10.20.254.20/xmldata?item=all")
enumerate_oa('right', "https://10.20.254.40/xmldata?item=all")


 
ref = XmlSimple.xml_in(@data['left'])

pp ref['INFRA2'][0]['BLADES'][0]

